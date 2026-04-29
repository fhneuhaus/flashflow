# FlashFlow — Session 01 Progress

*Date: 2026-04-29*
*Duration: ~7.5 hours of FlashFlow work, across morning, afternoon, and evening*
*Status: end of session 01. Layers 1–6 complete; entire problem-space closed. Two-machine development setup working. Domain registered and DNS configured for tomorrow's deployment.*

---

## What this session was about

The first working session of the FlashFlow project — a digital re-implementation of a long-running paper spaced-repetition flashcard system. The day began with environment setup and methodology decisions, moved through the six problem-space layers of the design, and ended with the technical groundwork (second-machine setup, domain configuration) for tomorrow's deployment work.

A reinforcing loop emerged: FlashFlow's first subject is **Software Craft** — the vocabulary and disciplines being learned during the build itself.

A second context emerged mid-afternoon: FlashFlow is preparing the developer for the **WhiteGlove project** — a separate, larger build (a financially-staked prediction platform for major art auctions, multi-year, regulated-adjacent, public-facing). This shifted the technology bias for FlashFlow toward what WhiteGlove will use: TypeScript/Node.js for the application backend, Python for analytics.

---

## Major decisions and pivots (in chronological order)

### 1. Subject pivot: Art History → Software Craft

The starting subject changed from Art History (with a one-shot Excel import) to Software Craft (cards authored during the build). Excel import deferred to v2.

### 2. Project context instructions saved in Claude.ai

A custom-instructions block was saved into the Project's context, establishing the nine-layer top-down sequence, jargon-on-first-use discipline, the user-runs-commands principle, formality-matches-scale, and project shape. Persists across conversations. Updated late in the day with the WhiteGlove relationship.

### 3. Vision document accepted

One paragraph. FlashFlow is a single-user web application that brings the paper SRS into digital form across three devices, preserves the distinctive features of the paper original, and serves as a learning vehicle. Saved as `docs/vision.md`.

### 4. Goals and Non-Goals document accepted (revised twice)

Three pieces of pushback shaped the final draft:
- **CSV import is needed** because real workflow generates 300–600 cards per course as a batch.
- **CSV import belongs at the command line** as operational code, not as a web feature.
- **Edit-during-review is its own workflow** — one tap from the review screen, not navigate-and-find.

A late-session addition: **cognitive-load goal** — keep first-try recall in 80–90% band, answers ≤3 items.

### 5. Constraints document accepted (restructured mid-session, updated late)

Originally a flat list. Restructured into Process / Product / Business families. Empty business-constraints section kept deliberately rather than omitted. Two domain-expert constraints surfaced:
- **Card intake rate ceiling**: ~10–20 new cards/day in steady state.
- **The user is also a deeply experienced subject-matter expert** for the system being built.

Late-evening update added the **WhiteGlove relationship**: FlashFlow is a learning vehicle for the WhiteGlove project, and technology choices should mirror WhiteGlove's likely stack.

### 6. Glossary document accepted

Subject, Chapter, Card, Question/Answer, Ladder, Ladder Entry, Interval, Pass/Fail, Same-day re-attempt, Demotion, Stack, Review, Source, Import. Plus a "Terms we are not using" section excluding Anki vocabulary.

Three open questions resolved:
- Source attribution: **inheritable** through subject → chapter → card cascade.
- Today's collection of due cards: **Stack**.
- Review outcomes: **Pass / Fail**.

The Ladder entry was clarified as **append-only**.

### 7. Backlog document created (revised late in day)

Six initial items (Excel import, offline mode, backlog spreading, edit history, statistics, multi-user). Late-day revision added four more, all surfaced during the afternoon's design work:
- Subject and chapter filtering for review
- Undo for review actions
- External reminders for unresolved fails
- CSV import idempotency

Now ten v2+ items.

### 8. Development environment fully set up — twice

Apple's Command Line Tools auto-installer broke in the morning ("Softwareupdateserver nicht verfügbar"). Three install paths failed before a macOS update from 26.0.1 to 26.4.1 unstuck it. After that:

**iMac**:
- Git 2.50.1
- Identity configured (Friedrich Neuhaus, fhneuhaus@gmx.de)
- SSH key generated and registered with GitHub as `iMac (fn)`
- Homebrew 5.1.8
- VS Code 1.118.0 with shell command enabled

**MacBook** (mid-afternoon, in preparation for working from home):
- Git 2.50.1 (already installed)
- Same identity configured
- Separate SSH key generated and registered as `MacBook (fn)`
- Homebrew 5.1.8
- VS Code 1.117.0 with shell command enabled
- Repository cloned via `git clone git@github.com:fhneuhaus/flashflow.git`

Both Macs now synced through GitHub. Two-machine workflow proven by an actual evening sync (the iMac pushed; the MacBook pulled the new commits down).

### 9. Layer 5 — Domain Model accepted

