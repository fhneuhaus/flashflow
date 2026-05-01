# Learning Curve

*Status: revised end of session 03 of FlashFlow, after WhiteGlove timing constraint surfaced. Cross-project artefact; not part of FlashFlow's design sequence.*

This document captures a planned learning trajectory across multiple projects, designed to prepare the developer to commission a software project of WhiteGlove's scope and shape. It belongs at the repository root rather than nested under FlashFlow's documents because its scope extends beyond FlashFlow.

The original draft of this document assumed a patient, four-month timeline (May → August) ahead of WhiteGlove's contractor build beginning. After re-engaging with the WhiteGlove V34 concept, that timeline doesn't survive contact with the actual deadline. This revision reflects what the curve must look like given the real constraint.

---

## Why this document exists

The developer is preparing to commission WhiteGlove — a financially-staked event-contract exchange for major art auctions. WhiteGlove will be built by a contracted software development team; the developer will not write the production code. The skills that matter, therefore, are commissioner skills:

- Understanding the problem domain in IT terms with vocabulary fluency
- Writing a project specification that contractors can build against
- Making an informed choice between candidate contractors
- Being a well-informed counterparty in technical discussions throughout the build
- Doing the most that can be done from the commissioner's position to assure delivery on time, on specification, and on budget

These are different skills from "build the product yourself." A commissioner needs breadth of vocabulary, recognition of architectural patterns, awareness of common contractor failure modes, and the texture of having lived through complete project lifecycles — but does not need production-grade implementation depth.

---

## The November 2026 deadline

WhiteGlove must launch a working, regulated, real-money platform in time for the major NYC auction week in mid-November 2026. This is approximately six and a half months from now and is a make-or-break timing constraint for the startup's first-mover position. Working backwards:

- **Mid-November 2026**: live auction week, settlement
- **Late October 2026**: catalogue published, markets fully open with users staking
- **Mid October 2026**: soft launch, first users onboarded with funded accounts
- **Late September 2026**: code freeze, platform feature-complete in production
- **Early June 2026**: contractor team kicks off the build
- **End of May 2026**: contractor selection complete, brief delivered, agreements signed

This means **commissioner-readiness is needed by end of May 2026, not end of August.** The original learning curve had ~4 months of runway. The actual runway is ~4 weeks.

---

## Strategic constraints settled during curve design

Several decisions about WhiteGlove were settled in conversation. They shape every project and study activity that follows.

**Substrate**: WhiteGlove launches on conventional banking rails — fiat-only, integrating with banks via ACH/SEPA. Crypto-native rails (USDC, smart contracts) are explicitly out of scope at launch, though the architecture should not preclude adding them later. The reference architecture for WhiteGlove's substrate is closer to Kalshi than to Polymarket.

**Mechanics**: WhiteGlove is an exchange — a marketplace where users trade contracts with each other — not a house that takes the other side of users' bets. The order-matching pattern is a Central Limit Order Book (CLOB), the standard for modern financial exchanges.

**Trading window**: WhiteGlove does not allow live trading during auctions. The market opens when the auction catalogue is published, closes before the auction begins, and settles when official auction results come in. This removes the entire class of real-time-trading concerns (WebSocket-driven order books, latency optimisation, conflict resolution between simultaneous bids during an event).

**Architecture posture**: WhiteGlove should be architected so that key external concerns (payment provider, identity provider, data sources) sit behind clean module boundaries. The full ports-and-adapters pattern is excessive for a single-substrate launch, but the discipline of "the accounting module knows nothing about which payment provider is in use" should be present from the start.

**Build model**: WhiteGlove operates as Introducing Broker on Kalshi (or possibly Polymarket US once its track record matures) rather than as a standalone exchange. Matching engine, order book, custody, and clearing are the platform's responsibility. WhiteGlove is a specialised front-end and onboarding layer routing orders to regulated infrastructure. This dramatically reduces build complexity but does not change the November deadline.

These are project-level facts about WhiteGlove that the contractor brief reflects. They simplify the system substantially compared to a generic "build a prediction market platform" specification.

---

## The revised curve

Five components, condensed into May and June, with MontereyDemo running in parallel from June through August.

### Component 1: FlashFlow finish, scoped down

**Hours**: ~11 (down from ~30 in the original plan).

**Phases retained**:
- Phase 5: Scheduler design, Python implementation, tests, FastAPI wrapping (~5h)
- Phase 6: Pass/Fail flow, scheduler integration, daily-review experience (~6h)

