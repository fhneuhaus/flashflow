# FlashFlow — Workflows

*Status: accepted · Date: 2026-04-29*

What the user does, step by step, in each of the system's main scenarios. Together with the domain model, this layer specifies what the UI must support. Storage and rendering decisions belong downstream (architecture, tech stack); this document stays at the level of user action and system response.

Five workflows in priority order: daily review, in-app authoring, edit-during-review, maintenance, CSV import. The daily review is the design centre — it must feel frictionless even if other workflows are slightly clunky.

---

## A note on session boundaries

FlashFlow has **no concept of a "review session."** There is only the stack — recomputed every time the user opens the app — and the cards in it.

In practice the user works through the stack in fragmented bursts: five cards on the train, eight cards between meetings, the rest in the evening. The system does not track "session start" or "session end"; it only tracks cards and ladder entries. Every time the user opens the app, the stack reflects the current truth: cards currently due, minus cards already passed today.

This matches the paper system, where there is no concept of session either — there is only "what's behind today's tab."

The implications run through every workflow below, so it's stated once here at the top.

---

## Workflow A — Daily review

The most important workflow. Used every day; bears the entire weight of "is this system actually being used."

### What is in today's stack

A card is in today's stack if both:
- Its next-review-date is on or before today, **and**
- It has not already been successfully passed today, **and**
- It has not already been failed today (failed cards return at the next app open, not within the same continuous session).

This means:
- Cards that came due naturally today are present.
- Cards from missed days mix in (the system is forgiving — see `goals.md`).
- Cards the user passed earlier today are gone.
- Cards the user failed earlier today are gone *until the next app open*.
- Cards the user failed yesterday and never recovered are present today.
- Newly authored or imported cards are present (their `Initial` ladder entry makes them due today).

### Order of the stack

Within the stack, cards appear in this order:
1. **Returned cards first** — cards that were failed in a previous session and are now back. These are the "yesterday's unfinished business" cards. The user confronts them directly rather than having them buried in the rest of the stack.
2. **Everything else, shuffled** — randomised order. This matches the paper system's de-facto behaviour (cards behind a tab are in whatever order they were filed) and aligns with the cognitive-science research on **interleaving**: mixing different items in practice produces worse short-term performance but better long-term retention than blocked practice.

The shuffle is fresh on every app open. The user does not see the same order twice in a row.

### Steps

