# FlashFlow — Session 01 Progress

*Date: 2026-04-29*
*Status: paused on environment setup, awaiting Apple developer infrastructure recovery*

---

## What this session was about

The first working session of the FlashFlow project — a digital re-implementation of a long-running paper spaced-repetition flashcard system. The session was deliberately conceptual rather than implementation-focused, with the user pushing back appropriately when the assistant jumped ahead to specifics before the foundations were laid.

A second-order goal also emerged: FlashFlow's first subject will be **Software Craft** — the vocabulary and disciplines of software development being learned during the build itself. The system will be used to commit to memory the concepts encountered while building it.

---

## Major decisions and pivots

### Subject pivot: Art History → Software Craft

Originally the v1 subject was Art History, with a one-shot Excel import as part of the v1 scope. Late in the session this was changed: the starting subject is now **Software Craft**, with cards authored in-app from scratch as concepts come up during the build. Art History is deferred to a later iteration.

**Consequence**: the Excel import is no longer in v1 scope. This simplifies v1 (no parser for German date formats, multi-line cells, German column names, etc.) and forces the in-app authoring path to be exercised properly from day one.

### Project context instructions saved

A custom-instructions block was drafted and saved into the Project's context in Claude.ai. It establishes:

- The nine-layer top-down sequence as the working method.
- The discipline of naming concepts and expanding acronyms on first use.
- The user runs commands, edits files, writes code; the assistant explains, proposes, reviews, debugs.
- Match formality to scale (solo project, ~50 hours, single user).
- Default to short answers plus a question; produce consolidation notes at breakpoints.
- Project shape: 50 hours, JavaScript/Python/Git focus, PWA on iPhone, Software Craft as starting subject.

This persists across conversations within the Project. New sessions will land already configured.

---

## Conceptual ground covered

### The nine-layer software development sequence

Top-down sequence from problem-space to solution-space, where each layer constrains the next:

1. **Vision** — one paragraph: why the system exists, what success looks like.
2. **Goals and non-goals** — what is in scope, what is explicitly out.
3. **Constraints** — environmental, temporal, technical, personal.
4. **Ubiquitous language / glossary** — terms and their definitions, used identically in conversation, code, and database.
5. **Domain model** — entities and their relationships, in entity-relationship style.
6. **Use cases / workflows** — what the user does, step by step.
7. **Architecture** — how the system is structured into layers, independent of specific technology.
8. **Tech stack** — concrete tools and libraries.
9. **Roadmap / implementation plan** — the order in which things get built.

Layers 1–6 are problem-space. Layers 7–9 are solution-space. The discipline is to finish thinking about *what* before deciding *how*.

### Concepts and vocabulary introduced

- **Domain-Driven Design (DDD)** — Eric Evans, 2003. The discipline of using the same vocabulary in conversations, code, and database. The shared vocabulary is the **ubiquitous language**.
- **Entity-relationship model (ERM)** — Peter Chen, 1976. The classical way of describing what the things in a system are and how they connect. Modern variant: **UML** (Unified Modelling Language) class diagrams.
- **Domain model vs. data model** — domain model is about concepts in the problem space; data model is about how they are stored. Look alike in small systems, diverge in large ones.
- **Bounded contexts** — DDD's name for the natural seams in a large domain. Doesn't apply at FlashFlow scale.
- **Spaced repetition system (SRS)** — category of learning software that schedules reviews at expanding intervals. Anki, SuperMemo are well-known examples.
- **Progressive Web App (PWA)** — a regular website with extra configuration that lets a phone treat it as an installed app: home-screen icon, full-screen, optionally offline-capable.
- **Artefact** — anything tangible the project produces other than the running software itself: documents, diagrams, configuration, test reports. Distinct from **build artefacts** (compiled outputs of source code).
- **Architecture Decision Record (ADR)** — Michael Nygard, ~2011. Short, dated, immutable note capturing why a significant architectural choice was made. Not needed at this scale; will matter at larger scale.
- **Conway's Law** — Melvin Conway, 1967. Systems mirror the communication structure of the organisations that build them.
- **Docs-as-code** — treating documentation as a first-class engineering artefact, version-controlled alongside source code. Mid-2010s shift; now the default.
- **Git** — distributed version-control system, Linus Torvalds 2005. Tracks changes to files over time. A command-line tool by nature.
- **GitHub** — hosting service for Git repositories, owned by Microsoft. Not the same as Git: Git is the tool, GitHub is the place. Competitors: GitLab, Bitbucket.
- **Working directory / local repository / remote repository** — the three places a Git project lives. Files flow between them via `git add`, `git commit`, `git push`, `git pull`.
- **Commit** — the atomic unit of Git history. Snapshot of staged changes with author, date, message, and unique identifier.
- **Homebrew** — package manager for macOS, ~2009. De-facto standard among Mac developers. Installs other tools via `brew install <name>`.

### How this changes at scale

The nine-layer sequence is the same on a one-person project and a thousand-person one. What changes:

- **Depth** — same shape, vastly more evidence underneath each layer.
- **Formality** — paragraph in markdown vs. signed-off corporate document.
- **People** — solo brain vs. specialised roles with handoffs.

What appears only at scale: stakeholder management, non-functional requirements as contractual obligations, ADRs, formal project management (agile, Scrum, Kanban, waterfall, SAFe — Scaled Agile Framework), DevOps machinery (CI/CD — continuous integration / continuous deployment, staging, feature flags, rollback), and organisational design as an architectural concern.