Subject contains Chapter contains Card. Card has a Ladder. Ladder consists of Ladder Entries. Source attribution at three levels with inheritance.

A meaningful design insight emerged from the user's domain experience: **Ladder is kept separate from Card** because in the paper system the Q/A is printed in ink while the Ladder is written in pencil — different durability, different update semantics. The software model honours this distinction.

Computed properties (next-review-date, current interval, is-due-today, is-in-flight) are *named* in the domain model but their derivation is the scheduler's responsibility (not yet documented).

### 10. WhiteGlove context introduced; technology bias shifted

Mid-evening, the WhiteGlove project was introduced as the destination FlashFlow is preparing for. WhiteGlove's profile (TypeScript/Node.js application backend, Python for analytics, multi-year, public-facing, regulated-adjacent) was summarised from the sister Claude.ai project.

This **shifted the FlashFlow technology bias from Python to JavaScript/Node.js** for the application backend. Python remains directly relevant (CSV import script, analytical work) but the bulk of FlashFlow's code will now mirror WhiteGlove's likely stack.

The constraints document was updated to capture this. The Claude.ai project context was updated manually.

### 11. Layer 6 — Workflows accepted

Five workflows: daily review, in-app authoring, edit-during-review, maintenance, CSV import.

A **major design discussion** unfolded around the daily-review workflow when the user asked "could the user fail the last card and immediately get it again?" This surfaced the design space for review-handling and led to formal locking of four dimensions:

- **D1 (when failed cards return)**: at the next app open, with a soft in-app banner on the empty-stack screen ("3 cards from today need a second look").
- **D2 (order of cards in the stack)**: returned-from-yesterday cards first, then shuffled. Shuffling matches the paper system's de-facto behaviour and aligns with cognitive-science research on **interleaving** (Bjork et al.).
- **D3 (filtering)**: always full stack; no UI for filtering. Subject/chapter filtering deferred to v2 backlog.
- **D4 (session end)**: empty stack triggers a "Done" message; voluntary close always available.

The original draft included a **3-card cooldown rule** for failed cards. After analysis, this was simplified to "next app open" because it was the cleanest implementation path and required no new session state — a small but real example of essential vs. accidental complexity.

### 12. Domain registered for tomorrow's deployment

The user owns **whiteglove.exchange**, registered through Cloudflare, with DNS managed by Cloudflare nameservers (`elma.ns.cloudflare.com`, `leonard.ns.cloudflare.com`). MX records configured for Google Workspace email; web records currently empty. Tomorrow we will add a CNAME pointing `flashflow.whiteglove.exchange` at the deployment platform.

This domain is also the eventual home of the WhiteGlove project, so configuring DNS now is direct preparation for the larger project.

---

## Conceptual ground covered

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
- **Essential vs. accidental complexity (Fred Brooks, 1986, "No Silver Bullet")**
- **Hoare's two ways of constructing software (1980)**
- **Premature optimisation (Knuth, 1974)**

**Domain modelling**:
- Domain model vs. data model
- Append-only vs. mutable data structures
- **Interleaving in learning (Bjork et al., 1970s onward)**

**Tools and infrastructure**:
- Git (Linus Torvalds, 2005); GitHub
- Working directory / staging area / repository
- Commits, hashes, the `..` range syntax
- `origin` as the conventional remote name
- SSH key pairs (private stays, public goes to GitHub)
- Public-key cryptography (foundation of internet security since the 1970s)
- Homebrew (~2009) and its beer-themed vocabulary (formula / cask / tap)
- Smart quotes harmful in the terminal
- Piping in Unix
- **DNS record types: A, AAAA, CNAME, MX, TXT, NS**
- **Cloudflare as registrar + DNS provider + CDN**
- **Custom subdomains via CNAME records**

**Design principles**:
- Edit-in-place
- Application code vs. operational code
- Forgiving vs. punishing SRS schedulers
- Docs-as-code (mid-2010s industry shift)
- **Ephemeral session state (lives in the client, not the database)**

**Project vocabulary**:
- Artefact vs. build artefact
- Progressive Web App (PWA)
- Spaced Repetition System (SRS)

### Meta-principles reinforced through use

**Higher layers should change more slowly.** Vision rarely; goals per version; tech stack when painful; roadmap weekly.

**Requirements are best elicited from concrete moments of use.** Multiple times during the day, the user's "but in my actual workflow..." correction reshaped a goal that abstract reasoning had gotten wrong.

**In a learning project, every feature must earn its place in either user value or learning value.** If it does neither, cut it. Adding features to "practise more techniques" doesn't help if the techniques are exercised elsewhere.

**Late-arriving context can invalidate earlier reasoning.** The WhiteGlove context, surfaced mid-afternoon, shifted the technology bias for FlashFlow that had been preliminarily set in the morning. Future projects should surface the parent/successor project relationship in the foundational documents from the start.

