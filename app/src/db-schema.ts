export interface Database {
  subjects: SubjectsTable;
  chapters: ChaptersTable;
  cards: CardsTable;
  ladder_entries: LadderEntriesTable;
}

export interface SubjectsTable {
  id: string;
  title: string;
  source: string | null;
  created_at: Date;
}

export interface ChaptersTable {
  id: string;
  subject_id: string;
  title: string;
  source: string | null;
  created_at: Date;
}

export interface CardsTable {
  id: string;
  chapter_id: string;
  question: string;
  answer: string;
  source: string | null;
  created_at: Date;
}

export interface LadderEntriesTable {
  id: string;
  card_id: string;
  kind: 'initial' | 'pass' | 'fail';
  date: Date;
  interval_days: number | null;
  created_at: Date;
}