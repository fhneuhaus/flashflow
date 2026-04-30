import 'dotenv/config';
import Fastify from 'fastify';
import { sql } from 'kysely';
import { db } from './db.js';

const fastify = Fastify({
  logger: true,
});

fastify.get('/', async () => {
  return { hello: 'world' };
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