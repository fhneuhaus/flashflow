# FlashFlow — Session 01 Progress

*Date: 2026-04-29*
*Duration: ~6 hours of FlashFlow work, across morning and afternoon*
*Status: end of session 01. Layers 1–4 complete (vision, goals, constraints, glossary). Layer 5 (domain model) and 6 (workflows) still to draft. Two-machine development setup working.*

---

## What this session was about

The first working session of the FlashFlow project — a digital re-implementation of a long-running paper spaced-repetition flashcard system. Conceptual work throughout, with environment setup as the secondary track. The user pushed back substantively whenever the assistant jumped ahead to specifics before foundations were laid; those pushbacks shaped most of the day's design decisions.

A reinforcing loop emerged: FlashFlow's first subject will be **Software Craft** — the vocabulary and disciplines being learned during the build itself.

---

## Major decisions and pivots (in order encountered)

### 1. Subject pivot: Art History → Software Craft

The starting subject changed from Art History (with a one-shot Excel import) to Software Craft (cards authored during the build). Art History deferred to a later iteration. Removed Excel import from v1 scope.

### 2. Project context instructions saved in Claude.ai

A custom-instructions block was drafted and saved into the Project's context. It establishes the nine-layer top-down sequence, jargon-on-first-use discipline, the user-runs-commands principle, formality-matches-scale, and project shape. Persists across conversations.

### 3. Vision document accepted

One paragraph. FlashFlow is a single-user web application that brings the paper SRS into digital form across three devices, preserves the distinctive features of the paper original, and serves as a learning vehicle. Saved as `docs/vision.md`.

### 4. Goals and Non-Goals document accepted, after substantive iteration

Three pieces of pushback shaped the final draft:

- **CSV import is needed.** User's actual workflow generates 300–600 cards per course as a batch (AI drafts notes → user proofreads → AI drafts cards → user proofreads → CSV). Pure in-app authoring would be incompatible.
- **CSV import belongs at the command line.** A web upload feature is wildly disproportionate for a one-user, occasional-batch operation. Surfaced the **application code vs operational code** distinction.
- **Edit-during-review is its own workflow.** When a card's wording is bad mid-review, the natural fix is one tap from the review screen, not navigate-and-find. Surfaces the **edit-in-place** design principle.

The "no AI-generated cards" non-goal was revised to "no in-app AI features" — drawing the line at FlashFlow's own surface, not at the user's upstream pipeline.

A late-session addition: **cognitive-load goal** — keep first-try recall in 80–90% band, answers ≤3 items. Added because spaced repetition is a motivation system as much as a memory system.

### 5. Constraints document accepted, with mid-session restructuring

Originally a flat list. User noticed the document mixed two kinds of constraint, and the assistant introduced the standard taxonomy: **process / product / business**. Restructured with explicit groups. Empty business-constraints section kept deliberately rather than omitted (the same pattern as "What is *not* a constraint").

Two domain-expert constraints were surfaced by the user:

- **Card intake rate ceiling**: ~10–20 new cards/day in steady state, derived from interval-ladder math (each new card produces 8–10 reviews over its lifetime, front-loaded into the first month).
- **The user is also a deeply experienced subject-matter expert** for the system being built. Domain instincts are data, not opinion.

### 6. Glossary document accepted

The vocabulary of FlashFlow. Subject, Chapter, Card, Question/Answer, Ladder, Ladder Entry, Interval, Pass/Fail, Same-day re-attempt, Demotion, Stack, Review, Source, Import. Plus a "Terms we are not using" section explicitly excluding Anki vocabulary (Deck, Note, ease factor, bury/suspend/leech, Tag).

Three open questions resolved by user choice:

- Source attribution: **inheritable** through subject → chapter → card cascade with override at any level.
- Today's collection of due cards: **Stack**.
- Review outcomes: **Pass / Fail** (clean, binary, neutral).

The Ladder entry was clarified as **append-only** — entries are never deleted, even on demotion. Where the paper system erases, FlashFlow preserves. This is a deliberate improvement on the paper original.