**Phases deferred indefinitely** (to v1.5 if and when):
- Phase 7: Edit + maintenance flows
- Phase 8: CSV import + PWA + polish

**Why this scoping**: Phase 5 still teaches multi-service architecture, test discipline, cross-service HTTP — patterns directly relevant to recognising contractor proposals for WhiteGlove. Phase 6 is the daily-review experience; valuable for the system as system, but lower commissioner-preparation value. Phases 7 and 8 are CRUD-shaped and polish work with diminishing marginal learning value. With the November deadline, the time saved is better spent elsewhere.

### Component 2: Reading bridge

**Hours**: 10-15.

**Schedule**: parallel through May, not sequenced after FlashFlow.

**What's in it**:
- Steve McConnell, *Software Estimation: Demystifying the Black Art* (2006). Why software projects miss their estimates; how to read contractor estimates critically. Particularly relevant when evaluating WhiteGlove contractor bids in May-June.
- Tom DeMarco and Tim Lister, *Peopleware: Productive Projects and Teams* (3rd edition, 2013). The human dynamics of software teams; why the cheapest contractor is often the most expensive.
- Optional: Frederick Brooks, *The Mythical Man-Month* (anniversary edition, 1995), chapters 1-3. Foundational vocabulary for any commissioner conversation.

**Why it earns its place**: covers the people-and-process dimension of software projects, which hands-on FlashFlow work cannot teach because there is no second party. Cheap, durable, and the vocabulary surfaces in real contractor conversations starting now, not in August.

### Component 3: Comparative API study

**Hours**: 15-20.

**Schedule**: May, urgent.

**Activity**: Read the Kalshi and Polymarket public API documentation end-to-end. Produce a written comparison document structured by feature area: Series → Event → Market hierarchy, authentication, order book mechanics, order types, position tracking, settlement and dispute, funds in/out, profile/social, fees and incentives, operational concerns. For each: how Kalshi handles it, how Polymarket handles it, what WhiteGlove probably wants.

The Kalshi study weighs more heavily than Polymarket's. Kalshi's regulated-fiat-rail model is the reference architecture for WhiteGlove's launch. Polymarket US (QCEX) is also CFTC-regulated as of December 2025 but has under one year of operating track record versus Kalshi's four years. For institutional credibility at launch, Kalshi is the safer first partner. Polymarket as a Year 2-3 multi-platform play remains the right architecture per V34.

**Why it earns its place**: highest learning-value-per-hour activity in the curve. Reading well-designed production APIs in WhiteGlove's exact domain teaches more about commissioner-readiness than building a smaller approximation would. Produces a concrete artefact useful for actual contractor commissioning. Reading the documentation itself is implicit study of what good technical documentation looks like — a recognition skill that matters when evaluating contractors' deliverables.

### Component 4: WhiteGlove contractor brief

**Hours**: 15-20.

**Schedule**: late May.

**Activity**: Translate the V34 concept document into a contractor-readable build brief. This is not original conceptual work — most of the substance already exists. It is the discipline of converting an internal strategic document into something a contractor team can build against, with explicit scope, non-goals, architectural constraints, named dependencies, milestones, and acceptance criteria.

Draws on the same nine-layer design discipline used for FlashFlow but adjusted for the realities of commissioning external work: the contractor brief is the primary artefact through which the commissioner controls the project. Writing it well is the highest-leverage commissioner activity in the entire trajectory.

### Component 5: MontereyDemo as parallel learning project

**Hours**: 70-100 of developer time, June through August. Plus 25-40 hours of student help. Plus ongoing user support during the live period.

**Cash budget**: €3.6-4.3k total (€2,400 friend stakes + €700-1,200 student fees + €200-400 hosting/services + small contingency).

**Project shape**:
- 24 friends as participants — *not* fewer
- 3-6 trophy lots from the Monterey Car Auction in mid-August
- 9-18 binary contracts on hammer thresholds (low / mean / high estimates)
- Database-only play money, €100/$100 per friend
- Manual real-money settlement at the end (developer wires/PayPals proceeds to charity per friend instructions)
- Authentication via Clerk or Auth0 (managed provider, not rolled own)
- TypeScript/Node + Fastify + PostgreSQL + Fly.io (same stack as FlashFlow)
- Clean accounting module with tested interface

**Why 24 friends, not 5**: a prediction exchange has a minimum viable liquidity threshold below which the matching mechanism stops functioning. With 3-5 users on a binary contract, no counterparties exist, the order book stays empty, no trades happen. Reducing user count to save support effort breaks the thing being prototyped — it's not a small version of the real thing, it's a non-functioning version. Liquidity is the product. The marginal user-support cost from 5 → 24 friends is real but small (10-15 additional hours). The marginal liquidity benefit is the difference between "no market" and "real market." Those are not commensurate quantities.

