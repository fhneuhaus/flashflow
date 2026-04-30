-- Seed data for FlashFlow walking skeleton
-- One subject, one chapter, five cards, five initial ladder entries.

INSERT INTO subjects (id, title, source) VALUES
  ('00000000-0000-0000-0000-000000000001', 'Software Craft', 'FlashFlow build sessions');

INSERT INTO chapters (id, subject_id, title) VALUES
  ('00000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000001', 'Methodology and Process');

INSERT INTO cards (id, chapter_id, question, answer) VALUES
  ('00000000-0000-0000-0000-000000000100',
   '00000000-0000-0000-0000-000000000010',
   'How many layers does the top-down software development sequence have?',
   'Nine.'),
  ('00000000-0000-0000-0000-000000000101',
   '00000000-0000-0000-0000-000000000010',
   'What does YAGNI stand for, and what does it mean?',
   '''You Aren''t Gonna Need It.'' A discipline against building features you don''t currently need, even when you can imagine needing them. Coined by Ron Jeffries in the late 1990s.'),
  ('00000000-0000-0000-0000-000000000102',
   '00000000-0000-0000-0000-000000000010',
   'What is a vertical slice in software development?',
   'A thin end-to-end implementation that touches every layer of the system but does almost nothing. Proves the layers connect before any layer does real work.'),
  ('00000000-0000-0000-0000-000000000103',
   '00000000-0000-0000-0000-000000000010',
   'Who coined the term ''walking skeleton'' for the vertical-slice pattern, and when?',
   'Alistair Cockburn, in the early 2000s. The skeleton has all its bones connected but no flesh yet — it can walk, it just can''t do anything else.'),
  ('00000000-0000-0000-0000-000000000104',
   '00000000-0000-0000-0000-000000000010',
   'What does ''fail-fast'' mean as a programming discipline?',
   'Crashing immediately on encountering a problem (e.g. missing configuration), rather than continuing in a broken state. Produces clearer errors at the point of failure rather than confusing errors later.');

INSERT INTO ladder_entries (id, card_id, kind, date) VALUES
  ('00000000-0000-0000-0000-000000001000',
   '00000000-0000-0000-0000-000000000100',
   'initial', CURRENT_DATE),
  ('00000000-0000-0000-0000-000000001001',
   '00000000-0000-0000-0000-000000000101',
   'initial', CURRENT_DATE),
  ('00000000-0000-0000-0000-000000001002',
   '00000000-0000-0000-0000-000000000102',
   'initial', CURRENT_DATE),
  ('00000000-0000-0000-0000-000000001003',
   '00000000-0000-0000-0000-000000000103',
   'initial', CURRENT_DATE),
  ('00000000-0000-0000-0000-000000001004',
   '00000000-0000-0000-0000-000000000104',
   'initial', CURRENT_DATE);
