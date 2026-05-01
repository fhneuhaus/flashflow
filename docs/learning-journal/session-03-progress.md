# FlashFlow — Session 03 Progress

*Status: Phase 4 (walking skeleton) closed. Strategic curve-design work completed and committed as docs/learning-curve.md. Phase 5 (scheduler) opened with Section 1 of the design document drafted but not committed; remaining sections deferred to session 04.*

---

## What this session was about

A long working session split, in effect, into two halves: a build half and a strategy half.

The build half closed Phase 4 of FlashFlow — the walking skeleton with list and detail views, real production data, verified across iMac, MacBook, and iPhone. This was the most significant build milestone yet: every layer of the architecture from Layer 7 (browser, Fastify, EJS, Kysely, PostgreSQL) verified working in production, on a custom domain, over HTTPS.

The strategy half stepped out of FlashFlow entirely and addressed a larger question: what learning trajectory across multiple projects best prepares the developer to commission WhiteGlove? The conversation produced concrete strategic decisions about WhiteGlove (substrate, mechanics, trading-window), a five-component learning curve, and a written plan committed as `docs/learning-curve.md`.

Phase 5 was opened at the very end of the session — three of ten planned sections of the scheduler design document drafted in conversation — but not yet committed to a file. Phase 5 resumes session 04.

---

## Major decisions and pivots (in chronological order)

### 1. The MacBook-not-properly-configured diagnostic

The session opened on the MacBook with a suspicion that the development environment was broken. A diagnostic chain (`git status`, `node --version`, `fly auth whoami`, `brew services list`, `ls -la app/`, `psql flashflow_dev -c "\dt"`) revealed the actual state: tools installed, Git up to date, Postgres running, but the database `flashflow_dev` had no tables — the migration had never been applied on this machine.

Running `npm run migrate:up` failed with `role "fn" does not exist`. The cause: the iMac's `.env` had been copied verbatim during yesterday's setup, and its `DATABASE_URL` referenced user `fn`. The MacBook's PostgreSQL has user `user` (matching the macOS username). The fix was a one-character edit in `.env`.

This was a real example of the discipline named yesterday in `docs/two-machine-workflow.md`: machine-specific values in `.env` cannot be copied verbatim. The discipline survived first contact with reality, but the reality also confirmed it: this is exactly the failure mode the document was written to prevent. Future sessions should reflexively check `DATABASE_URL`'s username against `whoami` after pulling on a different machine.

Subsequent friction on the MacBook: `npm install` had not been re-run after pulling new dependencies (kysely, @fastify/view, etc.), producing TypeScript build errors. Fixed with `npm install`. Another concrete example of the "git pull updates the manifest; npm install actualises it" discipline.

### 2. Phase 4 — Walking skeleton complete

End-state: `https://flashflow.whiteglove.exchange/` shows a list of five cards from the production database, each clickable to a detail view rendering the question, answer, breadcrumb (subject and chapter), and ladder. Verified on iMac, MacBook, and iPhone.

The work:

- **`@fastify/view` and `ejs` installed** (plus `@types/ejs` as a devDependency).
- **`server.ts` updated** to register the view plugin with EJS as the engine.
- **A query layer** in `src/queries.ts` with two functions: `listAllCards` (joins cards, chapters, subjects) and `getCardById` (fetches a card with all its ladder entries, two queries).
- **Two EJS templates** in `views/`: `cards-list.ejs` and `card-detail.ejs`. Inline CSS, system font stack, modest styling appropriate to the daily-review-as-ritual aesthetic.
- **Routes updated**: `/` renders the list; new route `/cards/:id` renders the detail; old JSON routes (`/health`, `/subjects`) preserved for debugging.
- **Seed data inserted** into both local and production databases: one Subject (Software Craft), one Chapter (Methodology and Process), five Cards from the seed CSV, each with an Initial ladder entry. The seed SQL committed as `app/seeds/walking-skeleton.sql`.
- **Production seeded via `fly proxy` again** — third time the procedure was used, smoothest yet.

