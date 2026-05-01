# Learning Curve

*Status: drafted at end of session 03 of FlashFlow. A cross-project artefact; not part of FlashFlow's design sequence.*

This document captures a planned learning trajectory across multiple projects, designed to prepare the developer to commission a software project of WhiteGlove's scope and shape. It belongs at the repository root rather than nested under FlashFlow's documents because its scope extends beyond FlashFlow.

---

## Why this document exists

The developer is preparing to commission WhiteGlove — a financially-staked event-contract exchange for major art auctions. WhiteGlove will be built by a contracted software development team; the developer will not write the production code. The skills that matter, therefore, are commissioner skills:

- Understanding the problem domain in IT terms with vocabulary fluency
- Writing a project specification that contractors can build against
- Making an informed choice between candidate contractors
- Being a well-informed counterparty in technical discussions throughout the build
- Doing the most that can be done from the commissioner's position to assure delivery on time, on specification, and on budget

These are different skills from "build the product yourself." A commissioner needs breadth of vocabulary, recognition of architectural patterns, awareness of common contractor failure modes, and the texture of having lived through complete project lifecycles — but does not need production-grade implementation depth.

The curve below optimises for that distinction.

---

## Strategic constraints settled during curve design

Several decisions about WhiteGlove were settled during the curve-design conversation. They shape every project and study activity that follows.

**Substrate**: WhiteGlove launches on conventional banking rails — fiat-only, integrating with banks via ACH/SEPA. Crypto-native rails (USDC, smart contracts) are explicitly out of scope at launch, though the architecture should not preclude adding them later. The reference architecture for WhiteGlove's substrate is closer to Kalshi than to Polymarket.

**Mechanics**: WhiteGlove is an exchange — a marketplace where users trade contracts with each other — not a house that takes the other side of users' bets. The order-matching pattern is a Central Limit Order Book (CLOB), the standard for modern financial exchanges.

**Trading window**: WhiteGlove does not allow live trading during auctions. The market opens when the auction catalogue is published, closes before the auction begins, and settles when official auction results come in. This removes the entire class of real-time-trading concerns (WebSocket-driven order books, latency optimisation, conflict resolution between simultaneous bids during an event).

**Architecture posture**: WhiteGlove should be architected so that key external concerns (payment provider, identity provider, data sources) sit behind clean module boundaries. The full ports-and-adapters pattern is excessive for a single-substrate launch, but the discipline of "the accounting module knows nothing about which payment provider is in use" should be present from the start.

These constraints are project-level facts about WhiteGlove that the contractor brief should reflect. They simplify the system substantially compared to a generic "build a prediction market platform" specification.

---

## The curve

Five components, in order. Roughly four months calendar; 130-170 hours total.

### Component 1: FlashFlow finish (Phases 5-8)

**Hours**: ~30 remaining of 50-hour project budget.

