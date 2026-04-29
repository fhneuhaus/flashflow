# FlashFlow — Goals and Non-Goals (v1)

*Status: accepted · Date: 2026-04-29 (revised)*

This document defines what FlashFlow v1 must do (Goals) and what it explicitly will not do (Non-Goals). It scopes the 50-hour build window. Decisions to add, remove, or change items in either list should be made deliberately and recorded as updates to this document.

---

## Goals

What v1 must deliver to be considered successful.

- **Faithfully implement the paper system's review mechanic** — interval ladder, doubling progression, demotion-on-failure rule, same-day re-attempts. The scheduler is the part that must be correct above all.

- **Surface the ladder visibly in the UI**, mirroring the role of the marginal pencil notation on the paper card. The user can see at a glance where any card sits in its review history.

- **Keep cards in a sustainable difficulty range.** Card content and review pacing must be shaped to keep first-try recall in roughly the 80–90% band. Answers must not exceed three items; concepts requiring more must be split into multiple cards. Sessions must not generate failure backlogs large enough to be discouraging.

- **Run on iMac, MacBook, and iPhone** through a single web codebase, installable as a Progressive Web App on the phone.

- **Support in-app authoring** for ad-hoc card creation, editing, moving, and deleting cards inside the Subject → Chapter hierarchy. **Editing must be reachable directly from the review screen** — when a card is in front of the user, fixing its wording is one action away, not a navigate-and-find expedition. The Software Craft seed subject is built this way; ongoing refinement of any subject's cards uses this path.

- **Provide a command-line import script** for bulk-loading cards from a defined three-column CSV format (chapter, question, answer). This is the primary path for adding cards produced by upstream workflows, including AI-assisted ones (lecture notes drafted by AI and proofread by the user; flashcards drafted by AI and proofread by the user). The script runs locally on the developer's machine and writes to the same database the web app reads from.

- **Ship with Software Craft as the seed subject**, with cards authored during the build itself. The system being built is used to consolidate the vocabulary of building it.

- **Be deployed and accessible from real devices by the end of the 50-hour budget** — not running only on the developer's laptop. "Deployed" means a real URL the user can open from any of their devices.

- **Produce, alongside the working software, a coherent set of project documents** (vision, goals, constraints, glossary, domain model, architecture, learning journal) that a future reader could use to understand both what was built and why.

---

## Non-Goals

What v1 will explicitly not do, even though someone might reasonably expect it to. These exist to prevent scope creep and to make trade-offs deliberate.

- **No in-app bulk import.** Bulk operations happen via command-line scripts, not through the web interface. The web interface is for review and ad-hoc card management only.

- **No support for the original Art History Excel file format.** The v1 importer accepts a defined CSV format with three columns. Bringing the existing Art History workbook across will require a separate conversion step, deferred to a later iteration.

- **No images, audio, video, mathematical notation, or rich-text formatting** in cards. Plain text with newlines preserved is the entire content model.

- **No statistics, dashboards, graphs, or analytics.** The only number visible is "cards due today."

- **No tags, cross-cutting categories, or alternative groupings** beyond the Subject → Chapter tree.

- **No card suspension, burying, "leech" detection, or other Anki-style affordances.**

- **No multi-user support, sharing, or social features.** Single user, full stop.

- **No native mobile applications.** Phone access is via Safari only, as a Progressive Web App.

- **No offline mode.** v1 requires an internet connection at review time. May be revisited in a later iteration.

- **No in-app AI features.** The application does not call AI services, generate cards, suggest answers, or assist with review judgement. AI tools used upstream of the import (drafting lecture notes, drafting card content) are the user's own workflow and outside FlashFlow's concern.

- **No automated tests beyond the scheduler.** The scheduler must have tests because correctness matters and bugs are subtle. Everything else is verified by use.

---

## Notes on the trade-offs

Several of these decisions are deliberate trade-offs worth flagging for future readers:

**Offline mode is deferred** because building an offline-capable Progressive Web App roughly doubles client-side complexity (local storage, sync, conflict resolution, service workers). At 50 hours on a first project, this is the difference between shipping and not shipping. If review-without-internet becomes important in practice, it is a candidate for a later iteration.

**Tests beyond the scheduler are out of scope** because at solo-project scale, the cost of a comprehensive test suite outweighs the benefit. The scheduler is the exception: it holds the algorithm, and a bug there silently corrupts review history. Everything else is small enough that ten minutes of use catches problems. This trade-off would be irresponsible at team scale; it is appropriate here.

**The "no in-app AI" line is drawn deliberately.** AI as a tool in the user's upstream workflow is not only acceptable but explicitly anticipated (the import path is shaped to accommodate it). What is excluded is AI baked into the application's own features — auto-generation, suggestion, assisted review. The user's attention and judgement remain the active ingredients in the spaced-repetition loop.

**The split between in-app authoring and command-line import is also deliberate.** Bulk operations belong in scripts, where they require intentional invocation and cannot be triggered by accident. Single-card operations belong in the UI, where they fit the natural rhythm of using the system. Treating these as one feature would over-complicate the web app and under-protect the bulk path.

**The cognitive-load goal exists because spaced repetition is a motivation system as much as a memory system.** A spaced-repetition system that produces frustration kills its own use. Keeping first-try recall in the 80–90% band — the "desirable difficulty" zone described in cognitive psychology — keeps the loop sustainable. This applies to card authoring, card splitting, and the pacing of sessions.