A real fragility surfaced and was addressed during the production seeding. The `fly proxy` connection initially failed with `flashflow-db.internal: host was not found in DNS` because Fly had auto-stopped the production database (idle since yesterday). Fix: `fly machine list -a flashflow-db` to find the machine ID, then `fly machine start <id> -a flashflow-db`. Worth knowing as a routine operational procedure now that idle suspension is part of the daily operational reality.

A second password-rotation incident happened during the seed phase — yesterday's saved password didn't work, indicating either a transcription error during saving or a second rotation that wasn't cleanly tracked. Resolved by another detach-attach cycle, the third in three sessions. The process is now muscle memory.

A third real fragility surfaced and was addressed: long SQL pastes into `psql` are unreliable. The seed insert succeeded for subject and chapter but failed silently for cards because the embedded escaped quotes (`Aren''t`) got truncated mid-paste. Fix: write the SQL to a file and use `psql -f`. Discipline banked.

The walking-skeleton moment — clicking through cards on the iPhone, seeing the production database render through the production deployment of the new code — closed Phase 4.

### 3. Strategic conversation: assessing FlashFlow against the actual goal

After Phase 4 closed, the session changed shape. The trigger was a direct question from the developer:

> "this whole project is meant to be a learning exercise for me — to prepare me to commission one day in the next 3 months a software development project of the scope of WhiteGlove. I am not going to write a single line of code... do you think FlashFlow is instructive?"

This required honest assessment, not encouragement. The honest answer: FlashFlow is well-shaped for some commissioner-readiness skills (vocabulary fluency, specification-writing, project-lifecycle texture) but insufficient for others (multi-user dynamics, real money handling, contractor-management patterns).

The conversation surfaced three categories of preparation a commissioner needs, with FlashFlow strong on the first two and weak on the third:

1. **Vocabulary and problem-domain literacy** — strong (175+ cards growing weekly).
2. **Writing a project specification** — strong (the nine-layer design sequence is a specification-writing rehearsal).
3. **Contractor-management and "what good engineering looks like from the outside"** — weak. FlashFlow has one developer who is also the user; there is no contrast against a contractor.

The conclusion: FlashFlow is necessary but not sufficient. A second project (and supplementary reading) is needed.

### 4. The MontereyDemo concept introduced

The developer had been thinking about a follow-on project: a small demonstrator built around the Monterey Car Auction (mid-August), where a small cohort of friends would participate with seed money the developer provides, with proceeds destined for charity. The auction-house domain (lots, low-high estimates, settlement, sold/unsold) is structurally similar to WhiteGlove's eventual art-auction focus; the timing (August) bridges the period before WhiteGlove proper begins.

Initial sketch: 24 friends, 3-6 trophy lots, €100/$100 per friend in play money. Real money entering the system (even play money) changes the engineering discipline meaningfully — audit trails, idempotency, integrity, financial reconciliation become genuine concerns rather than theoretical ones.

The concept was assessed as substantially better preparation for WhiteGlove than FlashFlow alone — multi-user, real money, external event coupling, regulatory surface, friend-as-real-user dynamics — across three real dimensions FlashFlow cannot teach.

### 5. Strategic decisions about WhiteGlove, settled in conversation

The MontereyDemo design depends on what WhiteGlove will eventually be. A series of clarifications surfaced and were settled:

**WhiteGlove is exchange-mechanics, not house-betting.** The platform is a marketplace where users trade contracts with each other, not a house that takes the other side of users' bets. Order-matching is the central pattern. This justifies the domain name.

**WhiteGlove will not allow live trading during auctions.** Markets open when the auction catalogue is published, close before the auction begins, settle when official results come in. This removes the entire class of real-time-trading concerns (WebSockets, conflict resolution under load, latency optimisation) from the architecture — a major scope-shaping decision.