The user also surfaced the **forgiveness on missed days** principle (a card due in the past is simply due now; no penalty for lateness; backlog spreading is a v2 problem).

### 7. Backlog document created

A new artefact, not part of the nine-layer sequence but adjacent to it. Captures v2+ items deferred from v1. Six items at session end: Excel import, offline mode, backlog spreading, edit history, statistics, multi-user. Plus an empty "Considered and rejected" section.

### 8. Development environment fully set up — twice

Apple's Command Line Tools auto-installer was broken in the morning ("Softwareupdateserver nicht verfügbar"). Three install paths failed before a macOS update from 26.0.1 to 26.4.1 unstuck it. After that, full install proceeded smoothly:

**iMac**:
- Git 2.50.1
- User identity configured (Friedrich Neuhaus, fhneuhaus@gmx.de)
- SSH key generated and registered with GitHub as `iMac (fn)`
- Homebrew 5.1.8
- VS Code 1.118.0 with shell command enabled

**MacBook** (afternoon, in preparation for working from home):
- Git 2.50.1 (already installed)
- Same identity configured
- Separate SSH key generated and registered as `MacBook (fn)`
- Homebrew 5.1.8
- VS Code 1.117.0 with shell command enabled
- Repository cloned via `git clone git@github.com:fhneuhaus/flashflow.git`

Both Macs synced at the same commit hash. Two-machine workflow ready: `git pull` before starting, `git push` before stopping.

### 9. Repository on GitHub

`github.com/fhneuhaus/flashflow` (public). Three commits at end of day:

- `ee04495` — Initial commit: vision, goals, original system description, README, session note
- `93f78d6` — Revise goals.md and add constraints.md
- `7271405` — Add glossary.md and backlog.md (layer 4 complete)

Plus a fourth commit pending at end of session for the afternoon's revisions (cognitive-load goal added, intake-rate constraint added, plus this session note and the seed cards CSV).

---

## Conceptual ground covered

### The nine-layer software development sequence

Top-down from problem-space (1–6) to solution-space (7–9): Vision · Goals/non-goals · Constraints · Glossary · Domain model · Workflows · Architecture · Tech stack · Roadmap.

### Vocabulary introduced this session (with sources)

**Methodology and process**:
- Domain-Driven Design (Eric Evans, 2003) and the **ubiquitous language**
- Entity-relationship model (Peter Chen, 1976)
- Bounded contexts
- Architecture Decision Records (Michael Nygard, ~2011)
- Conway's Law (Melvin Conway, 1967)
- Cargo-culting; setup theatre
- Front-loading risk / long-pole items
- Backlog vs. roadmap
- Goal vs. constraint distinction; null sections

**Domain modelling**:
- Domain model vs. data model
- Append-only vs. mutable data structures

**Tools and infrastructure**:
- Git (Linus Torvalds, 2005); GitHub
- Working directory / staging area / repository
- Commits, hashes, the `..` range syntax
- `origin` as the conventional remote name
- SSH key pairs (private stays, public goes to GitHub)
- Public-key cryptography (1970s, foundation of internet security)
- Homebrew (~2009) and its beer-themed vocabulary (formula / cask / tap)
- Smart quotes harmful in the terminal
- Piping in Unix

**Design principles**:
- Edit-in-place
- Application code vs. operational code
- Forgiving vs. punishing SRS schedulers
- Docs-as-code (mid-2010s industry shift)

**Project vocabulary**:
- Artefact vs. build artefact
- Progressive Web App (PWA)
- Spaced Repetition System (SRS)

### Two meta-principles reinforced through use

**Higher layers should change more slowly.** Vision rarely; goals per version; tech stack when painful; roadmap weekly. Editing the Vision often signals lower-layer creep.

**Requirements are best elicited from concrete moments of use.** Twice the user's "but in my actual workflow..." correction reshaped a goal that abstract reasoning had gotten wrong. Generic "what does a flashcard app need" produces wrong answers; specific "when a course finishes, I have 300 cards in a batch" produces right ones.

### Trap surfaced and named

