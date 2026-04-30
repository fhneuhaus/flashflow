# FlashFlow — Tech Stack

*Layer 8 of the design sequence. Status: accepted, session 02 (evening).*

## Purpose

This document records the specific technologies chosen to implement
the architecture defined in Layer 7. Each decision is one place where
the abstract architectural roles ("application server", "database",
"scheduler service") are filled by concrete products.

The decisions are listed in roughly the order they were settled. Some
have real reasoning behind them; some are near-defaults. The depth of
treatment below reflects how much the choice actually mattered, not
how important the technology is in the running system.

## The decisions

| Role                          | Choice         |
|-------------------------------|----------------|
| Language (Node.js side)       | TypeScript     |
| Node.js web framework         | Fastify        |
| Database family               | Relational     |
| Database product              | PostgreSQL     |
| Database access layer         | Kysely         |
| Python web framework          | FastAPI        |
| Hosting platform              | Fly.io         |
| Package manager (Node.js)     | npm            |
| Env vars / secrets handling   | dotenv (local) + `flyctl secrets` (prod) |
| Logging                       | pino           |

## Language: TypeScript over JavaScript

TypeScript is JavaScript plus *static type checking* — types are
checked at write time, before the code runs. The output compiles to
plain JavaScript; the type checker is the build-time discipline.

The trade-off was real: JavaScript is the simpler tool, with no
compile step and a gentler first-month learning curve. TypeScript adds
machinery (the compiler, the configuration file, the type system
itself) and roughly an hour of extra friction in the first sessions.

The decision turned on the WhiteGlove constraint. WhiteGlove will use
TypeScript; choosing JavaScript here would mean doing the same task
twice and missing the practice on the type system that is most of
what TypeScript actually is. The skill-level constraint pulled
slightly the other way ("favour plain widely-used tools"), but
TypeScript is no longer the clever choice — it is the industry-standard
choice for serious new Node.js projects in 2026.

## Node.js web framework: Fastify

Fastify (2016, Matteo Collina and Tomas Della Vedova) is the modern
deliberate rewrite of the Express idea. Same middleware pattern; same
route-handler shape; built on contemporary Node.js features.

The realistic alternative was Express (2010), which has the larger
ecosystem and the wider tutorial coverage but shows its age. Type
support is bolted on; error handling predates `async/await`; the
defaults reflect a different era of Node.js.

Fastify's TypeScript story is first-class — types written by the
maintainers, integral to the design rather than retrofitted. Schema
validation is built in. The framework is mature (a decade old in
production) without being legacy. New serious TypeScript/Node.js
projects in 2026 are increasingly Fastify rather than Express, and
the muscle memory built here transfers to that direction-of-travel.

## Database family: relational

The choice between relational and document was effectively settled by
the domain model — five well-defined entity types with clear
foreign-key-shaped relationships fit relational naturally and
document awkwardly.

Worth being honest about the circularity: the domain model itself was
drawn in entity-relationship style (Peter Chen, 1976), which is
already half a database schema. The "perfect fit" between the model
and a relational store is partly a self-fulfilling prophecy. The
independent reasons for relational still hold — SQL is one of the
most durable skills in software engineering, and WhiteGlove will
almost certainly be relational too — but the "look how well it fits"
argument is weaker than it looks.

## Database product: PostgreSQL over SQLite

The most genuinely contested decision in Layer 8.

SQLite (2000, D. Richard Hipp) is operationally trivial — the
database is a file, no server to run, no connection string to manage.
Writing the FlashFlow application on SQLite would be measurably
faster, and SQL skills transfer cleanly to any other relational
database when needed.

PostgreSQL (1986 origins, modern through the 2000s) is the serious
relational database. It runs as a separate server process; the
application connects to it over a network (even when "the network"
is local). This adds operational machinery: installing the server,
managing connection strings, separating development and production
databases, handling credentials.

The case for SQLite was simplicity-first: spend the 50-hour budget
on application code, not on database operations. The case for
PostgreSQL was WhiteGlove preparation — the operational machinery
that PostgreSQL forces you to confront (connection strings,
environment variables, database servers as their own concerns) is
exactly the machinery WhiteGlove will require, and getting that
practice on a low-stakes project is direct preparation.

A subtlety also tilted the decision: at deployment time, the
PostgreSQL story is *simpler* than the SQLite story on a Platform-
as-a-Service. Every PaaS offers managed PostgreSQL as a one-click
add-on; SQLite needs persistent-volume configuration that not every
platform handles cleanly. The "SQLite is simpler" argument is true
during local development and increasingly false after deployment.

PostgreSQL chosen with the cost named: roughly 4–8 hours of
operational setup that wouldn't apply with SQLite, plus the discipline
of separating local-dev and production databases throughout.

## Database access layer: Kysely

The third genuinely contested decision. Three approaches were on the
table:

- **Raw SQL with a thin driver** (`pg` for PostgreSQL): full SQL
  visibility, durable skills, but TypeScript can't check the queries
  — a misspelled column name passes the type checker and fails at
  runtime.
- **Object-Relational Mapper** (Prisma or Drizzle): high productivity,
  pleasant TypeScript types, but the database is hidden behind an
  abstraction that leaks at the edges. The classic
  *object-relational impedance mismatch* — objects and tables aren't
  the same shape, and any tool pretending they are will sometimes
  lie.
