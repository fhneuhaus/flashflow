import { db } from './db.js';

export async function listAllCards() {
  return await db
    .selectFrom('cards')
    .innerJoin('chapters', 'chapters.id', 'cards.chapter_id')
    .innerJoin('subjects', 'subjects.id', 'chapters.subject_id')
    .select([
      'cards.id',
      'cards.question',
      'cards.answer',
      'chapters.title as chapter_title',
      'subjects.title as subject_title',
    ])
    .orderBy('cards.created_at', 'asc')
    .execute();
}

export async function getCardById(id: string) {
  const card = await db
    .selectFrom('cards')
    .innerJoin('chapters', 'chapters.id', 'cards.chapter_id')
    .innerJoin('subjects', 'subjects.id', 'chapters.subject_id')
    .select([
      'cards.id',
      'cards.question',
      'cards.answer',
      'cards.source as card_source',
      'chapters.title as chapter_title',
      'chapters.source as chapter_source',
      'subjects.title as subject_title',
      'subjects.source as subject_source',
    ])
    .where('cards.id', '=', id)
    .executeTakeFirst();

  if (!card) return null;

  const ladderEntries = await db
    .selectFrom('ladder_entries')
    .select(['id', 'kind', 'date', 'interval_days'])
    .where('card_id', '=', id)
    .orderBy('date', 'asc')
    .execute();

  return { card, ladderEntries };
}