**What it teaches**: Multi-service architecture (Phase 5's Python scheduler), test discipline (Phase 5's only-tests-required component), cross-service HTTP communication and its failure modes (Phase 6), form-based UI for editing and maintenance (Phase 7), the distinction between operational scripts and application code (Phase 8's CSV importer), Progressive Web App configuration (Phase 8).

**Why it earns its place**: half the FlashFlow budget remains; substantial vocabulary still to capture during Phases 5-8; the daily-use system that will reinforce all subsequent vocabulary through spaced repetition.

### Component 2: Reading bridge

**Hours**: 10-15.

**What's in it**:
- Steve McConnell, *Software Estimation: Demystifying the Black Art* (2006). Why software projects miss their estimates; how to read contractor estimates critically.
- Tom DeMarco and Tim Lister, *Peopleware: Productive Projects and Teams* (3rd edition, 2013). The human dynamics of software teams; why the cheapest contractor is often the most expensive.
- Optional: Frederick Brooks, *The Mythical Man-Month* (anniversary edition, 1995), chapters 1-3. Foundational vocabulary for any commissioner conversation.

**Why it earns its place**: covers the people-and-process dimension of software projects, which hands-on FlashFlow work cannot teach because there is no second party. Cheap, durable, and the vocabulary surfaces in real contractor conversations.

### Component 3: Comparative API study

**Hours**: 15-20.

**Activity**: Read the Kalshi and Polymarket public API documentation end-to-end. Produce a written comparison document structured by feature area: Series → Event → Market hierarchy, authentication, order book mechanics, order types, position tracking, settlement and dispute, funds in/out, profile/social, fees and incentives, operational concerns. For each: how Kalshi handles it, how Polymarket handles it, what WhiteGlove probably wants.

**Why it earns its place**: highest learning-value-per-hour activity in the curve. Reading well-designed production APIs in WhiteGlove's exact domain teaches more about commissioner-readiness than building a smaller approximation would. Produces a concrete artefact useful for actual contractor commissioning. Reading the documentation itself is implicit study of what good technical documentation looks like — a recognition skill that matters when evaluating contractors' deliverables.

The Kalshi study weighs more heavily than Polymarket's, since Kalshi's regulated-fiat-rail model is the reference architecture for WhiteGlove. Polymarket serves as comparison material and as background for the substrate question generally.

### Component 4: MontereyDemo

**Hours**: 60-90.

**Project shape**:
- 5-10 friends as participants (deliberately small — see scope discipline below)
- 3-6 trophy lots from the Monterey Car Auction in August
- 3 binary contracts per lot ("hammer ≥ low estimate" / "hammer ≥ mean" / "hammer ≥ high estimate"); 9-18 markets total
- Database-only play money — €100/$100 per friend, no payment-provider integration
- Manual real-money settlement at the end (developer wires/PayPals proceeds to charity per friend instructions)
- Authentication via Clerk or Auth0 (managed provider, not rolled own)
- TypeScript/Node + Fastify + PostgreSQL + Fly.io (same stack as FlashFlow)
- Clean accounting module with tested interface (a real module boundary, not full ports-and-adapters polymorphism)

**What it teaches**:
- Multi-user authentication via a managed provider
- Order-book matching engine in earnest
- Time-bounded markets (open / lockout / settle lifecycle)
- External event coupling with a real-world deadline
- Friend-as-real-user support dynamics
- Audit-trail discipline for money operations
- Production deployment under real-world pressure
- The accounting module as a teaching artefact

**Scope discipline**: the original idea was 24 friends. 5-10 is better for a learning project: friend 11-24 produces little marginal learning, and the user-support burden compounds meaningfully. Smaller participant cohort means more time spent observing system behaviour and less time spent troubleshooting account problems.

The temptation to make MontereyDemo an aspirational demonstrator (more lots, more friends, more contract types) should be resisted. The project is research, not product launch.

### Component 5: Post-MontereyDemo reflection

**Hours**: 8-12.

**Outputs**:
- Written post-mortem of MontereyDemo: what worked, what didn't, what surprised, what would be commissioned differently
- Updated comparative API document, annotated with "what MontereyDemo got right/wrong"
- Initial draft of WhiteGlove project specification

**Why it earns its place**: the post-mortem discipline is itself a commissioner skill. Most commercial software projects skip this and lose the learning. Doing it forces synthesis and converts experience into transferable insight. The WhiteGlove specification draft is the *output* of the entire curve — writing it forces discovery of what is not yet known and gives a concrete artefact to refine through contractor conversations later.

---

## Total budget

| Component | Hours | Calendar (rough) |
|---|---|---|
| FlashFlow finish | ~30 | Now → mid-May |
| Reading bridge | 10-15 | Mid-May → late May |
| Comparative API study | 15-20 | Late May → mid-June |
| MontereyDemo | 60-90 | Mid-June → Monterey week (mid-August) |
| Post-MontereyDemo reflection | 8-12 | Late August |
| **Total** | **125-167** | **~4 months** |

Roughly 8-12 hours per week consistently across the period. Real but sustainable; not punishing.

---

## Three follow-through items

These are real activities that should happen during the curve, scheduled deliberately rather than left to drift.

### 1. Seed deck pivot: add an Exchange Architecture chapter

FlashFlow's Software Craft seed deck currently has nine chapters. A tenth chapter — Exchange Architecture or Event-Contract Markets — should be populated during component 3 (comparative API study). Maybe 30-50 cards covering: CLOB, Series/Event/Market hierarchy, lifecycle states, KYC, settlement, dispute, fee tiers, market data primitives (open interest, volume, spread), and substrate-specific concerns.

This makes FlashFlow itself a daily-reinforcement tool for the most domain-specific vocabulary needed for MontereyDemo design and WhiteGlove commissioning.

### 2. Lawyer conversation about regulatory shape

Schedule for May or June. An hour or two of consultation with someone competent in the German/EU regulatory landscape for event-contract platforms. Two distinct questions to settle:
- What is the regulatory shape of MontereyDemo as planned (play money, charity-destined proceeds, friends-as-participants)?
- What is the regulatory shape of WhiteGlove proper at launch (real money, real users, EU/German base, regulated fiat rails)?

The answers constrain everything downstream. Knowing them before MontereyDemo design solidifies and well before WhiteGlove's contractor brief is written is high leverage.

### 3. Friend recruitment for MontereyDemo

A low-key conversation with 8-12 candidate friends in May or early June, gauging serious interest in participating. Better to discover non-participation now than mid-July when the project depends on their commitment.

---

## What this curve deliberately does not include

Worth being explicit about omissions:

- **No third stand-alone hands-on project (no TipStakes, no PredictBox).** The comparative API study replaces what such a project would have provided. At commissioner-readiness scale, the marginal learning from another small project is less than the marginal learning from professional reading and produced artefacts.

- **No deep dive into specific frontend frameworks.** FlashFlow uses EJS templates; MontereyDemo will too. Vocabulary fluency on React, Vue, Svelte trade-offs is enough at commissioner depth.

- **No deep dive into testing strategies beyond the scheduler tests.** Vocabulary on integration tests, end-to-end tests, property-based testing, mutation testing — at recognition level, not implementation level.

- **No DevOps/SRE depth.** Fly.io exposure plus Docker fundamentals from FlashFlow is enough. Kubernetes, Terraform, observability platforms — vocabulary level only.

- **No security depth beyond basics.** Auth via managed providers; secrets via environment variables; HTTPS everywhere. OWASP top 10, threat modelling, penetration testing, compliance frameworks — vocabulary level only.

These are real skills that production engineers need. As commissioner, vocabulary fluency in each is sufficient; implementation depth is not.

---

## Why this shape, not another

The curve is shorter and lighter on hands-on coding than the original sketch (which proposed FlashFlow → TipStakes → MontereyDemo). Two reasons for the change:

**The Kalshi and Polymarket APIs are better study material than any small project could be.** They are real systems built by serious teams, in WhiteGlove's exact domain, with publicly accessible documentation. Reading them produces vocabulary fluency and architectural recognition at the rate of professional reading rather than the rate of personal coding.

**The commissioner skill set is breadth-shaped, not depth-shaped.** Building TipStakes would have produced 50-70 hours of depth on a smaller version of one architectural pattern. The same time spent reading APIs, reading McConnell and DeMarco, and producing comparison artefacts produces broader recognition across more dimensions of what production software actually looks like. For someone who will not write WhiteGlove's code, the broader knowledge transfers better.

The trade-off accepted: less hands-on intuition for matching engines and order books specifically. The mitigation: MontereyDemo will exercise simplified versions of these directly.

---

## Updates to this document

This curve will refine as the work progresses. Particular candidates for revision:

- After the lawyer conversation, the regulatory framing of MontereyDemo and WhiteGlove may shift, with implications for both projects.
- After the comparative API study produces the comparison document, the MontereyDemo scope may sharpen further (some intended features may turn out to require infrastructure that is genuinely out of scope).
- After MontereyDemo runs, the post-mortem may reveal that further preparation work is needed before WhiteGlove begins — a fourth project, or extended reading, or additional informational interviews with contractor candidates.

This document is a plan, not a contract. Updates to this file should be considered explicitly rather than absorbed silently.