1. The user opens the app on any device. The home screen loads and computes today's stack.
2. The home screen shows **one thing**: the stack count (e.g., "12 cards"). No other navigation, no statistics. If the stack is empty, the home screen shows the appropriate "Done" message (see below); otherwise it shows the first card.
3. The first card appears, **question side**. Visible: the question text, the chapter name (small, unobtrusive), the ladder rendered compactly (e.g., `a — 1 — 3 — 7 — 14`), and a single button: **Show answer**.
4. The user reads the question, attempts to recall the answer, then taps **Show answer**.
5. The card flips: now showing the **answer side**. Visible: the answer text, the question (small, for context), the same ladder, and two buttons: **Pass** and **Fail**.
6. The user judges themselves and taps one.

   **6a. If Pass:**
   - The card's ladder gains a new pass entry at the next interval up the doubling progression.
   - If this pass follows a fail (the card is being recovered from a previous session's failure), the demoted interval is used: one rung below the previous best.
   - The card disappears from today's stack.
   - The next card in the stack appears, question side. Loop to step 3.

   **6b. If Fail:**
   - The card's ladder gains a fail (`X`) entry, dated today.
   - The card is removed from today's stack and will reappear the next time the app is opened (returned-cards-first position).
   - The next card in the stack appears, question side. Loop to step 3.

7. When the stack is empty, the home screen shows one of two messages:

   **If there are no unresolved fails from today:**
   > **Done for today.**

   **If there are unresolved fails from today (cards waiting for the next app open):**
   > **Done for now.**
   > 3 cards from today need a second look. They'll be waiting next time you open the app.

   The number reflects the actual count of unresolved fails. The user can close the app, navigate to authoring or maintenance, or simply leave the home screen open.

### Design notes

**One-screen, one-action.** The daily-review interface should never present more than one decision at a time: Show answer, then Pass or Fail. No menus, no preferences, no statistics during review. An unobtrusive way to access edit-during-review (Workflow C) is the only exception.

**Always full stack — no filtering for v1.** The user cannot choose to review only a specific subject or chapter; the system shows whatever is currently due. Subject/chapter filtering is a known v2 candidate for when FlashFlow holds multiple subjects.

**No undo for v1.** If the user misclicks Pass when they meant Fail, the ladder is wrong. Adding undo means tracking in-session state of every card and being able to roll back, which is meaningful complexity. Out of scope for v1; can be added later if the misclick rate is genuinely annoying.

**Cards added today are due today.** New cards from authoring or import appear in today's stack with the `Initial` ladder entry, due immediately.

---

## Workflow B — In-app authoring

Used occasionally — when the user wants to capture a single card mid-day without going through the CSV pipeline.

### Steps

1. The user navigates from the home screen to a chapter list view (per subject).
2. The user selects an existing chapter, or creates a new chapter (or a new subject).
3. Within the chapter, the user sees its existing cards listed compactly (question only, perhaps with a small ladder summary).
4. The user taps **Add card**. A form appears: question, answer, optional source override (which inherits from chapter or subject if blank).
5. The user fills in the form and taps **Save**.
6. The new card is created, with `Initial` ladder entry, dated today. It enters today's stack.
7. The form clears (or the user taps **Done**). The user can add another card or navigate away.

### Design notes

**No bulk operations in the UI.** Authoring is one card at a time. Bulk loading is the CSV import script's job (Workflow E).

**Plain text input.** Question and answer fields preserve newlines but apply no formatting. Bullet characters, special punctuation, German umlauts — all stored as typed.

**Source override is optional.** Most cards in a chapter share a source, set at the chapter level. The per-card override exists for the rare exception.

---

## Workflow C — Edit-during-review

The workflow that surfaces only mid-review, when the user notices a card's wording is bad.

### Steps

1. While viewing any card during review (question side or answer side), the user invokes an **edit affordance** — a small icon visible on the card.
2. An edit form opens, pre-filled with the card's current question and answer.
3. The user makes changes and taps **Save**.
4. The card's content is updated. The ladder is **unchanged** — only the text changed, not the review history.
5. The review continues with the same card now showing its updated content. The user can decide whether to re-attempt the recall against the new wording or skip past with a Pass.

### Design notes

**Editing must be one tap from the card itself.** This is the goal that distinguishes edit-during-review from maintenance. If the user has to navigate to a chapter, find the card, and edit it from there, the edit doesn't happen — the moment passes.

**The ladder doesn't reset on edit.** A card whose answer was poorly worded is still the same concept; recall difficulty isn't necessarily affected by clearer phrasing.

**Edit history is not preserved in v1.** Earlier versions of question/answer are overwritten. (See backlog.)

---

## Workflow D — Maintenance

The rare workflow: changes to cards or hierarchy outside the review flow.

### Steps (depending on the operation)

**Edit a card outside review:**
1. Navigate to the chapter containing the card.
2. Select the card.
3. Edit form opens, same as in Workflow C.
4. Save.

**Move a card to a different chapter:**
1. Navigate to the card.
2. Select **Move to another chapter**.
3. Pick the destination chapter.
4. Confirm. The card's parent changes; ladder is preserved.

**Delete a card:**
1. Navigate to the card.
2. Select **Delete**.
3. Confirmation prompt.
4. The card and its ladder are permanently removed.

**Rename or renumber a chapter or subject:**
1. Navigate to the chapter or subject.
2. Edit its title (or its optional number).
3. Save.

**Delete a chapter or subject:**
1. Navigate to it.
2. Select **Delete**.
3. Confirmation prompt that names how many cards will be affected.
4. The chapter (or subject), all its child cards, and all their ladders are permanently removed.

### Design notes

**No bulk operations.** Move-cards-by-tag, batch-delete, batch-edit — all out of v1 scope.

**No "reset ladder" affordance.** If the user really wants a card back at `[Initial]`, the path is delete-and-re-add. This avoids the footgun of accidental resets.

**Confirmation only for destructive actions.** Editing text and renaming are reversible enough not to need confirmation; deleting is not.

---

## Workflow E — CSV import

A command-line workflow, run on the developer's machine. Briefly described here for completeness; full specification belongs in the script's own documentation when it's built.

### Steps

1. The user produces a CSV file in the defined format (three columns: `chapter, question, answer`) using their upstream pipeline (AI-drafted notes proofread by user; AI-drafted cards proofread by user; output to CSV).
2. The user runs the import script from their Mac's terminal, pointing it at the CSV file: e.g., `python import_cards.py software-craft-cards.csv`.
3. The script reads each row, creates any chapters that don't yet exist, and inserts each card into the appropriate chapter with `Initial` ladder entry dated today.
4. The script prints a summary: how many cards imported, how many chapters newly created, any rows skipped or errored.

### Design notes

**No web upload.** Bulk operations belong at the command line, requiring intentional invocation.

**Idempotency is not guaranteed in v1.** Running the same CSV twice will create duplicate cards. The user is responsible for not doing this. (Worth a backlog item: detect and skip duplicates.)