**WhiteGlove launches on conventional banking rails — fiat-only.** Crypto-native rails (USDC, smart contracts) are explicitly out of scope at launch. The reference architecture for WhiteGlove's substrate is closer to Kalshi than to Polymarket. The architecture should not preclude adding crypto rails later, but the initial implementation is single-substrate.

**WhiteGlove should be architected with clean module boundaries** for external concerns (payment provider, identity provider, data sources). Full ports-and-adapters polymorphism is excessive for a single-substrate launch, but the discipline of "the accounting module knows nothing about which payment provider is in use" should be present from the start.

These four decisions are project-level facts about WhiteGlove that the eventual contractor brief should reflect. They simplify the system substantially compared to a generic "build a prediction market platform" specification. The conversation framed them as exactly the kind of high-impact scope decisions a commissioner makes — articulating these clearly to a contractor on day one is what distinguishes a well-prepared commissioner from a vague one.

### 6. Reading Kalshi's and Polymarket's API documentation, structured as comparison

The conversation engaged directly with the public API documentation of two real production exchanges. The Kalshi study (REST + WebSocket + FIX, RSA-PSS request signing, OpenAPI as source of truth, eight-state market lifecycle) and the Polymarket study (CLOB, gasless transactions via relayer, on-chain settlement, builder ecosystem) revealed how serious teams handle the same domain with different architectural substrates.

The comparison highlighted:

- **Substrate-independent core** (looks similar across both): Series → Event → Market hierarchy, CLOB order matching, market lifecycle, position tracking, profile/social layer.
- **Substrate-specific surface** (looks very different): authentication, deposits/withdrawals, settlement money flow, custody model, compliance integration.

This shaped the curve's component 3: a comparative API study producing a written comparison document, deliberately structured to highlight which design questions WhiteGlove's contractor will face.

### 7. Several meta-disciplines named, around AI-assisted analysis quality

The conversation produced several moments where the AI assistant's analysis had to be pushed back against by the developer. Three patterns surfaced explicitly:

**"Practical" doing too much work.** When justifying a proposed design (IDs flowing through scheduler operations), the assistant used "more practical" as a heuristic justification that didn't survive examination. The actual reason was narrower than the framing suggested.

**WhiteGlove generalisation applied where it doesn't fit.** When framing the FlashFlow scheduler's filtering strategy, the assistant invoked "WhiteGlove preparation" as justification when the actual scale and domain of WhiteGlove are different from FlashFlow's. The heuristic "harder choice for WhiteGlove preparation" applied genuinely to Layer 8 stack-level decisions but does not apply to every detail decision.

**Manufacturing analysis around upstream-determined choices.** When the choice was already settled by an upstream document or principle (e.g., the interval ladder being a fixed list because the paper system uses one), the assistant constructed analytical justifications for the choice that were theatre rather than analysis. The right move when this happens is to compress, name the upstream reason, and proceed.

These three patterns share a common shape: the AI assistant manufacturing intellectual ceremony around decisions that don't need it. Two general names exist for related phenomena: **post-hoc rationalisation** (constructing reasons for already-made decisions) and **bikeshedding** (disproportionate effort on small decisions while bigger ones go undiscussed). Both were banked as cards.

The pattern is worth flagging because it's specifically a failure mode of AI-assisted analytical work — the assistant has unlimited capacity to produce plausible-sounding analysis, and discipline is required to distinguish genuine analysis from manufactured rigour. The developer's pushbacks across the session were the corrective.

### 8. The "no time-of-day inferences" rule

A separate meta-discipline emerged: the AI assistant has no clock awareness and should not refer to "morning," "afternoon," "evening," or other time-of-day cues unless the developer has explicitly stated them. Multiple times in earlier sessions the assistant had projected energy states or fatigue onto the developer, made recommendations framed around assumed time pressure, or used time-of-day language without basis.

The developer flagged this directly during the session. A 220-word rule was drafted and added to the project context instructions covering: no time-of-day language, no energy/fatigue projection, no elapsed-time estimation, no inference from message-pause length. Sequence labels ("first stretch," "second stretch") are acceptable when grounded in the conversation's actual structure; time-of-day labels are not. Hours-consumed accounting is welcome and expected; wall-clock-time inference is not.

