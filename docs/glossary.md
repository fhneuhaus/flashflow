# FlashFlow — Glossary

*Status: accepted · Date: 2026-04-29*

The vocabulary of FlashFlow. These terms appear identically in conversation, code, and database. Changes to terminology must be made here first and then propagated.

Where a term has a German-language original from the paper system, it is noted in parentheses. The English form is canonical for the software.

This document defines terms; it does not state relationships between them. Relationships are the work of the next layer (the domain model).

---

## Core entities

### Subject *(Teil)*

A top-level domain of study. *Software Craft* is one subject; *Art History* is another. Subjects partition the user's body of cards into broad areas. Each subject contains one or more chapters.

*Distinction:* a subject is broader than a chapter and narrower than the entire system.

### Chapter *(Kapitel)*

A sub-topic within a subject. *Domain Modelling* is a chapter of *Software Craft*; *The Classical Tradition* would be a chapter of *Art History*. Each chapter contains zero or more cards. Chapters are the level at which review focus is typically organised ("review just chapter X").

*Distinction:* a chapter belongs to exactly one subject; a card belongs to exactly one chapter.

### Card

The atomic learning unit. One card holds one question and one answer. Belongs to exactly one chapter. Carries metadata: creation date, source attribution, ladder history.

*Distinction:* a card is one fact; not a list, not an essay, not a study sheet. The atomicity rule is non-negotiable.

### Question / Answer

The two text fields of a card. The question is what the user reads first; the answer is what they reveal after recall. Plain text only. Newlines preserved; no formatting.

*Note:* in the Excel original these were sometimes called *Question* and *Response*. We use *Answer* in code and conversation.

---

## The review mechanic

### Ladder

The complete review history of one card, expressed as an ordered sequence of entries. The ladder is the primary record of a card's progress; everything else (next-review-date, current interval) is computed from it. The ladder is *visible to the user* in the UI, mirroring the marginal pencil notation of the paper original.

*Distinction:* the ladder is per-card, not per-user or per-session.

**Append-only**: entries are never deleted, even when a card is demoted. Where the paper system erases, FlashFlow preserves. The UI may *render* superseded entries differently (struck-through, greyed out) to mirror the visual effect of the eraser, but the underlying data is kept.

### Ladder entry

One event in a card's review history. Each entry is one of three kinds:

- **Initial** — recorded when the card is created. Conventionally written `a` or `i`.
- **Pass** — a successful review at a given interval. Recorded as the interval in days (`1`, `3`, `7`, `14`, `30`, `60`...).
- **Fail** — an unsuccessful review. Recorded as `X`.

Each entry has a date and a kind. Pass entries also have an interval value.

### Interval

The number of days between a pass-entry and the next scheduled review of that card. Intervals follow a doubling progression: `1, 3, 7, 14, 30, 60, 120, 240...` days.

*Distinction:* the interval is a property of a pass entry, not of the card as a whole. A card's "current interval" is the interval of its most recent pass entry.

### Pass / Fail

The two outcomes of a review. *Pass* means the user recalled the answer; *Fail* means they did not. These are the only outcomes — no four-grade scale, no "almost," no partial credit.

*Distinction:* a fail does not reset the card. It triggers a same-day re-attempt; the demotion happens on recovery, not on the failure itself.

### Same-day re-attempt

A card that has failed today is re-shown later in the same review session. It is not removed from the day's stack until it has been recalled successfully at least once.

### Demotion

The mechanism applied when a card recovers from a fail. The card's last successful interval is replaced by the rung below it on the ladder. So a card whose ladder was `a — 1 — 3 — 7 — 14`, then fails, then recovers, becomes `a — 1 — 3 — 7 — 14 — X — 7`. The card has lost one rung in *effect* (next interval is 7, not 28), though all previous entries remain in the record.

*Distinction from paper system:* in the paper original, the demoted interval is erased with a pencil eraser; the card's ladder visibly loses a rung. FlashFlow preserves the full history because storage permits it and the data has analytic value. The visible *behaviour* is identical (same demotion); the *record* is more complete.

---

## Daily use

### Stack *(today's stack)*

The set of cards due for review today. A card is in today's stack if its next-review-date is on or before today — so cards from missed days mix in naturally with cards due today. Computed from each card's most recent ladder entry plus its interval.

*Distinction:* "stack" is a logical set, not a physical pile. The order within the stack is a UI decision.

### Review / Review session

A *review* is one act of looking at one card, recalling, judging pass or fail, and moving on. A *review session* is a sequence of reviews, typically working through today's stack until empty.

---

## Provenance and authorship

### Source *(Sotheby's IofA, etc.)*

An attribution recording where a card's content came from — a book, a course, a lecture, a particular project.

**Inheritance.** Source is defined at three levels: subject, chapter, and card. A card without an explicit source inherits from its chapter; a chapter without an explicit source inherits from its subject. A card's *effective* source is the nearest non-empty value walking up: card → chapter → subject. Setting a source at the card level overrides any inherited value.

*Rationale:* in real authoring, most cards in a chapter share a source (e.g. all cards from one lecture). Inheritance lets the user set the source once per chapter rather than per card. Override at the card level handles the exceptions.

### Import

The command-line operation of bulk-loading cards from a CSV file. Defined in `goals.md`. The CSV format is three columns: `chapter, question, answer`. Imported cards enter the system with their ladder set to `[Initial]`, due today.

---

## Terms we are not using

A few terms common in the spaced-repetition space that FlashFlow deliberately does *not* use, with brief reasons:

- **Deck** — Anki's word for a collection of cards. We use *Subject* and *Chapter* instead. "Deck" is too flat for our two-level hierarchy.
- **Note** — Anki's word for the underlying content from which one or more cards are generated. We don't have this distinction; one card holds its own content directly.
- **Ease factor**, **stability**, **difficulty** — terms from algorithmic SRS schedulers (SM-2, FSRS). We don't have these; our scheduler is rule-based, not statistical.
- **Bury**, **suspend**, **leech** — Anki affordances we don't replicate. Cards in FlashFlow are either in the system or deleted; there is no middle state.
- **Tag** — for cross-cutting categorisation. Not in v1. Subject and chapter are the only groupings.