**The student's role**: the developer does the design and development work — MontereyDemo is *his* learning project, not a small commissioning exercise. The student is a second pair of hands for tasks where Claude can't reach: configuring infrastructure that benefits from a second person on the actual machine, operations support during the auction week, pair-programming on specific tricky bits, helping with friend onboarding during the live period. The student is a tool, not a contractor.

**What MontereyDemo teaches** (the guiding hope):
- Lived experience of the open → close → settle lifecycle on a real external event
- The specific texture of "something broke at the worst possible moment" in a market context
- Pattern recognition for what bugs in market software look like (off-by-one in position tracking, settlement that double-pays, race condition between order match and balance update)
- Operational realism: what user support looks like when real money is involved
- Worked example of architectural decisions to share with the WhiteGlove contractor team
- Trust dynamic with friends who put €100 into something the developer built

**What the hope might disappoint**:
- The architectural decisions in MontereyDemo are made at toy scale and may not generalise. WhiteGlove's order book has institutional participants with sophisticated needs, KYC, AML, position limits, regulatory audit trails. MontereyDemo's order book is a database table.
- The most important commissioning skills are not exercised by building MontereyDemo. They are exercised by *commissioning* WhiteGlove.

**Tier structure with stop-loss**: MontereyDemo is defined in three tiers, each independently shippable. If the WhiteGlove contractor build hits trouble in July or August, MontereyDemo stops at whatever tier is currently working. No heroics.

- **Tier 1 — minimum viable**: users register, get €100 play money, submit single-shot predictions on lots, system records, manual settlement after auction, charity payout calculated. No order book, no live trading. ~30-40 hours.
- **Tier 2 — order book**: users place limit orders to buy/sell binary contracts, simple matching engine, position tracking. The actual exchange mechanic. Adds ~25-35 hours.
- **Tier 3 — polish**: decent UI, leaderboard, audit trail, automated settlement, admin dashboard. Adds ~15-25 hours.

Pre-committing the cut makes the moment easier when it comes. Same discipline as FlashFlow's PWA fallback rule.

**Why this earns its place under the November deadline**: as parallel work to WhiteGlove contractor management, not preparation before it. The learning that previously would have come *before* commissioning now comes *alongside* it. Closeness to a working market through the auction week of a real event provides operational intuition that pure observation of contractors building WhiteGlove will not produce.

---

## Total budget

| Component | Hours | Calendar |
|---|---|---|
| FlashFlow Phase 5+6 | ~11 | Early-mid May |
| Reading bridge (parallel) | 10-15 | May |
| Comparative API study | 15-20 | May (urgent) |
| WhiteGlove contractor brief | 15-20 | Late May |
| MontereyDemo (developer time) | 70-100 | June - August |
| **Total developer hours** | **120-165** | **~4 months** |
| Plus student fees | €700-1,200 | June - August |
| Plus MontereyDemo cash | €2,400 + €200-400 hosting | August |

This compresses to **15-25 hours per week through May and into June**, dropping to a more sustainable rate once WhiteGlove contractor selection is complete and the build phase begins. Real but not impossible.

---

## The immediate workstream — May 2026

In rough order of urgency:

1. **Initiate the Kalshi conversation** about Introducing Broker terms. Longest-lead item in the entire chain. This week or next.

2. **Lawyer conversation** about regulatory shape of WhiteGlove launch (state-level analysis, dual-interface CFTC opinion scope). Two hours. This week or next.

3. **Comparative API study** — Kalshi-focused, Polymarket as comparison. Mid-May.

4. **Reading bridge** in parallel through May.

5. **WhiteGlove contractor brief** drafted late May.

6. **Contractor selection** — 3-5 candidate firms, structured RFP-style conversation, decision by early June.

7. **FlashFlow Phase 5+6** fitted around all of the above. Probably 1-2 dedicated sessions.

8. **MontereyDemo Tier 1 begins** in early June, coexisting with WhiteGlove contractor handoff.

9. **Find student helper** in May or early June. Realistic posting routes: TU Berlin or HU Berlin computer science department bulletin boards, Werkstudent-style ads, LinkedIn. Need someone who can work 10-15 hours a week through summer with TypeScript / Node / SQL fluency.

10. **Friend recruitment for MontereyDemo** in May and early June. Low-key conversations with 24+ candidate friends to gauge serious interest before the project depends on their commitment.

