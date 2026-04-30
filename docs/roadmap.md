# FlashFlow — Roadmap

*Layer 9 of the design sequence. Status: accepted, session 02 (evening).*

## Purpose

This document sequences the remaining work of the FlashFlow v1 build:
what gets built, in what order, with what time budget. It is the
bridge between design (Layers 1–8) and code.

It is *not* a Gantt chart, a commitment, or a project-management
artefact in any formal sense. It is an honest plan: this is what is
expected to happen between now and a working v1, in roughly this
order, taking roughly this long.

The roadmap exists to make the next decisions tractable. When the
next session opens, the roadmap tells you what to start on without
re-deriving the logic.

## Time budget remaining

Of the 50-hour project budget, ~38 hours remain. Sessions 01 and 02
together consumed ~12 hours: setup, environment, all nine design
layers, two-machine workflow proven, deployment-related groundwork
(domain registered, DNS configured).

## The phases

Eight phases, sequenced by the principle of front-loading risk —
discovering hard problems early enough to absorb them.

| # | Phase | Hours |
|---|---|---|
| 1 | Scaffolding: project structure, dependencies, hello-world locally | 3 |
| 2 | First deployment: hello-world on Fly.io at flashflow.whiteglove.exchange | 4 |
| 3 | Database setup: schema, migrations, basic queries working locally and in production | 4 |
| 4 | Walking skeleton: list cards, show one card, render the ladder, all wired through | 4 |
| 5 | Scheduler design (`docs/scheduler.md`) + algorithm implementation in Python with tests | 5 |
| 6 | Pass/Fail flow + scheduler integration: the daily-review workflow working end-to-end | 6 |
| 7 | Edit-during-review + maintenance flows | 5 |
| 8 | CSV import script (Python) + PWA configuration + polish | 6 |
|   | **Subtotal** | **37** |
|   | Buffer for unexpected friction | 1 |
|   | **Total** | **38** |

The buffer is tight. Named contingency below.

## Why this order

### Phases 1–2: front-load the deployment risk

Deployment is the riskiest unknown. Fly.io's CLI, two-service
deployment, custom-domain configuration, environment variables, the
deploy-from-Git pipeline — none of it has been exercised yet, and
each piece has its own first-time friction.

Doing deployment with only a hello-world (no real application code)
isolates the failure modes. When something breaks, it is *deployment*
that broke, not the application logic. By the time real features are
being built, the deployment chain is proven.

End state of Phase 2: `https://flashflow.whiteglove.exchange` returns
a placeholder page from a real Fastify app deployed on Fly.io,
accessible from the iPhone.

### Phase 3: front-load the database risk

The second risky unknown. Connecting Node.js to PostgreSQL, getting
Kysely's types working, separating local-development from production
databases, learning Fly's managed-PostgreSQL workflow — all
first-time work. Better to hit it in isolation than tangled with
application logic.

End state: schema for the five entities (Subject, Chapter, Card,
Ladder, Ladder Entry) exists in both local and production
PostgreSQL; basic queries through Kysely work in both.

### Phase 4: walking skeleton — the all-layer-encompassing hello-world

The vertical slice that touches every layer of the architecture:
browser → Fastify → Kysely → PostgreSQL → Kysely → Fastify → browser.
The features it implements are trivial — list a few cards, show one
card with its ladder rendered. The data flow is real.

This is the most important phase psychologically. Until the walking
skeleton works, every feature attempt hits the unconnected-layers
problem. After it works, every subsequent feature is *adding to* the
proven pattern.

End state: opening the deployed URL on any device shows a list of
cards from the database, each clickable to a detail view that shows
question, answer, and the ladder.

### Phase 5: the scheduler — Python, with tests

The scheduler is FlashFlow's algorithmic core. Its design has been
named throughout the architecture and tech-stack documents but its
*algorithm* — the doubling progression, the demotion rule, the
day-boundary computation, timezone handling — is still undocumented.

Phase 5 covers all of it:

