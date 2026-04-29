# FlashFlow — Backlog

*Status: living document · Last updated: 2026-04-29*

Items known to be desirable but deferred from v1. New ideas that don't fit the v1 scope land here rather than being lost. Items leave this document either by being scheduled into a future version or by being explicitly abandoned (in which case they move to a "Considered and rejected" section, not deleted, so the reasoning is preserved).

Each entry captures: what the idea is, why it was deferred, what would bring it back into scope, and where in the project history it originated.

This document complements but is distinct from the roadmap (layer 9 of the design sequence). The backlog *captures* deferred work; the roadmap *sequences* what is to be built next. Most backlog items will never appear on a specific roadmap — they wait until pulled in, scheduled, or formally rejected.

---

## Deferred to v2 (or later)

### Excel import for Art History

**Why deferred**: the existing Art History workbook uses German column names, mixed German/English content, multi-line cells, embedded bullet characters, and idiosyncratic date formats. Building a parser that handles all of that is meaningful work and is not on the critical path for v1.

**What it would take**: a separate import script that reads the existing `.xlsx` file (Python's `openpyxl` library), maps its columns to the FlashFlow CSV schema, and produces a clean three-column CSV which the v1 importer then loads. Probably 4–6 hours.

**Source**: session 01, decided when Software Craft replaced Art History as the v1 seed subject.

---

### Offline review mode for the Progressive Web App

**Why deferred**: building an offline-capable PWA roughly doubles client-side complexity — local storage, sync logic, conflict resolution between offline reviews on the phone and online reviews on the iMac, service workers intercepting network requests. Not feasible in 50 hours on a first project.

**What it would take**: significant frontend work — service worker, IndexedDB or similar local storage, sync protocol, conflict-resolution rules. Likely 10–15 hours.

**Source**: session 01, captured as a non-goal in `goals.md`.

---

### Backlog spreading for long absences

**Why deferred**: when a long absence produces a large stack of overdue cards (after a holiday, an illness, a period of distraction), showing them all at once on return may overwhelm the user. The spreading mechanism is real but designing it well requires usage data we don't yet have.

**What it would take**: a working v1 with real usage history; observation of what real backlogs look like after real absences; then a design choice between approaches (simple cap, prioritised cap, explicit catch-up mode). Probably 4–6 hours once data exists.

**Source**: session 01, surfaced during the glossary discussion of "Stack" and how missed days behave.

---

### Edit history per card (beyond the ladder)

**Why deferred**: the ladder captures *review* history but not *content* edits. When a question or answer is revised, the previous version is lost. For v1 this is acceptable — most edits will be small typo fixes. For longer-running use, having the edit history would be valuable (analytics, undo, recovery from mistaken edits).

**What it would take**: a separate edit-log table in the database, written on every card content change, plus UI affordances to view past versions.

**Source**: implied by the edit-during-review goal in `goals.md`; not explicitly discussed yet.

---

### Statistics and analytics

**Why deferred**: explicitly out of v1 scope per `goals.md`. The non-goal exists deliberately to keep v1 focused on the daily-review experience and avoid surfacing data the user did not ask for.

**What it would take**: design work on what statistics actually serve the user (rather than what's easy to display). The append-only ladder makes the data available; the question is what to do with it. 6–10 hours, mostly design.

**Source**: implicit in the "no statistics" non-goal in `goals.md`.

---

### Multi-user support

**Why deferred**: explicitly out of v1 scope per `goals.md`. Single-user dramatically simplifies authentication, authorisation, data isolation, and deployment.

**What it would take**: a real auth system (sessions, password hashing, possibly OAuth), data scoping by user across every database query, multi-tenancy in the deployment. Significant — probably 10+ hours of work that would also rewrite parts of v1.

**Source**: implicit in the single-user constraint and non-goal.

---

## Considered and rejected

*(empty — no items have been formally rejected yet. When v2 ideas are explicitly abandoned, their entries move here with a "rejected because..." note added.)*