---

## Three follow-through items, still locked

These are real activities that should happen during the curve, scheduled deliberately rather than left to drift. None has changed in priority despite the November deadline.

### 1. Seed deck pivot: Exchange Architecture chapter

FlashFlow's Software Craft seed deck currently has ten chapters. The Exchange Architecture chapter (added at end of session 03) is populated during the comparative API study with cards on CLOB, Series → Event → Market hierarchy, lifecycle states, KYC, settlement, dispute, fee tiers, market data primitives, and substrate-specific concerns. Maybe 30-50 cards by end of June.

This makes FlashFlow itself a daily-reinforcement tool for the most domain-specific vocabulary needed for MontereyDemo design and WhiteGlove commissioning.

### 2. Lawyer conversation about regulatory shape

Now scheduled for May rather than May-June. An hour or two of consultation about:
- Regulatory shape of MontereyDemo as planned (play money, charity-destined proceeds, friends-as-participants — likely fine, worth confirming)
- Regulatory shape of WhiteGlove proper at launch (real money, real users, US base via Kalshi as IB, state-level enforcement landscape)

The answers constrain everything downstream. Knowing them before MontereyDemo design solidifies and well before WhiteGlove's contractor brief is finalised is high leverage.

### 3. Friend recruitment for MontereyDemo

Low-key conversations with 24+ candidate friends in May and early June. Better to discover non-participation now than mid-July when the project depends on their commitment. The 24-friend target is a hard floor, not aspirational — the market mechanism requires it.

---

## What the curve deliberately does not include

Worth being explicit about omissions:

- **No third stand-alone hands-on project beyond MontereyDemo (no TipStakes, no PredictBox)**. The comparative API study replaces what such a project would have provided.

- **No deep dive into specific frontend frameworks**. FlashFlow uses EJS templates; MontereyDemo will too. Vocabulary fluency on React, Vue, Svelte trade-offs is enough at commissioner depth.

- **No deep dive into testing strategies beyond the scheduler tests**. Vocabulary on integration tests, end-to-end tests, property-based testing, mutation testing — at recognition level, not implementation level.

- **No DevOps/SRE depth**. Fly.io exposure plus Docker fundamentals from FlashFlow is enough. Kubernetes, Terraform, observability platforms — vocabulary level only.

- **No security depth beyond basics**. Auth via managed providers; secrets via environment variables; HTTPS everywhere. OWASP top 10, threat modelling, penetration testing, compliance frameworks — vocabulary level only.

These are real skills that production engineers need. As commissioner, vocabulary fluency in each is sufficient; implementation depth is not.

---

## Why this shape, not another

The curve is shorter and more time-pressured than the original draft. Three reasons for the change:

**The Kalshi and Polymarket APIs are better study material than any small project could be.** They are real systems built by serious teams, in WhiteGlove's exact domain, with publicly accessible documentation. Reading them produces vocabulary fluency and architectural recognition at the rate of professional reading rather than the rate of personal coding.

**The commissioner skill set is breadth-shaped, not depth-shaped.** Building a third standalone project would have produced more depth on a smaller version of one architectural pattern. The same time spent reading APIs, reading McConnell and DeMarco, and producing comparison artefacts produces broader recognition across more dimensions of what production software actually looks like.

**The November deadline collapses the runway.** The original curve assumed a four-month preparation window before WhiteGlove began. The actual window is four weeks. What survives is reading and study — hands-on learning loses its time slot before commissioning begins. MontereyDemo runs *in parallel* with the contractor build, not before it.

The trade-off accepted: less hands-on intuition for matching engines and order books specifically, with MontereyDemo as the single concentrated hands-on learning project rather than one of two or three.

---

## Updates to this document

This curve will refine as the work progresses. Particular candidates for revision:

- After the Kalshi conversation, the platform commercial terms may shape the WhiteGlove contractor brief and the architecture in ways currently unknown.
- After the lawyer conversation, the regulatory framing of MontereyDemo and WhiteGlove may shift, with implications for both projects.
- After the comparative API study produces the comparison document, the WhiteGlove contractor brief may sharpen further.
- After contractor selection, the actual quality and pace of the contracted team may change MontereyDemo's role — either making it more important (if the contractor team is junior or needs detailed input) or less important (if the team is senior and runs autonomously).
- After MontereyDemo runs in August, the post-mortem may reveal patterns directly applicable to the WhiteGlove November launch.

This document is a plan, not a contract. Updates to this file should be considered explicitly rather than absorbed silently.
