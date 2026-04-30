# FlashFlow

A digital version of a long-running paper spaced-repetition flashcard system.

## What this is

FlashFlow is a single-user web application that brings a paper flashcard system used by the author since the early 2010s into digital form, accessible from desktop, laptop, and phone. It preserves the distinctive features of the paper original — the visible interval ladder, the demotion-on-failure rule, the daily ritual of working today's stack.

It is built as a personal learning project: the deeper aim is to understand how modern software is designed, written, deployed, and maintained.

## Documentation

The conceptual and design documentation lives in [`docs/`](docs/), organised by the design sequence:

**Problem space**

- [`docs/vision.md`](docs/vision.md) — why FlashFlow exists.
- [`docs/goals.md`](docs/goals.md) — what v1 will and will not do.
- [`docs/constraints.md`](docs/constraints.md) — facts the project must live within.
- [`docs/glossary.md`](docs/glossary.md) — the project's vocabulary.
- [`docs/domain-model.md`](docs/domain-model.md) — entities and their relationships.
- [`docs/workflows.md`](docs/workflows.md) — what the user does, step by step.

**Solution space**

- [`docs/architecture.md`](docs/architecture.md) — the major parts of the system and how they communicate.
- [`docs/tech-stack.md`](docs/tech-stack.md) — the specific technologies chosen for each architectural role.
- [`docs/roadmap.md`](docs/roadmap.md) — the sequence in which v1 gets built.

**Adjuncts**

- [`docs/backlog.md`](docs/backlog.md) — known-desirable items deferred from v1.
- [`docs/flashcard-system-original.md`](docs/flashcard-system-original.md) — description of the paper system that inspired this build.
- [`docs/learning-journal/`](docs/learning-journal/) — session-by-session notes on what was learned and decided.

## Status

Design phase complete. All nine layers of the design sequence are settled and documented. First code begins in session 03.