### Traps to remember

- **Cargo-culting enterprise process** — adopting heavyweight artefacts on small projects because they look professional. They aren't, at this scale.
- **Resisting useful structure** — refusing version control, vision documents, or domain sketches because they feel like overhead. On a solo project they are the minimum that lets you think clearly.
- **Heuristic** — every artefact should answer a question someone will actually ask. If no one will ask, don't write it. If future-you will ask it tomorrow, write it now.

---

## Project-specific decisions made (preliminary, subject to revision)

These came up during the conceptual work but have not yet been formalised as documents:

- **Six domain concepts** identified: Subject, Chapter, Card, Ladder Entry, Review Event, Schedule. With a likely merger of Review Event into Ladder Entry.
- **The ladder is the primary record**, not a derived field. Store the full ladder history per card; compute next-review-date from it. Never delete entries, even on demotion.
- **Three workflows**: daily review (the heart), authoring (occasional), maintenance (rare). V1 must nail the daily workflow.
- **Same-day re-attempts**: failed cards go to the bottom of today's stack, re-appear in same session. On successful re-attempt, the card is demoted by one rung.
- **One open question**: what happens if the same-day re-attempt itself fails? Three plausible behaviours, leaning toward "keep retrying same-day until it passes, demote once."
- **Out of v1 scope**: images, audio, statistics, tags, suspension, sharing, native mobile apps, multi-user, Excel import.

---

## Methodology decisions for how we work

- **Project context instruction in place** in Claude.ai (saved this session).
- **Periodic consolidation notes** as markdown files, numbered (`session-NN-progress.md`), at conceptual breakpoints not on a clock. Live in `docs/learning-journal/` once the repository exists.
- **Docs-as-code** — all documentation lives in the repository alongside the code, version-controlled together.
- **The user runs commands, the assistant explains** — no silently-done work.

---

## Where we got stuck

**Environment setup blocker.** Attempting to install Git on the iMac (macOS 26.0.1, "Tahoe") hit Apple's *"Die Software kann nicht installiert werden, da sie derzeit auf dem Softwareupdateserver nicht verfügbar ist"* error on three separate paths:

1. The `xcode-select` auto-installer triggered by running `git --version` for the first time.
2. The Homebrew installation script, which routes through the same Apple endpoint for the Command Line Tools dependency.
3. The Apple developer site direct-download fallback was unreachable (login problems, then catalogue dominated by 26.5 betas with no clear stable 26.x option visible).

This is an Apple-side infrastructure issue, not anything the user did. Hitting it on three different paths within a short window indicates a real outage.

A macOS point-release update (26.0.1 → 26.4.1) is available but was deferred — it might (no guarantee) refresh whatever's confusing Apple's catalogue endpoint, but a 30–90 minute OS update is too expensive to gamble on as a fix.

---

## Where we are now

- **GitHub account**: created. Profile name: Friedrich Neuhaus. Username not yet recorded — should be noted at start of next session.
- **iMac**: Terminal works. Git not installed. macOS 26.0.1.
- **Repository**: not yet created on GitHub or locally.
- **Local Git identity**: not yet configured.
- **SSH keys**: not yet set up.
- **Project context in Claude.ai**: saved this session.

Effectively: a GitHub account, an empty Mac, project context in place, no working Git in between.

---

## Next session — proposed pickup points

Two paths, in priority order:

### Path A — retry the environment setup
1. Try `git --version` in Terminal. If Apple's infrastructure has recovered, the install dialog should appear and work. (5–15 minute install.)
2. If still broken, fall back to manual download from the Apple developer site (`developer.apple.com/download/all/`), filtering for **"Command Line Tools for Xcode 26"** non-beta entries, highest stable version dated autumn 2025.
3. Once Git is installed: configure `user.name` and `user.email` (matching the GitHub email).
4. Set up SSH keys for GitHub authentication.
5. Create the `flashflow` repository on GitHub (private, no auto-init).
6. Initialise local repo, connect to remote, first commit, push.

### Path B — productive conceptual work without Git
Draft the missing top layers (markdown, no tooling required):

1. **Vision** — one-paragraph statement of why FlashFlow exists.
2. **Goals and non-goals** — explicit lists.
3. **Constraints** — already mostly stated; formalise them.
4. **Glossary** — the ubiquitous language for the project: Subject, Chapter, Card, Ladder, Pass, Fail, etc.

Once these exist as drafts, they go into the repository as the first content of the first commit when Git is finally working.

**Recommendation**: Path B is the better use of time during the Apple outage. Path A can be retried opportunistically — every few hours, run `git --version` and see if Apple has come back.

---

## Reflections on the session

- **The user pushed back twice on the assistant jumping ahead** — once when going from domain model straight to storage decisions, once when using "SRS" without expanding it. Both pushbacks were correct and led to better outcomes. The methodology instruction added to the project context should reduce this in future.
- **Setup work is failure-prone**, especially on first contact with a new machine. Roughly an hour of this session was spent fighting an Apple outage. This is normal. Experienced developers are not better at making setup work first try — they're better at recognising when to switch paths.
- **The conceptual work that did happen was solid** and produced a real shared understanding of the system. None of it is wasted.
- **The Software Craft pivot is a notable improvement** to the original brief. It tightens v1 (no Excel import) and creates a reinforcing loop between the system being built and the learning happening during the build.

---

*End of session 01 progress note.*