- **Query builder** (Kysely): TypeScript-checked queries with the SQL
  shape preserved. Code looks like TypeScript; SQL is generated;
  the type checker catches schema mismatches.

Kysely is the option where TypeScript and the database meet most
directly. The SQL stays visible (preparation that translates to any
relational database, including WhiteGlove's). The TypeScript types
are exercised meaningfully, validating queries against the schema.
The skill is more portable than ORM-specific knowledge — "I know
Kysely" and "I know SQL" are similar statements; "I know Prisma"
is more specific.

Prisma was the realistic counter. It is the more polished, more
widely-used tool, and a legitimate choice for a project that wanted
to ship fast and accept the abstraction. The decision tilted to
Kysely on the same grain that ran through every Layer 8 choice:
favour the option where the underlying machinery stays visible.

## Python web framework: FastAPI

FastAPI (2018) is the modern Python default for new web services.
Type-driven by design — Python type hints describe what each
endpoint accepts and returns, and FastAPI uses those types for
validation, documentation, and serialisation.

Flask (2010) was the realistic alternative, the Python equivalent of
Express. More tutorials, larger community, but a legacy feel and
type-hint support that is bolted on rather than central.

The choice was easy: FastAPI is the modern direction-of-travel,
exercises the same type-driven discipline as Fastify on the Node.js
side (same pattern, two languages — useful reinforcement), and is
what WhiteGlove's pricing-model service will almost certainly use.
The free auto-generated interactive API documentation
(Swagger UI) is a pleasant bonus that becomes useful as the
scheduler's interface grows.

The scheduler is small (four or five endpoints) and stateless, so
the framework's heavier features go unused. Any of the three options
would work; FastAPI was picked for what it teaches, not what it
provides.

## Hosting platform: Fly.io

The fourth genuinely contested decision.

Both serious candidates were Platform-as-a-Service offerings: places
that take a Git repository, run the code on Linux machines somewhere,
expose it at a URL, and hide the operating system. Other categories
(raw Linux servers, serverless functions, database-bundled
platforms) were considered and discarded — too much operational
overhead, too many platform-specific quirks, or not the right shape
for FlashFlow's two-service architecture.

**Render** is dashboard-first: web UI, click-to-configure, gentlest
learning curve. **Fly.io** is CLI-first: you install `flyctl`, run
commands, configuration lives in `fly.toml` files in the repository.

Render would have been faster to first deployment — perhaps 1–2
hours versus 2–4 hours for Fly. Two specific Render-only frictions
also weighed:

- Free-tier services sleep after 15 minutes of inactivity; the first
  request after a quiet period takes 30+ seconds. For an app
  reviewed daily on a phone, this would degrade the actual use
  experience.
- Free PostgreSQL databases expire after 90 days, forcing a paid
  upgrade or migration just as the system reaches steady state.

Fly's pattern (CLI plus configuration files in the repository) is
also closer to how serious infrastructure works at the larger
scales WhiteGlove will eventually involve — the same pattern shows
up in AWS, Google Cloud, Kubernetes, Terraform. Render's dashboard-
driven pattern is increasingly the exception rather than the rule
in infrastructure work.

The cost: roughly 2 extra hours of setup compared to Render. Real,
absorbed from the buffer in the time budget. Worth it for the
preparation value and the better daily-use experience.

## Smaller pieces

These are default-grade decisions; included for completeness without
elaboration.

- **npm** as Node.js package manager. Built into Node.js, universally
  assumed by tutorials, fewer moving parts than the alternatives
  (pnpm, yarn). The marginal benefits of pnpm don't justify the
  extra tool at this scale.

- **dotenv** for local development environment variables, with
  `flyctl secrets` for production. The standard pattern. The
  discipline that matters: `.env` is never committed to Git
  (`.env` listed in `.gitignore`); `.env.example` is committed
  showing variable names without values.

- **pino** for logging. Fastify's native pairing — same maintainer,
  designed together. Structured JSON logs from day one rather than
  ad-hoc `console.log` strings that become hard to search later.

## What was deliberately consistent

A pattern ran through every contested Layer 8 decision: when faced
with "easier learning curve now" versus "closer preparation for
WhiteGlove and serious engineering practice", the answer was
consistently the latter. TypeScript over JavaScript. Fastify over
Express. PostgreSQL over SQLite. Kysely over an ORM. FastAPI over
Flask. Fly.io over Render. Each individual decision could have gone
the other way; the cumulative pattern was deliberate.

The pattern's cost is real — Layer 8 sits at the harder edge of what
a 50-hour first project can absorb, and the buffer in the time
budget will be needed. The benefit, if the pattern holds, is that
WhiteGlove starts with most of the tooling already familiar.

## Out of scope for this document

- Specific code structure (folder layout, file naming, module
  conventions) — emerges during scaffolding, not predetermined here.
- Frontend framework or templating choices — not yet decided; the
  PWA may need a framework or may not.
- Testing tools — `goals.md` constrains tests to the scheduler;
  framework choice (Vitest, Jest, pytest) follows when scaffolding
  reaches that file.
- Deployment scripts, CI/CD pipelines — emerge alongside actual
  deployment work in Layer 9 and beyond.
- Monitoring, error reporting, analytics — out of v1 scope per
  `goals.md`.
