import 'dotenv/config';
import Fastify from 'fastify';
import { sql } from 'kysely';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';
import view from '@fastify/view';
import ejs from 'ejs';
import { db } from './db.js';
import { listAllCards, getCardById } from './queries.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const fastify = Fastify({
  logger: true,
});

await fastify.register(view, {
  engine: { ejs },
  root: join(__dirname, '..', 'views'),
});

fastify.get('/', async (request, reply) => {
  const cards = await listAllCards();
  return reply.view('cards-list.ejs', { cards });
});

fastify.get('/cards/:id', async (request, reply) => {
  const { id } = request.params as { id: string };
  const result = await getCardById(id);
  if (!result) {
    reply.code(404);
    return reply.view('cards-list.ejs', { cards: [] });
  }
  return reply.view('card-detail.ejs', result);
});

fastify.get('/health', async () => {
  const result = await sql`SELECT 1 AS ok`.execute(db);
  return { status: 'ok', database: 'connected', result: result.rows };
});

fastify.get('/subjects', async () => {
  const subjects = await db
    .selectFrom('subjects')
    .selectAll()
    .execute();
  return { subjects };
});

const start = async () => {
  try {
    await fastify.listen({ port: 3000, host: '0.0.0.0' });
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();