### 9. The learning curve formalised as a document

The strategic conversation produced enough substance that capturing it in the conversation transcript alone would mean losing it. A written plan was drafted and committed as `docs/learning-curve.md`, structured around five components:

1. **FlashFlow finish (Phases 5-8)**: ~30 hours.
2. **Reading bridge**: McConnell's *Software Estimation*, DeMarco and Lister's *Peopleware*, optionally Brooks's *Mythical Man-Month*. 10-15 hours.
3. **Comparative API study (Kalshi-focused, Polymarket as comparison)**: produces a written comparison document. 15-20 hours.
4. **MontereyDemo**: 5-10 friends (down from 24), 3-6 lots, 9-18 binary contracts, database-only play money, manual real-money settlement. 60-90 hours.
5. **Post-MontereyDemo reflection**: includes initial draft of WhiteGlove project specification. 8-12 hours.

Total: 125-167 hours across roughly four months. Roughly 8-12 hours per week consistently.

Three follow-through items locked: the seed deck pivots to add an Exchange Architecture chapter (populated during component 3); a lawyer conversation about regulatory shape scheduled for May or June; friend recruitment for MontereyDemo begins low-key in May or early June.

### 10. Phase 5 — Scheduler design document opened

After the curve-design work concluded, Phase 5 of FlashFlow was opened. The scheduler design document (`docs/scheduler.md`) was begun in conversation, with Section 1 (Inputs and outputs) drafted through to settled conclusions:

- Three operations: `next-interval-after-pass`, `next-due-date`, `compose-stack`. The `is-due-today` and `fail-entry-for-card` operations originally drafted were eliminated as redundant or trivial.
- The browser sends the user's current timezone with each request; the scheduler uses it to compute "today" and to date ladder entries. The system follows the user.
- The scheduler receives the full set of `{id, ladder}` pairs and filters/orders internally. At FlashFlow's scale this is operationally trivial; for WhiteGlove a database-side pre-filter would be appropriate, but those are different decisions for different scales.

Section 2 (the interval ladder) was drafted, with five sub-questions resolved:

- Fixed list `[1, 3, 7, 14, 30, 60, 120, 240]`, all integers measured in days, day as the atomic unit of scheduling.
- Cap at 240; cards that reach the top stay there.
- Initial → Pass(1) as the first transition.
- Newly-created cards due today (per goals.md and workflows.md).
- Pass rule: Initial → 1, Pass → next rung up, Fail → demotion (deferred to Section 5).

Sections 3-10 (Pass rule details, Fail rule, Recovery/demotion rule, day-boundary computation in detail, stack composition, edge cases, API surface) remain to be drafted in session 04.

The scheduler design document was not yet written to a file at session end. The conversation transcript holds the substance; session 04 will translate it into a committed document before any Python implementation begins.

---

## Conceptual ground covered

### Vocabulary introduced this session (with sources)

**Architecture and design**:
- Ports and adapters / hexagonal architecture (Alistair Cockburn, early 2000s) — the same Cockburn who coined "walking skeleton"
- Articulating architectural constraints up front as a commissioner discipline
- Narrowing scope before building producing disproportionate downstream simplification

**Methodology**:
- Speculative generality (Martin Fowler, *Refactoring*, 1999) — designing for cases that aren't real
- Gold-plating (1980s project-management term for the same impulse)
- Post-hoc rationalisation in design discussions
- Bikeshedding / Law of Triviality (C. N. Parkinson, 1957; "bikeshed" framing from BSD community, 1990s)

**Tools and Infrastructure**:
- BSD (Berkeley Software Distribution) and its contributions to general software vocabulary
- OpenAPI specification and generating SDKs from it as the professional pattern
- Multiple API protocols (REST + WebSocket + FIX) for exchange platforms

**Web / templating**:
- Template engines (`@fastify/view`, EJS) and what they do for web frameworks
- HTML escaping and why it matters for displaying user content safely
- The difference between EJS's `<%= %>` and `<% %>` tags

