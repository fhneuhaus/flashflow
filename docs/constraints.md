# FlashFlow — Constraints

*Status: accepted · Date: 2026-04-29 (revised)*

This document captures the constraints under which FlashFlow v1 is built. Constraints are facts about the world, not choices the project makes — they cannot be met or unmet, only respected or violated. They shape every other decision. If a constraint changes (more time, more devices, more users), the project pauses and re-plans rather than absorbing the change silently.

The line between *constraint* and *goal*: a goal is something the system must *do* (could fail to). A constraint is a fact the system must *live within* (could be violated).

Constraints are organised into three families:

- **Process constraints** — facts about *how the work happens*: time, people, methodology, tools used to build.
- **Product constraints** — facts about *what the product must run on or fit within*: devices, networks, user context.
- **Business constraints** — facts about the commercial or organisational context: budget, deadlines, contracts, regulation.

The three families have different consequences. Process constraints affect scheduling and risk. Product constraints shape the architecture itself. Business constraints typically cannot be changed by the team and must be negotiated externally.

---

## Process constraints

### Time

- **50 hours total**, across roughly one calendar week. Includes design, coding, testing, deployment, documentation, and the inevitable environment-setup friction.
- Hours are real working hours, not elapsed wall time. Sessions of 1–4 hours are realistic; ten-hour days are not.

### People

- **One developer, one user, one stakeholder. All three are the same person.**
- No code review, no pair programming, no design review by anyone else.
- All decisions made in conversation between the developer and an AI assistant. The AI explains, proposes, reviews, debugs; the developer runs commands, edits files, and makes final choices.

### Skill level

- The developer is **new to software engineering as a discipline**. Capable in their own field; familiar with Excel macros and the conceptual shape of code; not yet fluent in the tooling, vocabulary, or conventions of modern software development.
- Methodology accordingly favours plain, widely-used tools over clever or niche ones. The point is to see and understand the wires.
- The developer is also a **deeply experienced subject-matter expert** for the system being built — over ten years of daily use of the paper original. Domain instincts are data, not opinion. When they contradict naive software-developer reasoning, the reasoning is the thing that's wrong.

### Relationship to the WhiteGlove project

- **FlashFlow is a learning vehicle preparing for the WhiteGlove project**, a separate and larger build (a financially-staked prediction platform for major art auctions). WhiteGlove is multi-year, public-facing, regulated-adjacent, and runs a TypeScript/Node.js application backend with Python carved out for analytics and the pricing model.
- Technology choices for FlashFlow should **mirror WhiteGlove's likely stack** so that the skills built here transfer directly. Specifically: JavaScript/Node.js for the application backend; Python for any algorithmic or data-processing work that has an analytical character.
- This is a constraint, not a goal: it shapes what we choose, but FlashFlow itself does not need to *meet* WhiteGlove's requirements (different scale, different audience, different regulatory context).

### Tooling and ecosystem

- **GitHub** is the remote repository host. Username `fhneuhaus`, repository `flashflow`.
- Development happens on macOS using Terminal, a text editor (VS Code), and Git on the command line.
- Languages biased toward those that transfer to WhiteGlove: JavaScript/Node.js for application code, Python for analytical or scripting code (such as the CSV import script).

### AI assistance

- **Heavy use of AI assistance is part of the working context.** Every session involves AI as a working partner. The discipline is to use AI without short-circuiting understanding; the test is whether the developer can explain what was built and why.

---

## Product constraints

### Devices

- **iMac** (macOS 26.4.1, primary development machine).
- **MacBook** (secondary development and daily-use machine).
- **iPhone** (review-only target; no development happens here).

### Connectivity

- **Internet connectivity is assumed at review time.** This is a fact about how the system will be used: at desks, on couches, in cafés — not on planes or in tunnels.

### User attention

- **Realistic daily session budget is 15–30 minutes** for review, with longer sessions on weekends. Designs that assume sustained 60-minute review sessions will be unused.
- Cards are reviewed across pockets of time during the day, not in one block.

### Card intake rate

- **There is a sustainable upper bound on how many new cards can be added per day** before the daily review burden exceeds the time budget.
- Each new card produces roughly 8–10 reviews over its lifetime, front-loaded into the first month (1-day, 3-day, 7-day, 14-day rungs all hit early).
- With a 15–30 minute daily review budget and ~15 seconds per review, the realistic ceiling is **somewhere in the range of 10–20 new cards per day in steady state**.
- This is independent of how fast cards can be authored or imported. The bottleneck is the user's review capacity, not the production capacity.
- Bursts of 24+ cards are tolerable occasionally (e.g. seeding a new subject) but not as a sustained rate.

---

## Business constraints

**None currently apply.** FlashFlow is a personal learning project with no commercial dimension, no external deadlines, no contractual obligations, and no regulatory exposure beyond ordinary internet hygiene.

This section exists deliberately rather than being omitted: making the absence explicit confirms that the question was considered. If FlashFlow ever crossed into a context with real business constraints (multi-user, paid hosting, shared with others, handling someone else's data), this section would need to be revisited before further work.

---

## What is *not* a constraint

A few things people might assume are constraints but are not:

- **No budget constraint.** Hosting costs for a single-user web app are well under €10/month on any reasonable platform; we are not optimising for cost.
- **No performance constraint.** With one user, response times under a few seconds are entirely acceptable. We are not optimising for scale.
- **No regulatory or compliance constraint.** No personal data of others, no payments, no health information. Standard hygiene (don't commit secrets, use HTTPS) applies; nothing more elaborate.
- **No legacy code constraint.** This is a new build; there is no existing codebase to be compatible with.

---

## Notes

**The "user attention" and "card intake rate" constraints together form the dominant fact shaping the daily review experience.** Frictionless, fast, calm — those are the design implications of the attention budget. Disciplined intake — adding cards at a rate the system can metabolise — is the design implication of the intake-rate ceiling. Violating either compounds into abandonment of the system.

**The "skill level" constraint is unusual to state explicitly** but earns its place. It justifies downstream choices that might otherwise look conservative: SQLite over a heavier database, Express over Django, plain HTML/CSS over a frontend framework. The wires stay visible. A team of seasoned engineers would make different trade-offs; we are deliberately not that team.

**The "domain expertise" half of the skill constraint is also unusual but earns its place.** The developer is new to *software*, but very experienced with the *system being built*. This is the rare configuration in which Domain-Driven Design's ubiquitous language is achieved by construction — the domain expert and the developer are the same person. The implication for working method: when the developer's instinct about the system contradicts a draft design, pause and write down what the instinct implies before continuing.

**The "AI assistance" constraint is also an honest description of how this work happens.** Pretending otherwise would produce a project document that doesn't match the project. Naming it allows the design to anticipate it — for example, by producing artefacts that an AI-assisted workflow can readily resume from (which is exactly what the session-progress notes do).

**The "WhiteGlove" constraint changes the technology bias.** Earlier in the design process, before this constraint was articulated, the preliminary lean was toward Python for the FlashFlow backend (gentler syntax, simpler frameworks, pleasant for the scheduler logic). Once WhiteGlove's profile was understood, the lean shifted to JavaScript/Node.js — because skills transferable to WhiteGlove's application backend matter more than marginal pleasantness on FlashFlow itself. Python remains relevant: for the CSV import script, and as a learning second language for any future analytical work that mirrors WhiteGlove's pricing-model service.
