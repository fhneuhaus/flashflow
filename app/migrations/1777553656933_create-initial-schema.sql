-- Up Migration

CREATE TABLE subjects (
  id UUID PRIMARY KEY,
  title TEXT NOT NULL,
  source TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE chapters (
  id UUID PRIMARY KEY,
  subject_id UUID NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  source TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE cards (
  id UUID PRIMARY KEY,
  chapter_id UUID NOT NULL REFERENCES chapters(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  answer TEXT NOT NULL,
  source TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE ladder_entries (
  id UUID PRIMARY KEY,
  card_id UUID NOT NULL REFERENCES cards(id) ON DELETE CASCADE,
  kind TEXT NOT NULL CHECK (kind IN ('initial', 'pass', 'fail')),
  date DATE NOT NULL,
  interval_days INTEGER,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CHECK (
    (kind = 'pass' AND interval_days IS NOT NULL) OR
    (kind IN ('initial', 'fail') AND interval_days IS NULL)
  )
);

CREATE INDEX idx_chapters_subject_id ON chapters(subject_id);
CREATE INDEX idx_cards_chapter_id ON cards(chapter_id);
CREATE INDEX idx_ladder_entries_card_id ON ladder_entries(card_id);
CREATE INDEX idx_ladder_entries_card_date ON ladder_entries(card_id, date);

-- Down Migration

DROP TABLE IF EXISTS ladder_entries;
DROP TABLE IF EXISTS cards;
DROP TABLE IF EXISTS chapters;
DROP TABLE IF EXISTS subjects;