**Database and Kysely**:
- SQL JOINs (introduced in earnest during Phase 4's query layer)
- Aliasing columns in SQL queries
- `executeTakeFirst` vs `executeTakeFirstOrThrow` in Kysely
- `ON CONFLICT DO NOTHING` for idempotent inserts
- SQL escaping rules for single quotes inside string literals
- `psql -f` as the reliable way to run SQL files
- "Role" as PostgreSQL's term for users

**Exchange Architecture (new chapter)**:
- CLOB (Central Limit Order Book) as the standard event-contract exchange pattern
- Series → Event → Market hierarchy
- KYC and its 2-4 week integration cost
- Two infrastructure substrates (fiat banking rails vs crypto-native rails)
- Market lifecycle states (initialized / active / closed / determined / finalized, plus inactive / disputed / amended)
- Comparative analysis of Kalshi vs Polymarket as architectural references

### Meta-principles reinforced through use

**Strategic clarity simplifies architecture more than tactical cleverness.** The four WhiteGlove decisions settled in conversation (exchange-mechanics, no live trading, fiat-only, clean module boundaries) eliminate more system complexity than any algorithmic optimisation could. Articulating these clearly is a commissioner skill that pays back at every subsequent decision point.

**The AI assistant has unlimited capacity for plausible analysis; the developer's pushback is what makes analysis actually rigorous.** Several times in this session, manufactured rigour was caught only by the developer's "wait — does this argument actually hold up?" challenge. This is a real and recurring pattern in AI-assisted work; it is not a defect to be eliminated but a reality to be designed around. Reflexive critical engagement is the corrective.

**Reading professional production code and documentation can be more learning-dense than building one's own version.** This insight reshaped the curve: the comparative API study replaces a hands-on intermediate project (TipStakes/PredictBox), trading hands-on coding muscle for vocabulary fluency at the rate of professional reading.

**Specifications are easier to write when prior decisions have already settled the strategic shape.** The exercise of writing FlashFlow's nine-layer design documents was practice for writing a specification. The four WhiteGlove decisions made in conversation are the kind of decisions that make a future contractor brief tractable. A vague brief invites contractor-driven architecture; a constrained brief frames productive collaboration.

**Long inline pastes are a known failure mode.** The psql truncation during Phase 4 seeding (third time in this project that long pastes have caused silent partial failure) confirms once more that the right pattern is "write to a file, use the `-f` invocation." Reflexive practice now.

**Production state can be lost.** Fly's auto-stop applies to databases, build machines, and app machines. Working with Fly means treating "the machine hasn't started" as a routine first-step diagnostic, not an alarm.

---

## Repository state at end of session

### Documents in the repository

```
flashflow/
├── README.md
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
    ├── vision.md
    ├── goals.md
    ├── constraints.md
    ├── glossary.md
    ├── domain-model.md
    ├── workflows.md
    ├── architecture.md
    ├── tech-stack.md
    ├── roadmap.md
    ├── backlog.md
    ├── two-machine-workflow.md
    ├── learning-curve.md                  (NEW — session 03)
    ├── flashcard-system-original.md
    ├── software-craft-seed-cards.csv      (175 → 191 cards; new chapter Exchange Architecture)
    └── learning-journal/
        ├── session-01-progress.md
        ├── session-02-progress.md
        └── session-03-progress.md         (this file)
```

### Production state

- App live at `https://flashflow.whiteglove.exchange` and `https://flashflow.fly.dev`
- TLS certificate from Let's Encrypt
- Fly apps: `flashflow`, `flashflow-db`, `fly-builder-sparkling-silence-9796`
- Region: `fra` (Frankfurt)
- Auto-stop enabled on app, database, and build machine
- Production database password: rotated three times across the project so far
- Production database content: 1 subject, 1 chapter, 5 cards, 5 initial ladder entries
- The walking skeleton renders five clickable cards on every device

### Time check

Combined with sessions 01 and 02:

| | Hours |
|---|---|
| Session 01 | 7.5 |
| Session 02 | 11 |
| Session 03 | ~6 |
| **FlashFlow consumed** | **~24.5** |
| **FlashFlow remaining** | **~25.5** |

Phases 1+2+3+4 were budgeted at 15 hours per the roadmap; actual approximately 12 — about 3 hours under build-phase budget. The strategic curve-design work consumed approximately 2-3 hours that wasn't in the original roadmap; appropriate, given the strategic decisions it produced.

The 50-hour budget is on track. Phase 5 (5h), Phase 6 (6h), Phase 7 (5h), Phase 8 (6h) remain — 22 hours of planned work against ~25.5 hours of budget. About 3.5 hours of slack, narrower than after session 02 but still real.

---

## Plan for next session

### Goal: complete Phase 5 (scheduler design + Python implementation + tests + FastAPI)

The phase splits into four sub-tasks per the roadmap:

| Sub-task | Estimated time |
|---|---|
| `docs/scheduler.md` design document (continuing from session 03's draft) | 30-45 min |
| Python implementation as pure functions | 2h |
| Tests for the scheduler | 1.5h |
| FastAPI wrapping the algorithm + Fly deployment | 1h |

The design document continuation should resume from Section 3 (the Pass rule in detail), building on Sections 1 and 2 already drafted in conversation. The transcript of session 03 has the substance of those sections; they should be transcribed into the document with refinements as the design progresses through Sections 4-10.

### Resume command (either machine)

```
cd ~/Projects/flashflow
git pull
cd app
npm install
# (no migrations to apply; same schema)
```

Per the discipline, paste the raw GitHub URLs for all design documents at the top of the next conversation. The new file `docs/learning-curve.md` should be included in that list.

---

## Reflections on the session

**Phase 4 closing well sets up Phase 5 well.** The walking skeleton is operating in production with real data on real devices. Every additional feature now adds to a proven foundation rather than building it. This is exactly the psychological function the roadmap predicted Phase 4 would serve.

**The strategic conversation is the most important output of the session.** Phase 4 was budgeted in the roadmap; it would have happened with or without the curve-design work. The four WhiteGlove decisions and the five-component learning curve, by contrast, would not have existed without this specific conversation. They are foundational to everything that follows FlashFlow — both MontereyDemo and WhiteGlove proper.

**The developer's pushbacks remain the highest-leverage input mechanism.** Three specific moments where the AI assistant's analysis was caught and corrected: "practical" doing too much work; "WhiteGlove preparation" overgeneralised; manufacturing analysis around upstream-determined choices. Each correction sharpened the analysis. This pattern — AI generates plausible analysis, developer's critical engagement separates rigorous from manufactured — is the working method itself.

**The project produces meta-disciplines as durable outputs alongside code.** Cumulative across three sessions: session-resumption from source documents, out-of-band file sharing via raw URLs, two-machine workflow, no time-of-day inferences, post-hoc rationalisation detection, bikeshedding awareness. Each was named in response to a specific failure mode that nearly produced (or did produce) a defect. These are not byproducts of the work; they are work products in their own right, useful well beyond FlashFlow.

**The learning curve will need to be defended against scope creep.** The MontereyDemo participant count (5-10, not 24), the comparative API study replacing a third hands-on project, the deliberate exclusions in the curve document — all of these are scope-defending decisions made in advance. The discipline of "named contingency before the moment of pressure" applies to the curve as much as it applied to the FlashFlow roadmap's PWA-deferral rule.

**The session was substantially longer than originally planned and produced more than originally scoped.** Both are appropriate given the substance involved, but worth noting as a pattern: the sessions where strategic clarification happens are necessarily harder to bound in advance, and the work products often justify the longer span. The session-04 plan should remain bounded against actual time budget — Phase 5's design document and Python work fit within the 5-hour roadmap budget if pursued without similar strategic excursions.

---

*End of session 03 progress note.*
