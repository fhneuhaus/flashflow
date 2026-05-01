# FlashFlow — Session 02 Progress

*Status: end of session 02. Layers 7–9 complete; entire design space closed. Phases 1–4 of the build complete. Walking skeleton deployed and verified on every target device. Two-machine workflow proven through real friction and recovery.*

---

## What this session was about

A long working session covering both the closing of the design space (Layers 7, 8, 9) and the opening four phases of the build (scaffolding, deployment, database, walking skeleton). The session began as a short focused stretch on Layer 7 (Architecture) and grew into the most substantive working session of the project so far.

The session also produced three things beyond the planned work: the discipline of session resumption from source documents (named after two false alarms early in the session); the discipline of two-machine workflow (formalised after real friction transferring work between iMac and MacBook); and a working pattern of out-of-band file sharing via raw GitHub URLs that became the default for the rest of the session.

This note replaces the earlier partial version that covered only the first stretch of the session.

---

## Major decisions and pivots (in chronological order)

### 1. Architecture accepted: three components, two languages

The Layer 7 decision: a three-component system. Browser (PWA client) talks to a Node.js application server, which in turn talks to a database for storage and to a Python scheduler service for algorithmic decisions. Two HTTP/REST connections in the system; the database connection is a driver, not HTTP.

The Python carve-out is deliberate. Its rationale is **learning value, not user value**: the FlashFlow scheduler is a small-scale rehearsal for WhiteGlove's pricing model. Practising the seam between an application server and an algorithmic service in FlashFlow prepares the same pattern at WhiteGlove's scale.

A simpler architecture (Node.js does everything; the scheduler is an in-process function call) would be entirely defensible for FlashFlow alone. The carve-out earns its place against the project's stated criterion: every feature must justify itself in user value or learning value.

### 2. False alarm one: the "authoring" terminology drift

In the architecture draft, the application server's responsibilities included "authoring." The user pushed back: "authoring? really? I thought in v1 there is only csv import to the db."