**Cargo-culting enterprise process** at solo scale produces overhead without benefit. Match formality to scale. The corollary: resisting *useful* structure (Git, vision documents, glossary) because it feels like enterprise overhead is the equally bad opposite.

---

## Methodology decisions for how we work

- **Project context instruction in place** in Claude.ai. Persists across conversations.
- **Periodic consolidation notes** as markdown files (`session-NN-progress.md`), at conceptual breakpoints. Live in `docs/learning-journal/`.
- **Docs-as-code** — all documentation lives in the repository alongside code, version-controlled together.
- **The user runs commands, the assistant explains.** No silently-done work.
- **Flashcard discipline**: ≤3 atomic items per answer, definition-shaped (not advice), capped at ~24/day in seeding bursts but ~10–15/day in steady state per the intake-rate constraint.
- **Single source of truth for cards**: `software-craft-seed-cards.csv` in the project root, appended to each session, eventually loaded via the v1 import script.

---

## Where we are now

### Documents in the repository

```
flashflow/
├── README.md
└── docs/
    ├── vision.md                       (Layer 1 ✓)
    ├── goals.md                        (Layer 2 ✓, twice revised)
    ├── constraints.md                  (Layer 3 ✓, restructured)
    ├── glossary.md                     (Layer 4 ✓)
    ├── backlog.md                      (Adjunct ✓)
    ├── flashcard-system-original.md    (Reference)
    └── learning-journal/
        └── session-01-progress.md      (This file)
```

### Pending end-of-day commit

Four files changed since the last push:
- `goals.md` — adds cognitive-load goal, plus forgiveness goal, plus no-spreading non-goal
- `constraints.md` — adds card-intake-rate constraint, refines skill-level with SME half
- `session-01-progress.md` — this file, replacing the previous version
- `software-craft-seed-cards.csv` — new file, 52 cards total

### Time check

~5 hours of FlashFlow work spent (excluding lunch and other interruptions). ~10% of the 50-hour budget. Roughly on schedule with a small cushion. The remaining 45 hours include all code work; the easy hours are now behind us.

---

## Resume — first actions next session

The natural pickup point is **Layer 5 — the domain model**. The glossary defines the entities; the domain model states their relationships. Subject contains Chapters; Card has a Ladder; Ladder consists of Ladder Entries. Roughly 30–45 minutes of work, builds directly on the glossary.

Then **Layer 6 — workflows** (use cases). What the user does, step by step, in each of the system's main scenarios. Daily review, in-app authoring, edit-during-review, maintenance.

After those two, the entire problem-space is complete and we move to solution-space (architecture, tech stack, roadmap).

To resume on either Mac:

```
cd ~/Projects/flashflow
git pull
```

Then either Mac is ready. Open with `code .` if VS Code is wanted.

---

## Reflections on the session

- **The user's pushbacks were the most valuable contributions.** The CSV-import-as-script decision, the edit-during-review distinction, the cognitive-load goal, the card-intake-rate constraint, the goal-vs-constraint editorial discipline, the missed-days/forgiveness principle, and the backlog adjunct all came from user instinct or correction. Without them the design would have been generic.

- **Setup work cost about an hour to Apple's broken installer**, plus another 30 minutes to the MacBook setup. About 25% of the day on environment, which is high but front-loaded — the same setup cost is now zero for every future session.

- **The two-machine workflow is real, not theoretical.** Setting up the MacBook before leaving the office means the home session resumes in seconds rather than starting cold. Tomorrow morning's evidence will confirm whether the discipline holds (`git pull` before starting work).

- **The flashcard discipline matured over the day.** The morning's first batch had bloated multi-item cards; the user caught it; the afternoon revision applied the discipline retroactively to morning cards too. The result: 52 cards, each atomic, each recallable. The single-discipline rule beats the inconsistent-but-historical one.

- **The Software Craft pivot continues to pay dividends.** Cards generated this session capture concepts encountered while building. The reinforcing loop is real: future-you, reviewing these cards, will encounter the same vocabulary that shaped the project's first day.

---

*End of session 01 progress note.*