- **`docs/scheduler.md`** — the design document specifying the
  algorithm. Sized like the other layer documents. Probably 45
  minutes.
- **Python implementation** — the algorithm itself, written as pure
  functions. Probably 2 hours.
- **Tests** — required by `goals.md` for this component specifically.
  Probably 1.5 hours.
- **FastAPI wrapping** — exposing the algorithm over HTTP for the
  Node.js application server to call. Probably 45 minutes.

This is also the first real Python work of the project. The phase
deliberately encompasses both the design and the implementation
because they are tightly coupled — the algorithm document and the
algorithm code are written nearly together, each refining the other.

End state: a Python service deployable on Fly.io that exposes
`/next-interval`, `/stack`, and a few related endpoints, with a tested
implementation of the spaced-repetition algorithm.

### Phase 6: Pass/Fail flow — the design centre

`goals.md` is explicit: *"the daily review is the design centre — it
must feel frictionless even if other workflows are slightly clunky."*
Phase 6 builds it.

This is also the first phase where the Node.js side and the Python
side communicate over HTTP. The cross-service connection has its own
first-time friction (URL configuration, error-propagation, network
timeouts) and Phase 6 is where those surface.

End state: a working daily-review experience — open the app, see
today's stack count, review cards one at a time, Pass or Fail each,
end on the appropriate "Done" message.

### Phase 7: editing and maintenance — the supporting cast

Edit-during-review (the one-tap edit affordance from the review
screen) and the maintenance workflows (edit outside review, move
cards between chapters, delete cards, rename or delete chapters and
subjects).

These are CRUD-shaped UI work — variations on patterns established in
Phases 4 and 6. Less risky than what came before; absorbs time
pressure better if earlier phases overran.

End state: every workflow listed in `workflows.md` is operational,
including all the maintenance affordances.

### Phase 8: CSV import + PWA + polish

The final phase covers three loosely related items:

- **CSV import script** (Python). Reads the seed-cards CSV, creates
  chapters as needed, inserts cards with `Initial` ladder entries.
  Run from the terminal. Operational code, not application code.
- **PWA configuration**. Web app manifest and minimal service worker
  to enable "Add to Home Screen" on the iPhone. The app already
  works in mobile Safari without this; the configuration upgrades
  it to a phone-installable experience.
- **Polish**. Whatever rough edges have accumulated — visual
  refinement, error-message wording, edge-case handling. Bounded by
  the time remaining.

End state: v1 complete and in real daily use.

## Contingency: if the buffer runs out

The buffer is one hour. Any meaningful overrun before Phase 8 will
deplete it. The named contingency:

**If behind by Phase 5–6, drop PWA configuration from v1.**

The app will still work on the iPhone via mobile Safari — it just
won't have the install-to-home-screen affordance. This is a real but
absorbable degradation; the phone access works, the daily review
flow works, the app is usable. The PWA upgrade becomes a small v1.5
addition once v1 is in real use.

This contingency is named now, not improvised later, because the
moment of "we're behind" is also the moment when discipline breaks
down most easily. Pre-committing the cut means the decision is
already made when the time comes.

Other contingencies that are *not* options:

- The scheduler is not negotiable. It is the design centre and is
  required to have tests per `goals.md`.
- Edit-during-review is not negotiable. It is an explicit `goals.md`
  goal, and one of the design choices that distinguishes FlashFlow
  from off-the-shelf flashcard apps.
- Deployment is not negotiable. v1 by definition runs at a real URL.

## What this document does not specify

- **Specific code structure** — folder layout, module boundaries,
  file naming. These emerge during scaffolding rather than being
  predetermined.
- **Per-phase entry/exit criteria** — at this scale, the "what does
  done mean?" for each phase is defined informally as "the end state
  described above is reached." Formal criteria are theatre at solo
  scale.
- **Day-by-day sequencing** — the phases are sized in hours, not
  days. They will distribute across however many sessions and
  calendar days the work actually takes.
- **What happens after v1** — v2 work is captured in `backlog.md`.
  Sequencing of v2 items is a future-version roadmap problem.