The exchange revealed that the word **authoring** was carrying different meanings for the developer (any way new cards enter the system) and the user (bulk loading specifically; "edit existing" was the user's intuitive sense of in-app card work).

The conversation drifted toward dropping in-app card creation from v1. It was nearly a real scope reduction — a Layer 2 change made in passing on the basis of conversation drift, not deliberate decision.

The defect was caught when `goals.md` was finally fetched and read directly: it explicitly lists "ad-hoc card creation, editing, moving, and deleting" as a v1 goal. The conversation had been about to remove a stated goal because of terminology drift in the architecture document.

**Resolution**: Path 1 chosen — keep in-app card creation in v1, exactly as `goals.md` specifies. The architecture draft already used the language correctly. No documents changed.

### 3. False alarm two: the paper-fidelity drift

While considering whether to defer in-app card creation, the conversation tilted toward "the paper system batches authoring into print runs of eight, so v1's batch-only authoring would match the paper rhythm." The user pushed back again: "the overarching goal of this learning exercise is not to digitally mimic the paper system — but to model after it and learn for whiteglove while doing so."

This restated and reinforced **the project's primary criterion**: learning value with WhiteGlove as the destination, with paper-fidelity as a third-tier consideration. The criterion was always in `vision.md` but had quietly slipped under both the developer's and assistant's radars during the back-and-forth.

### 4. Discipline named: digest documents at session resumption

Both false alarms had a common cause: the assistant began the session working from the `session-01-progress.md` summary alone, without the underlying layer documents. The summary was good for orientation but lossy for substance.

The user named the discipline explicitly: *"I need to have you digest all the design documents after a long pause."*

The right opening pattern for resumed sessions, then:
1. Enumerate explicitly what is in context.
2. Identify what the next session's work will touch.
3. Close any gap before substantive work begins.
4. Re-read documents directly; do not work from summaries of them.

This is the most valuable output of the early portion of the session. Architecture documents can be redrafted; disciplines compound. The discipline applies more strongly the longer the gap, and applies particularly to WhiteGlove, which will run for years.

### 5. Public repository → out-of-band sharing of files via raw URLs

The repository was already public (set up in session 01); a new pattern was used to make documents available to the assistant: paste raw GitHub URLs (`raw.githubusercontent.com/.../docs/X.md`) and the assistant fetches them. This is *out-of-band sharing* — the files arrive through a different channel than the conversation itself.

The pattern is faster than uploading via dialog and works for any committed file. It became the working method for the rest of the session.

### 6. Layer 8 — Tech Stack accepted (eight decisions)

A substantial layer. Each role from the architecture filled with a concrete technology choice:

| Role | Choice |
|---|---|
| Language (Node.js side) | TypeScript |
| Node.js web framework | Fastify |
| Database family | Relational |
| Database product | PostgreSQL |
| Database access layer | Kysely |
| Python web framework | FastAPI |
| Hosting platform | Fly.io |
| Package manager | npm |
| Env vars / secrets | dotenv (local) + flyctl secrets (prod) |
| Logging | pino |

A pattern ran through every contested decision: when faced with "easier learning curve now" versus "closer preparation for WhiteGlove and serious engineering practice," the answer was consistently the latter. TypeScript over JavaScript. Fastify over Express. PostgreSQL over SQLite. Kysely over an ORM. FastAPI over Flask. Fly.io over Render. Each individual decision could have gone the other way; the cumulative pattern was deliberate.

The Layer 8 document includes a Mermaid architecture diagram showing the components labelled with their chosen technologies — the architecture from Layer 7 made concrete.

### 7. Layer 9 — Roadmap accepted (eight phases)

The bridge from design to code. Eight phases, sequenced by front-loading risk:

1. Scaffolding (3h)
2. First deployment (4h)
3. Database setup (4h)
4. Walking skeleton (4h)
5. Scheduler design + Python implementation + tests (5h)
6. Pass/Fail flow + scheduler integration (6h)
7. Edit + maintenance flows (5h)
8. CSV import + PWA + polish (6h)
9. Buffer (1h)

Total of 38 hours against the ~38 remaining of the 50-hour budget at the time the roadmap was accepted.

Named contingency: if behind by Phase 5–6, drop PWA configuration to v1.5. The non-negotiable items: scheduler with tests, edit-during-review, deployment.

### 8. README refreshed twice

After Layer 7 acceptance and again after Layer 9. The README is the entry point for any future reader; keeping it current with what's actually in the repo is a small but real discipline.

### 9. Constraints document updated: Berlin timezone

A late-session addition to `constraints.md`: the developer is in Berlin (CET/CEST). This is a Process constraint that affects the scheduler design — "today" is the user's local day, which means the scheduler must read a configurable timezone rather than defaulting to UTC. Captured now so it isn't forgotten when Phase 5 begins.

### 10. Seed cards: 82 → 162 across the working session

Two batches of card additions through the session: 30 cards added after the early portion (taking the deck to 112), then another 50 cards at the close (taking it to 162). The second batch was substantial enough to justify splitting **Database** out of **Tools and Infrastructure** as its own chapter — 19 cards on SQL, PostgreSQL, Kysely, migrations, and related concepts.

The card-writing discipline from session 01 held: each card atomic, answers ≤3 items, 80–90% recall band as target.

### 11. Phase 1 — Scaffolding complete

End-state: a Node.js project structured per Pattern B (project root holds `docs/` and `app/`, with the application code under `app/`), TypeScript configured, Fastify installed, hello-world server running locally on port 3000.

The project structure:

```
flashflow/
├── README.md
├── docs/
└── app/
    ├── package.json
    ├── package-lock.json
    ├── tsconfig.json
    ├── .gitignore
    ├── .env.example
    └── src/
        └── server.ts
```

Configuration choices made during scaffolding:

- **TypeScript with strict mode** — every type-checking option enabled. Catches more issues at build time.
- **ES modules** (`"type": "module"` in package.json) — modern Node.js convention, alignment with WhiteGlove's likely setup.
- **Fastify with logger** — `pino` enabled by default, structured JSON logs from the first request.

The `.env.example` file pattern was set up but `.env` was not yet needed (no environment-dependent values yet).

### 12. Phase 2 — Deployment to Fly.io complete

End-state: hello-world deployed to Fly.io, accessible at `https://flashflow.whiteglove.exchange` over HTTPS, verified on iMac, MacBook, and iPhone.

The deployment chain that had to be built:

- `flyctl` installed and authenticated against the Fly account.
- `fly launch` run from inside `app/` to create the Fly app and `fly.toml`. Several frictions surfaced and were handled: misplaced files (`fly.toml` and `.dockerignore` initially landed at the repo root rather than inside `app/`), missing Dockerfile (had to be written by hand because `fly launch` didn't generate one), nested `app/app/` folder created by a path-relative command run from the wrong directory.
- `fly.toml` corrected: region from `ams` (Amsterdam, Fly's auto-detected fastest) to `fra` (Frankfurt, the deliberate choice for proximity to Berlin), and internal port from 8080 to 3000 to match the Fastify server.
- Custom domain configured: `fly certs add flashflow.whiteglove.exchange`, then DNS records added at Cloudflare (A and AAAA), with one IPv6 typo caught (`a09:8280:1::10e:3d2f:0` corrected to `2a09:8280:1::10e:3d2f:0` — leading `2` was missing) and Cloudflare proxy disabled (grey cloud, "DNS only") on both records.
- TLS certificate issued by Let's Encrypt within seconds of the DNS records being correct.

The deployment moment — `{"hello":"world"}` rendering on the iPhone over HTTPS at the custom domain — closed Phase 2.

### 13. Phase 3 — PostgreSQL setup complete

End-state: PostgreSQL running locally on the iMac (later also on the MacBook) and in production on Fly.io, both with the same five-table schema, with the application server able to query both databases through Kysely.

The work spread across local and production:

**Local**: Homebrew install of PostgreSQL 16 (version pinned deliberately), service started, `flashflow_dev` database created, `pg` and `kysely` and `dotenv` installed as dependencies, `@types/pg` as a dev dependency, `src/db.ts` created with a connection pool reading `DATABASE_URL` from `.env`, `/health` route added that runs `SELECT 1` against the database to prove the connection.

**Schema**: five tables (subjects, chapters, cards, ladder_entries, plus the migration tool's bookkeeping table). Three sub-decisions resolved before writing the schema:

- **ID strategy**: UUID v7 over integer auto-increment. UUIDs generated in application code rather than via `DEFAULT uuidv7()` because PostgreSQL 16 lacks the function (added in PostgreSQL 18).
- **Ladder schema**: two tables (cards and ladder_entries) with a discriminator `kind` column and nullable `interval_days`, with a `CHECK` constraint enforcing the polymorphic invariant (Pass entries have an interval; Initial and Fail don't). The single-table approach was chosen over three separate tables for simplicity.
- **Migration tool**: `node-pg-migrate` over Kysely's built-in migrations. SQL-first migrations chosen for visibility into what's actually being run against the database.

The user pushed back on the schema mid-design with a real question: should fail rows carry the interval-at-time-of-failure, to make algorithm look-back easier? Reasoning produced a substantive trade-off analysis (data redundancy versus query simplicity) and a deliberate choice to keep the schema as drafted (look-back at recovery time, no denormalisation, YAGNI applies). Worth flagging that this kind of question belongs in the future scheduler design document — schema and algorithm are intertwined.

**Production**: PostgreSQL provisioned on Fly via `fly postgres create`, attached to the `flashflow` app via `fly postgres attach`, with the connection details (including the database password) returned by Fly. The migration was run against production via `fly proxy` (a tunnel from local port 5433 to the production database) and a one-shot `DATABASE_URL=... npm run migrate:up` invocation.

**A real security incident**: the production database password leaked into the conversation transcript (the `fly postgres attach` output was pasted in full, password included). The discipline kicked in: rotate immediately. Procedure: detach the database from the app, re-attach (which generates a new password), deploy the new secret. The application code never changed — the credential rotation was a configuration operation, exactly as the environment-variable pattern intends.

**Verification**: a `/subjects` route added to Fastify that runs a real Kysely query (`SELECT * FROM subjects`), with a typed `Database` interface in `src/db-schema.ts` describing the schema for TypeScript. End-to-end test: insert a row via psql, refresh the route, see the row appear. Real query, real data, real round-trip.

Phase 3 closed when the same `/subjects` route worked in production after `fly deploy`.

### 14. Phase 4 — Walking skeleton complete

End-state: opening `https://flashflow.whiteglove.exchange/` shows a list of five cards from the production database, each clickable to a detail view rendering the card's question, answer, breadcrumb (subject and chapter), and ladder. Verified on iMac, MacBook, and iPhone.

The work:

- **`@fastify/view` and `ejs` installed** as the template engine. Plus `@types/ejs` (devDependency) so TypeScript could compile.
- **`server.ts` updated** to register the view plugin with EJS as the engine, pointing at a new `views/` folder.
- **A query layer** added in `src/queries.ts` with two functions: `listAllCards` (joins cards, chapters, subjects to return the list) and `getCardById` (fetches a single card with all its ladder entries via two queries).
- **Two EJS templates** in `views/`: `cards-list.ejs` and `card-detail.ejs`. Inline CSS, system font stack, modest styling appropriate to FlashFlow's daily-review-as-ritual aesthetic.
- **Routes updated**: `/` now renders the list view; new route `/cards/:id` renders the detail view; old JSON routes (`/health`, `/subjects`) preserved for debugging.
- **Seed data inserted** into both local and production databases: one Subject (Software Craft), one Chapter (Methodology and Process), five Cards drawn from the seed CSV, each with an Initial ladder entry. The seed SQL was committed to the repository as `app/seeds/walking-skeleton.sql`.
- **Production seeded via `fly proxy` again** — second time the procedure was used, smoother than the first. One detour: the production database password from earlier in the session was incorrect (probably mistyped when saved), so a second rotation was performed before the seed could be inserted.
- **A real fragility surfaced and was addressed**: long SQL pastes into psql are unreliable. The seed insert succeeded for subject and chapter but failed silently for cards because the embedded escaped quotes (`Aren''t`) got truncated mid-paste. Fix: write the SQL to a file and use `psql -f`. Discipline banked.
- **Deploy** with the new code, after committing the Phase 4 work to Git first (preserving the commit-before-deploy discipline).

The walking skeleton moment — clicking through cards on the iPhone, seeing the production database render through the production deployment of the new code — closed Phase 4.

### 15. Two-machine workflow document created

After multiple frictions transferring work between iMac and MacBook (missing migrations, missing npm packages, wrong username in `.env`), the discipline was formalised as `docs/two-machine-workflow.md`. The document captures: what's in Git versus what's local, the `.env` discipline (machine-specific values), the open/close session disciplines (`git pull`, `npm install`, `npm run migrate:up` at start; `git status`, commit, push at close), a field guide to common failure modes with their fixes, and a "when in doubt" diagnostic chain.

This was the third meta-discipline named during session 02 (after session-resumption and out-of-band file sharing). All three earn their place by being the kind of thing future-self or future-assistant will benefit from having spelled out.

---

## Conceptual ground covered

### Vocabulary introduced this session (with sources)

**Architecture and design**:
- Software architecture (Bass, Clements, Rice — SEI 2003)
- Architecture Decision Record / ADR (Michael Nygard, 2011)
- Application server vs database vs "backend" — the term's ambiguity
- The "Hello, world!" tradition (Brian Kernighan, 1972 Bell Labs memo)
- Dev-prod gap; CI/CD as the discipline that closes it
- Configuration drift; single source of truth
- Reproducible development environments
- Monorepo vs polyrepo

**Web fundamentals**:
- Client-server model
- HTTP / HyperText Transfer Protocol (Berners-Lee, 1989)
- Web framework, route handler, middleware
- REST / Representational State Transfer (Roy Fielding, 2000)
- Express (TJ Holowaychuk, 2010), Fastify (Collina/Della Vedova, 2016) — discussed and selected
- Thin client vs thick client
- High availability
- 0.0.0.0 as host address vs 127.0.0.1
- Route parameters

**Distributed systems**:
- Inter-process communication (IPC)
- Microservices architecture
- "Distributed systems are hard" — partial failure, timeouts, version mismatch
- Stateless vs stateful services
- Why HTTP itself is stateless

**Tools and infrastructure**:
- Node.js (Ryan Dahl, 2009) and its relationship with npm
- Semantic versioning (Tom Preston-Werner, 2010); LTS releases
- Runtime vs dev dependencies; transitive dependencies
- TypeScript strict mode; strictNullChecks; string literal types
- The `.env` / `.env.example` pattern
- Software containers and Docker
- Dockerfile structure; multi-stage builds; layer caching
- TOML (Tom Preston-Werner)
- Cloudflare proxy and its incompatibility with Fly.io's certificate flow
- Let's Encrypt and the `_acme-challenge` DNS record
- DNS A vs AAAA records; IPv6 syntax precision
- Fly.io vocabulary: app, machine, organization
- Auto-stop machines; managed vs unmanaged database hosting
- OAuth device flow for CLI authentication
- The "pin a Homebrew version" discipline (e.g., `postgresql@16`)
- Secrets handling, credential rotation as a configuration operation

**Database**:
- psql vs SQL meta-commands
- Database connection strings; connection pools
- Foreign keys and referential integrity
- ON DELETE CASCADE — when to use, when not
- CHECK constraints
- Database indexes (and their cost)
- Polymorphic entities; data redundancy and normalisation
- Migration tools; up/down migration sections
- DELETE vs DROP
- UUIDs and UUID v7 (2024 standard)

**Process and method**:
- YAGNI ("You Aren't Gonna Need It" — Ron Jeffries, late 1990s)
- Vertical slice / walking skeleton (Alistair Cockburn, early 2000s)
- Out-of-band file sharing
- Terminology drift, and what prevents it
- Progress note vs layer document at session resumption
- Fail-fast as a programming discipline
- Commit-before-deploy

### Meta-principles reinforced through use

**Working from summaries instead of source documents produces defects that surface as confusion downstream.** Both early-session false alarms had this same root cause. The session-resumption discipline is the corrective.

**The project's primary criterion is learning + WhiteGlove, not paper-fidelity.** When the criterion is forgotten, the conversation drifts toward defaults (resemble the paper system, defer features that "feel" non-essential) that don't actually match the project's stated values.

**Disciplines compound; specific decisions don't.** The architecture document is one accepted artefact. The session-resumption discipline applies to every future session and to WhiteGlove's multi-year run. The two-machine workflow discipline applies to every machine switch from now until the project ends.

**The instinct toward smarter logic is a good engineer's instinct, and a famous trap.** The user's mid-session question about whether fail rows should carry interval information was a real design question that deserved real reasoning — and ended with a deliberate choice to keep the schema simple. YAGNI, applied with awareness rather than reflex.

**Long terminal pastes are fragile.** The psql seed-insert truncation was a real bug that surfaced as silent failure (subject and chapter inserted, cards didn't, no error message visible). Lesson: write the SQL to a file and use `psql -f`. Reflexive practice once you've been bitten.

**Commit before deploying.** Every deploy through the session was preceded by a commit. The discipline closes the integrity gap between deployed code and version-controlled code.

**Production state can be lost.** Fly's auto-stop applies to databases too. The "the machine hasn't started" diagnostic on Phase 4's seed step turned into a small detour to wake the database. Worth knowing the failure mode.

---

## Repository state at end of session

### Documents in the repository

```
flashflow/
├── README.md                          (refreshed twice during session)
├── app/
│   ├── package.json
│   ├── package-lock.json
│   ├── tsconfig.json
│   ├── Dockerfile
│   ├── fly.toml
│   ├── .gitignore
│   ├── .env.example
│   ├── .dockerignore
│   ├── migrations/
│   │   └── <timestamp>_create-initial-schema.sql
│   ├── seeds/
│   │   └── walking-skeleton.sql
│   ├── views/
│   │   ├── cards-list.ejs
│   │   └── card-detail.ejs
│   └── src/
│       ├── server.ts
│       ├── db.ts
│       ├── db-schema.ts
│       └── queries.ts
└── docs/
    ├── vision.md                      (Layer 1)
    ├── goals.md                       (Layer 2)
    ├── constraints.md                 (Layer 3, Berlin timezone added)
    ├── glossary.md                    (Layer 4)
    ├── domain-model.md                (Layer 5)
    ├── workflows.md                   (Layer 6)
    ├── architecture.md                (Layer 7)
    ├── tech-stack.md                  (Layer 8 with Mermaid diagram)
    ├── roadmap.md                     (Layer 9)
    ├── backlog.md
    ├── two-machine-workflow.md        (NEW)
    ├── flashcard-system-original.md
    ├── software-craft-seed-cards.csv  (162 cards across 9 chapters)
    └── learning-journal/
        ├── session-01-progress.md
        └── session-02-progress.md     (this file)
```

### Production state

- App live at `https://flashflow.whiteglove.exchange` and `https://flashflow.fly.dev`
- TLS certificate issued by Let's Encrypt
- Fly apps: `flashflow` (the app), `flashflow-db` (PostgreSQL, unmanaged), `fly-builder-sparkling-silence-9796` (build machine)
- Region: `fra` (Frankfurt)
- Auto-stop enabled on both app and database
- Production database password: rotated twice (after the initial leak; after the wrong-password issue at Phase 4 seed time)
- Production database content: 1 subject, 1 chapter, 5 cards, 5 initial ladder entries

### Time check

**Session 02 consumed approximately 11 hours** of FlashFlow work over its full span. Combined with session 01's 7.5 hours, **18.5 hours of 50** consumed. **31.5 hours remaining**.

Phases 1+2+3+4 were budgeted at 15 hours per the roadmap; actual was approximately 12. About 3 hours under budget on the build phases, with the savings absorbed by the design-layer work and the various meta-discipline documentation produced this session.

---

## Plan for next session

### Goal: complete Phase 5 (scheduler design + Python implementation + tests)

The densest content phase. Introduces the first real Python work of the project, a separate FastAPI service, and the only tests required by `goals.md`.

The phase splits into four sub-tasks per the roadmap:

| Sub-task | Estimated time |
|---|---|
| `docs/scheduler.md` design document | 45 min |
| Python implementation as pure functions | 2h |
| Tests for the scheduler | 1.5h |
| FastAPI wrapping the algorithm | 45 min |

A real schema-related question to address in the design document: timezone handling. The user is in Berlin; "today" must be the user's local day, not UTC. The scheduler must read a configurable timezone, not hardcode.

### Resume command (either machine)

```
cd ~/Projects/flashflow
git pull
cd app
npm install
# (no migrations to apply this session — same schema)
```

Per the discipline, paste the raw GitHub URLs for all design documents at the top of the next conversation.

---

## Reflections on the session

**The early-session false alarms set the tone for the whole session.** The session-resumption discipline named after them was applied (imperfectly but consistently) for the rest of the working session. Without it, the session would have been more error-prone.

**The user's pushbacks remain the single most valuable input mechanism.** As in session 01, multiple times during the session the user's correction caught a defect or named a discipline that the assistant had missed. The fail-row schema question is a particularly good example — a real question that produced real reasoning, with a deliberate outcome.

**Long inline pastes are a known failure mode.** The psql truncation was the second time in this project that a long paste produced silent partial failure (the first was an early shell-paste issue in session 01). The lesson — write to a file and use the `-f` invocation — should be reflexive practice.

**The two-machine workflow has real failure modes.** The MacBook was missing migrations, missing npm packages, and had the wrong username in `.env` at various points during the session. The recovery from each was straightforward but cumulative. The two-machine workflow document captures the disciplines that would have prevented each.

**Time-of-day language is a real failure mode for the AI assistant.** The assistant has no clock awareness and should not refer to "morning," "evening," or other time-of-day cues unless the user has stated them. This was caught and named during the session and has been added as a meta-discipline.

**Phase 4's "the walking skeleton works" moment is worth marking.** Every layer of the architecture from Layer 7 — browser, Fastify, EJS, Kysely, PostgreSQL — works in production, on a custom domain, over HTTPS, on phone and laptop. From here, every feature is *adding to* this proven foundation rather than building it. This is the most psychologically important milestone of the build per the roadmap, and it's now real.

**The project is well-positioned.** Slightly ahead of budget, all design layers complete, four of eight build phases done, the deployment chain proven, both machines functional. Phase 5 deserves its own dedicated session at the pace it deserves, without rush.

---

*End of session 02 progress note.*