**Front-loading risk applies at multiple scales.** From "install tools while waiting for OS update" in the morning to "deploy hello world before substantive code" in tomorrow's plan, the same instinct of doing risky-or-uncertain work early appears repeatedly.

---

## Repository state at end of session

### Commits on `main`

```
b62def3  End of session 01: add seed cards CSV, update session note (early afternoon version)
9913625  Add domain-model.md (layer 5 complete)
[constraints update commit]  Update constraints.md: add WhiteGlove relationship, shift tech bias to Node.js
[workflows commit]  Add workflows.md (layer 6 complete; problem-space closed)
[final commit pending]  End of session 01: backlog, seed cards, session note (final versions)
```

### Documents in the repository

```
flashflow/
├── README.md
└── docs/
    ├── vision.md                       (Layer 1 ✓)
    ├── goals.md                        (Layer 2 ✓)
    ├── constraints.md                  (Layer 3 ✓, with WhiteGlove section)
    ├── glossary.md                     (Layer 4 ✓)
    ├── domain-model.md                 (Layer 5 ✓)
    ├── workflows.md                    (Layer 6 ✓ — problem-space closed)
    ├── backlog.md                      (Adjunct, ten v2 items)
    ├── flashcard-system-original.md    (Reference)
    ├── software-craft-seed-cards.csv   (~60 cards across five chapters)
    └── learning-journal/
        └── session-01-progress.md      (This file)
```

### Time check

**~7.5 hours of FlashFlow work** today. **42.5 hours remaining** of the 50-hour budget. Roughly on schedule with no cushion remaining (the morning's Apple-installer outage and the second-Mac setup ate the original buffer).

---

## Plan for next session

### Goal: end day 2 with a working URL accessible from the iPhone

The shape of tomorrow's ~6 hours of work:

| Phase | Estimated time |
|---|---|
| Layer 7: Architecture | ~45 min |
| Layer 8: Tech stack (Node.js framework, database, hosting platform decisions) | ~60 min |
| Layer 9: Roadmap | ~30 min |
| Initial project scaffolding (npm init, Express install, hello world) | ~60 min |
| Deployment of hello world + CNAME to flashflow.whiteglove.exchange | ~90 min |
| Buffer / breaks / unexpected | ~45 min |

End state: `https://flashflow.whiteglove.exchange` returns a placeholder page from a real Node.js app, deployed from a real platform, accessible from the iPhone. No FlashFlow features yet, but the deployment chain proven end-to-end.

This **front-loads the deployment risk** before substantive code work begins.

### Resume command (either Mac)

```
cd ~/Projects/flashflow
git pull
```

Then start with Layer 7. Project context in Claude.ai persists; this session note plus the latest committed documents provide complete context for resumption.

---

## Reflections on the session

**The user's pushbacks were the most valuable contributions of the day.** The CSV-import-as-script decision, the edit-during-review distinction, the cognitive-load goal, the card-intake-rate constraint, the goal-vs-constraint editorial discipline, the missed-days/forgiveness principle, the backlog adjunct, the pencil-vs-ink insight that justified Ladder as a separate entity, the four-dimensions analysis of card-review handling, and the "every feature must earn its place" discipline applied to dimensions 3 and 4 — all came from user instinct or correction. Without them the design would have been generic.

**Setup work cost roughly 25% of the day** (Apple installer, MacBook setup, environment and tooling). High but front-loaded; the same setup cost is now zero for every future session.

**The two-machine workflow is proven, not just configured.** The MacBook's evening pull from GitHub successfully brought down commits made on the iMac earlier in the afternoon. The push from the MacBook (the constraints, workflows, and final commits) was the first proof that write operations work from the second machine. Both directions of the sync are now confirmed.

**The flashcard discipline matured during the day.** The morning's first batch had bloated multi-item cards; the user caught it; the discipline was applied retroactively to morning cards too. The result: ~60 cards, each atomic, each recallable, organised across five chapters.

**The Software Craft pivot continues to pay dividends.** Cards generated this session capture concepts encountered while building. Future-you, reviewing these cards, will encounter the same vocabulary that shaped the project's first day.

**The WhiteGlove context, when surfaced, retrofitted the design cleanly.** Six committed layers were not invalidated; only the technology bias (a preliminary lean, not yet locked) was shifted. The architecture, tech stack, and roadmap layers tomorrow will reflect the WhiteGlove-aligned choice. Most of the day's work transfers unchanged.

**An honest moment worth recording**: the assistant did not ask about the parent/successor project at the start. The vision document was drafted as if FlashFlow were the destination. When WhiteGlove was introduced, several decisions had to be revisited (the technology bias particularly). The lesson, going forward: when a project is preparation for a larger project, surface that fact in the foundational documents from the start. This will be relevant for any future projects.

---

*End of session 01 progress note.*
