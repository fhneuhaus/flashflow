# FlashFlow — Domain Model

*Status: accepted · Date: 2026-04-29*

The relationships between the entities defined in `glossary.md`. This document states the conceptual model — what relates to what — independent of how those relationships will be stored. Storage decisions belong in the data model and follow from this. Algorithmic rules (how next-review-date is computed, how demotion is applied) belong in the scheduler document and also follow from this.

---

## The hierarchical core

Three entities form a strict tree:

- A **Subject** contains zero or more **Chapters**. Every Chapter belongs to exactly one Subject.
- A **Chapter** contains zero or more **Cards**. Every Card belongs to exactly one Chapter.

A Card therefore has exactly one Subject (via its Chapter), but a Subject does not own Cards directly — the Chapter is always the immediate parent.

No Card exists without a Chapter; no Chapter exists without a Subject. There is no "uncategorised" or "loose" state.

```
Subject (1) ──contains──▶ Chapter (0..n)
Chapter (1) ──contains──▶ Card (0..n)
```

---

## The review history

Every Card has its own review history, modelled as a separate entity called the Ladder.

- A **Card** has exactly one **Ladder**. The Ladder is created when the Card is created and exists for the Card's entire life.
- A **Ladder** consists of one or more **Ladder Entries**, ordered by date. The first entry is always an `Initial` entry, written when the Card is created.
- A Ladder Entry belongs to exactly one Ladder (and therefore to exactly one Card).

The Ladder is **append-only**: entries are added but never deleted or modified, even on demotion. This is a deliberate divergence from the paper system, which erases.

A **Ladder Entry** has a single `kind` field with three possible values:
- `Initial` — recorded when the Card is created
- `Pass` — a successful review at a given interval
- `Fail` — an unsuccessful review

Pass entries also carry an interval value (in days). All entries carry a date.

```
Card (1) ──has──▶ Ladder (1)
Ladder (1) ──has──▶ Ladder Entry (1..n)
```

*Modelling note:* the Ladder is kept separate from the Card rather than collapsed into it, because the two have different update semantics. The Card's content (question, answer) is authored once and rarely changes. The Ladder accumulates with use, growing on every review. In the paper system, the Q/A was printed in ink and the Ladder written in pencil — different durability, different kind of thing — and the software model honours that distinction.

---

## Source attribution

Source attribution can be set at three levels — Subject, Chapter, Card — and inherits down. A Card's *effective source* is determined by walking up the hierarchy:

1. If the Card has its own `source`, use that.
2. Otherwise, if the Chapter has a `source`, use that.
3. Otherwise, if the Subject has a `source`, use that.
4. Otherwise, the Card has no source attribution.

Source is therefore **modelled at three levels** but **resolved to one value** at any given moment for any given Card. Setting a source at any level overrides whatever would have been inherited.

This is the only part of the model where a property's meaning depends on context (the *effective* source of a card is not just the source field of that card; it depends on what its parent chapter and subject have set).

---

## Computed properties

Several useful properties of a Card are not directly stored — they are derived from the Ladder. The domain model names them here without specifying *how* they are computed; the derivation rules are the scheduler's responsibility.

- **next-review-date** — when this Card next becomes due
- **current interval** — the most recent successful interval, or none if the card has never been passed
- **is-due-today** — whether the Card belongs in today's Stack
- **is-in-flight** — whether the Card has failed today and not yet been recovered

The **Stack** (set of cards due today) is therefore not a stored entity — it is the result of the query *"all cards for which `is-due-today` is true."*

---

## What the model does not contain

Worth being explicit about absences:

- **No User entity.** Single-user system; there is exactly one user, implicit. If the system ever became multi-user, every Subject, Chapter, Card, and Ladder would gain a `belongs-to-User` relationship.
- **No Tag entity.** Cross-cutting categorisation is out of v1 scope.
- **No Session entity.** A review session is a span of time during which the user works through the Stack; it has no formal existence in the model. (Each Ladder Entry knows its own date, which is sufficient.)
- **No Deck entity.** Anki's term, not used here. Subject and Chapter together are FlashFlow's organising hierarchy.

---

## The whole model in one diagram

```
    Subject  ─────────── source (optional)
      │ 1
      │
      │ 0..n
    Chapter  ─────────── source (optional, overrides Subject)
      │ 1
      │
      │ 0..n
    Card     ─────────── source (optional, overrides Chapter)
      │ 1
      │
      │ 1
    Ladder
      │ 1
      │
      │ 1..n
    Ladder Entry
      │
      │ kind: Initial | Pass | Fail
      │ date
      │ interval (only for Pass)
```

Five entities, six relationships. Source attribution attached at three levels with inheritance applied at read time. Computed properties named but their derivation is the scheduler's concern.
