# FlashFlow — Session 02 Progress

*Date: 2026-04-30 (afternoon portion; evening continues separately)*
*Duration: ~2 hours of FlashFlow work*
*Status: Layer 7 (Architecture) accepted and committed. Layer 8 (Tech Stack) not yet started. Session continues from the iMac in the evening.*

---

## What this session was about

A short focused session to settle Layer 7 (Architecture) and prepare for Layer 8. The work was bounded — one accepted document, a refreshed README, and an addition to the seed cards — but two false alarms were caught along the way that produced more important learning than the architecture decision itself.

This note covers the afternoon portion only. The iMac evening session, which will start with Layer 8, will be its own progress note.

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

This is the most valuable output of the day. Architecture documents can be redrafted; disciplines compound. The discipline applies more strongly the longer the gap, and applies particularly to WhiteGlove, which will run for years.

### 5. Public repository → out-of-band sharing of files via raw URLs

The repository was already public (set up in session 01); a new pattern was used to make documents available to the assistant: paste raw GitHub URLs (`raw.githubusercontent.com/.../docs/X.md`) and the assistant fetches them. This is *out-of-band sharing* — the files arrive through a different channel than the conversation itself.

The pattern is faster than uploading via dialog and works for any committed file. It became the working method for the rest of the session.

### 6. Seed cards refreshed: 66 → 82

Sixteen new Software Craft cards added, covering material that surfaced during this session: architecture vocabulary, web fundamentals, distributed-systems basics, and the project-method lessons (terminology drift, progress-note vs layer-document, primary criterion, session-resumption discipline). Three new chapters introduced (Architecture and Design, Web Fundamentals, Distributed Systems).

The card-writing discipline from session 01 held: each card atomic, answers ≤3 items, 80–90% recall band as target.

### 7. Workflow B retained as written; the architecture draft stood

After both false alarms resolved with no scope changes, the only edits made were the architecture document itself (created), the README (refreshed), and the seed cards CSV (extended). The bulk of the day's actual *substance* was the discipline named in decision 4.

---

## Conceptual ground covered

### Vocabulary introduced this session (with sources)

**Architecture and design**:
- Software architecture (Bass, Clements, Rice — SEI 2003)
- Architecture Decision Record / ADR (Michael Nygard, 2011)
- Application server vs database vs "backend" — the term's ambiguity

**Web fundamentals**:
- Client-server model
- HTTP / HyperText Transfer Protocol (Berners-Lee, 1989)
- Web framework, route handler, middleware
- REST / Representational State Transfer (Roy Fielding, 2000)
- Express (TJ Holowaychuk, 2010), Fastify (Collina/Della Vedova, 2016) — discussed but not selected
- Thin client vs thick client

**Distributed systems**:
- Inter-process communication (IPC)
- Microservices architecture
- "Distributed systems are hard" — partial failure, timeouts, version mismatch
- Conflict resolution as the hard part of offline sync

**Process and method**:
- YAGNI ("You Aren't Gonna Need It" — Ron Jeffries, late 1990s)
- Out-of-band file sharing
- Terminology drift, and what prevents it
- Progress note vs layer document at session resumption

### Meta-principles reinforced through use

**Working from summaries instead of source documents produces defects that surface as confusion downstream.** Both false alarms had this same root cause. The session-resumption discipline (decision 4) is the corrective.

**The project's primary criterion is learning + WhiteGlove, not paper-fidelity.** When the criterion is forgotten, the conversation drifts toward defaults (resemble the paper system, defer features that "feel" non-essential) that don't actually match the project's stated values. Restating the criterion re-anchors the conversation.

**Disciplines compound; specific decisions don't.** The architecture document is one accepted artefact. The session-resumption discipline applies to every future session and to WhiteGlove's multi-year run. Today's most valuable output was the discipline.

**The instinct toward smarter logic is a good engineer's instinct, and a famous trap.** Late in the session, the user proposed adding "smarter than string-comparison" pass/fail logic. The pause-before-implementing revealed this was self-grading already, not system-grading; no change needed. YAGNI saved unnecessary work.

---

## Repository state at end of session (afternoon)

### Commits added this session

```
[architecture commit]   Add architecture.md (Layer 7); refresh README to match current docs
[seed cards commit]     Add 16 Software Craft cards from session 02 (architecture, web fundamentals, distributed systems, method)
```

(Two commits, not three — the architecture document and README refresh went together as one logical unit.)

### Documents in the repository

```
flashflow/
├── README.md                          (refreshed)
└── docs/
    ├── vision.md                      (Layer 1 ✓)
    ├── goals.md                       (Layer 2 ✓)
    ├── constraints.md                 (Layer 3 ✓)
    ├── glossary.md                    (Layer 4 ✓)
    ├── domain-model.md                (Layer 5 ✓)
    ├── workflows.md                   (Layer 6 ✓)
    ├── architecture.md                (Layer 7 ✓ NEW)
    ├── backlog.md
    ├── flashcard-system-original.md
    ├── software-craft-seed-cards.csv  (66 → 82 cards)
    └── learning-journal/
        ├── session-01-progress.md
        └── session-02-progress.md     (this file, pending commit)
```

### Time check

**~2 hours** today, afternoon portion. Combined with session 01's 7.5 hours, **9.5 hours of 50** consumed. **40.5 hours remaining.** The iMac evening session (Layer 8 + scaffolding + deployment) is budgeted at ~6 hours per session 01's plan; some of that will likely shift to a third day.

---

## Plan for the iMac evening session

### Goal: Layer 8 (Tech Stack) and Layer 9 (Roadmap) accepted; possibly first scaffolding

### Resume command

```
cd ~/Projects/flashflow
git pull
```

Then open the existing chat (the conversation persists; Claude has full context including all documents fetched today). Send any short message to resume.

Per the discipline named in decision 4, the assistant has all needed Layer 8 source documents already in context: goals, constraints, architecture, workflows, domain model, glossary. No re-fetching needed for a continued conversation.

### Layer 8 decisions on the table

- Node.js web framework: Express vs Fastify (vs others)
- TypeScript or plain JavaScript
- Database: family choice (relational vs document) and specific product
- Hosting platform for both services
- Python service framework (FastAPI is the obvious candidate)
- Smaller pieces: package manager, environment variables, logging

---

## Reflections on the session

**The two false alarms were the most valuable parts of the day.** The architecture decision was real but uncontroversial; the surprise was that two scope-related drifts nearly produced changes the documents wouldn't have justified. Both were caught only by reading source documents directly. This pattern — drift caught by source — is itself the lesson worth banking.

**The user's pushbacks remain the single most valuable input mechanism.** As in session 01, the corrections came from user instinct ("authoring? really?", "the overarching goal is...not to digitally mimic the paper system"). Without them, two real defects would have shipped silently into the documents.

**The session-resumption discipline is now the project's most important meta-rule.** All other disciplines — write things down, prefer paraphrase to summary, distinguish goals from constraints, etc. — are in service of letting future-you (or future-assistant) reconstruct context accurately. The session-resumption rule is the one that operationalises this for the AI-assisted workflow specifically.

**The 30-minute break before the iMac session is being used as a real test.** The discipline says: at session resumption, digest the design documents before substantive work. The conversation continues across the break (no new transcript), so the test is slightly weaker — the documents are still in context. The harder test will come at session 03, when a new conversation begins from a cold start.

---

*End of session 02 (afternoon) progress note.*
