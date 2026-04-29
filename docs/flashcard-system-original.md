# The Spaced-Repetition Flashcard System

A hand-built knowledge consolidation method, refined over more than a decade and applied across multiple domains — foreign language vocabulary (German, Italian), art history, art business — with a single underlying mechanic.

## Architecture

The system has three layers: an **authoring layer** (Excel), a **production layer** (a print macro), and a **review layer** (two physical tab-indexed boxes). Each layer feeds the next; together they convert raw subject matter into long-term memory through scheduled retrieval.

## Layer 1 — The Knowledge Database

The author dissects a subject into atomic question/answer pairs and records each in a master Excel workbook. Every row carries its own metadata:

- **TeilNr / TeilTitel** — top-level domain (e.g., *Art History*)
- **KapitelNr / KapitelTitel** — chapter or sub-topic (e.g., *The Classical Tradition*)
- **Question** and **Response** — the atomic Q&A
- **Datum** — date of creation
- **Rev.** — revision marker

This database is the permanent, searchable record. New cards can be added at any time; existing ones can be edited or re-tagged. The hierarchy supports both broad sweeps ("review all of Art History") and tight focus ("just The Classical Tradition").

## Layer 2 — The Print Macro

An Excel macro converts batches of eight rows from the database into a print-ready double-sided A4 layout. The front shows the questions in a 2×2 grid; the back shows the matching answers, mirrored so that after double-sided printing each question aligns precisely with its answer. A footer carries the source/course attribution, the chapter context, and the creation date.

A paper cutter then reduces the sheet to eight physical flashcards. From this point on, each card is a self-contained learning artifact — no app, no screen, no battery.

## Layer 3 — The Review Loop

Each card is reviewed under a steered-interval protocol. The interval ladder is written by hand in the card's margin and grows roughly by doubling: **a → 1 → 3 → 7 → 14 → 30 → 60 → ...** days.

- **'a'** (or 'i') marks the *initial* review, done on the day the card is created — fresh in memory.
- A **successful** recall extends the ladder: the next interval is added in pencil.
- A **failure** is marked with **'X'** and the card is re-reviewed the same day. If the same-day re-review succeeds, the card is **demoted by one rung** — the last successful interval is erased. The card does not reset to zero, but it must re-earn the lost ground. This rewards consistency without punishing slips catastrophically.

The card itself thus carries its complete review history in its margin. There is no separate tracking ledger; the artifact *is* the record.

## The Calendar Boxes

Two wooden boxes with plastic tabs hold all active cards:

- **Day box (1–30)** — a rolling 30-day horizon for short and mid-range intervals
- **Month box (1–12)** — the long tail, for intervals beyond 30 days

After a successful review, the card is filed forward by its new interval. The math is simple modular arithmetic: a card reviewed on the 29th with a new interval of 14 lands behind tab **(29 + 14) mod 30 = 13**. Cards with intervals beyond 30 days migrate to the month box and re-enter the day box at the start of their target month.

The position of the card in physical space *is* its schedule. To know what to study today, the user opens today's tab and works the stack.

## What Makes the System Work

- **Atomicity** — each card holds exactly one fact, one question, one answer. Granularity makes both authoring and recall manageable.
- **Hierarchical metadata** — every card knows where it belongs in the larger subject, so cards from any domain can coexist in the same box without losing context.
- **Self-documenting artifacts** — date stamp, source, and review ladder are all on the card. A card pulled at random tells its full history at a glance.
- **Steered, not algorithmic, scheduling** — the intervals are principled (expanding spacing) but the human stays in the loop. Demotion-on-failure is a deliberate, tactile feedback signal: the eraser leaves a trace.
- **Physical-first design** — paper, tabs, pencil, eraser. The system never crashes, never demands a sync, never updates its terms of service. It has run continuously for over a decade across multiple subjects.

The two photographs of the box show the system in steady state: hundreds of cards spanning multiple language levels (A2 through B2) and multiple textbooks (Hueber, Alma, Firenze/Scuola David), interleaved by review date rather than by source. The oldest visible date stamp is from early 2023; the newest from 2024. Each card has been printed once, cut once, and then circulated through the boxes potentially dozens of times.
