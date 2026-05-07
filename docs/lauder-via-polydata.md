# Lauder via poly_data — Project Idea

*Status: candidate parallel learning project. Not committed. Decision deferred until MontereyDemo's path clarifies and bandwidth is clearer.*

This document captures the shape of a possible learning project: extracting and analysing the complete Polymarket transaction record for the November 2025 Leonard Lauder evening sale at Sotheby's New York, using the open-source `warproxxx/poly_data` pipeline as foundation infrastructure.

The project earns its place if and only if bandwidth supports it alongside MontereyDemo and WhiteGlove commissioner work. It's small enough to be additive rather than substitutive.

---

## Why this project

V35 names the November 2025 Leonard Lauder sale specifically as the demand-signal anchor for WhiteGlove: ~$1.4m wagered on Polymarket international across the lots, "spontaneously, without art world integration, without marketing, without community." V35 cites this as proof-of-behaviour that the institutional thesis depends on.

A serious analytical writeup of that signal — using complete transaction data, mapped accurately to the actual auction lots, with methodology that's verifiable — would be a credibility artefact for any V35-thesis investor or partner conversation. "Here's what the Polymarket Lauder data actually shows, with completeness verified against multiple independent sources" is more compelling than describing Lauder abstractly.

The project also produces transferable learning for WhiteGlove commissioning: what a complete prediction-market dataset looks like at the data-structure level, how prediction-market data is actually extracted and analysed, where the seams are between off-chain matching and on-chain settlement, what good documentation of a financially-committed dataset looks like.

---

## Foundation: warproxxx/poly_data

`github.com/warproxxx/poly_data` is an open-source, GPL-3.0-licensed Python pipeline for fetching, processing, and structuring Polymarket trading data. 1.7k stars, 340 forks, actively maintained.

Critically, the maintainer publishes a complete pre-extracted dataset as a downloadable archive (`orderFilled_complete.csv.xz`). This contains every Polymarket order-filled event from platform inception, already extracted from Goldsky's third-party subgraph and processed into structured trade records. Their framing: "save you over 2 days of initial data collection time."

The repo provides:
- A three-stage pipeline (markets → Goldsky subgraph events → processed trades)
- The pre-extracted complete dataset as starting state
- Resumable, incremental updates (run the pipeline to bring local copy current with whatever's been settled since the snapshot)
- Two example notebooks demonstrating analytical patterns (Trader Analysis, Backtest)
- Schema documented in the README

Implication for project scope: the infrastructure work isn't just smaller than direct Polygon chain reading — it's largely already done. The work shifts from "build extraction pipeline" to "do analysis using existing pipeline."

---

## Why not direct chain reading or commercial data

Earlier conversation established that several routes to a complete Lauder dataset exist:

| Approach | Time | Trade-off |
|---|---|---|
| Polymarket UI / proprietary API | Limited data | Selective by design; not complete |
| Telonex / PolymarketData.co commercial API | Hours of work | Paid subscription; tier-limited |
| Polymarket's own subgraph | 20-40h of project work | Depends on Polymarket's continued maintenance |
| Goldsky subgraph (independent indexer) | 20-40h | Independent from Polymarket; commercial provider |
| **warproxxx/poly_data (uses Goldsky)** | **25-65h total project** | **Open-source, complete, published dataset, validated by community** |
| Direct Polygon chain reading | 65-95h | Maximum independence; no external dependencies; substantial engineering |

The warproxxx/poly_data path is the right choice because:
- The completeness work is already done and validated by users beyond the maintainer (PendulumFlow's missing-data corrections accepted by the maintainer indicate the dataset is taken seriously)
- The time saved is real (25-65h vs 65-95h direct chain) and the saved hours go to the actually valuable work (analysis, domain mapping)
- The infrastructure dependency is acceptable (Goldsky is a commercial subgraph provider; the maintained dataset doesn't depend on Polymarket's own indexing)
- Spot validation against direct chain reads (5-8h) provides integrity confidence without rebuilding the full extraction pipeline

What the project gives up: deep crypto-substrate fluency. The Polygon chain interaction is touched only for validation. If the goal were "learn Polygon directly," this approach is the wrong one. The goal here is "produce a credible Lauder dataset and analysis efficiently."

---

## Project phases

### Phase 1 — Pipeline setup (4-6 hours)

- Install UV (Python package manager), sync dependencies
- Download the published data snapshot (`orderFilled_complete.csv.xz`)
- Run `update_all.py` to bring local copy current with any settled trades since snapshot
- Verify schema by inspecting markets.csv, orderFilled.csv, processed/trades.csv
- Familiarise with the maintainer's example notebooks

### Phase 2 — Lauder market identification (3-5 hours)

- Search markets.csv for "Lauder," "Sotheby's," related terms
- Cross-check against any recoverable Polymarket archived market URLs
- Cross-check with V35's references and contemporaneous press coverage
- End up with list of 6-12 condition_ids corresponding to Lauder lot markets
- Document the search methodology so the identification is reproducible

### Phase 3 — Lauder dataset extraction (2-4 hours)

- Filter trades.csv by market_id matching Lauder condition_ids
- Verify trade counts and aggregate volume roughly match V35's $1.4m reference
- Output cleaner per-Lauder-market dataset
- Schema design for the cleaner output (likely Parquet for size and query speed)

### Phase 4 — Lot mapping (8-12 hours)

The actually hard part. For each Lauder market, identify which specific Sotheby's lot it referenced.

- Sotheby's catalogue for the November 2025 sale is publicly archived
- For each market: read the question text, identify the lot it references (artist, work title, lot number)
- Cross-check market resolution criteria against catalogue lot data (estimate range, etc.)
- Record artist, title, lot number, low/mid/high estimate, actual hammer
- Build join table: market_id ↔ Sotheby's lot_id ↔ catalogue metadata ↔ hammer outcome

### Phase 5 — Validation (4-6 hours)

- Spot-check 10-15 random Lauder trades against direct Polygon chain queries
- Use ethers.js or web3.py to read the underlying transactions
- Confirm trade counts, prices, timestamps, maker/taker addresses match the warproxxx-derived data
- Document the validation method as part of the deliverable
- This is the single touchpoint with direct Polygon chain reading; valuable for integrity confidence

### Phase 6 — Analysis (10-20 hours, scope-dependent)

The analytical layer on top of clean data. Open scope; depth depends on bandwidth.

Lighter version (10-12 hours):
- Per market: time-series of implied probability, peak deviation, closing price, accuracy against actual hammer outcome
- Across markets: aggregate accuracy, where prediction signal worked and where it failed
- Basic visualizations: probability-over-time charts, accuracy histogram

Deeper version (15-20 hours):
- Trader segmentation (whale wallets vs retail wallets) to isolate signal sources
- Time-of-day and time-to-event patterns
- Correlation between lot characteristics (artist, estimate range, provenance) and prediction accuracy
- Comparison with V34/V35's institutional thesis predictions

### Phase 7 — Documentation and publication (4-8 hours)

- Methodology document (how the dataset was extracted, validated, mapped)
- Clean dataset published with schema
- Optional: short writeup of findings (blog post or PDF)
- Optional: GitHub repo publishing the Lauder-specific filtering and analysis code as a fork of warproxxx/poly_data

---

## Total scope

Three viable depth levels:

| Depth | Phases | Hours | Deliverable |
|---|---|---|---|
| Floor | 1-5 + minimal docs | 25-35 | Verified Lauder dataset, mapped to lots, validation documented |
| Mid | 1-6 with light analysis | 35-50 | Floor plus analytical writeup of demand signal |
| High | 1-7 with full publication | 45-65 | Mid plus methodology paper, public dataset, GitHub publication |

Floor produces real value (a clean public-good artefact at the data layer). Mid is what V35 would value as a credibility artefact. High maximises credentialing but takes time better spent elsewhere unless Lauder analysis becomes specifically commercially relevant.

---

## What this teaches

Honest about transferable learning:

- **What a complete prediction-market dataset looks like** at the data-structure level (high value for WhiteGlove commissioner work)
- **Using existing crypto data tooling** (Goldsky, subgraphs in general, Polymarket's data architecture)
- **Domain-mapped analysis of prediction-market data** — the V35 institutional thesis-aligned skill
- **Practical pandas/polars data engineering** at non-trivial scale (Lauder will be tens of thousands of rows)
- **Validation methodology** for financially-committed datasets

What it doesn't teach:
- Direct Polygon chain interaction (touched only for validation)
- Smart contract introspection at depth
- The CTF token model at the smart-contract level
- Wallet management, gas, transaction signing

If crypto-substrate fluency becomes a separate goal, that's a different project. This one is analytical, not infrastructure.

---

## Where this fits in the learning curve

The project is meaningfully smaller than MontereyDemo (25-65 hours vs 70-100) and has no operational dependencies (no friends to recruit, no student helper, no live auction-week operations). It can run alongside MontereyDemo and WhiteGlove commissioner work without crowding either out, *if* bandwidth supports it.

Three positioning options to be settled later:

**1. Replace MontereyDemo with this.** Cleaner operationally, smaller scope, tangible deliverable. Loses the producer-side experience but gains predictability and a V35-aligned credibility artefact.

**2. Add as complement to MontereyDemo.** Total ~115-170 hours of hands-on work in May-August. Real load on top of WhiteGlove work, but the two projects teach genuinely different things (producer-side vs analyst-side) and the dataset has independent value.

**3. Credible fallback.** Keep as candidate; commit only if MontereyDemo doesn't materialise (student helper hard to find, friend recruitment slow, scope concerns). Decision deferred to mid-May or early June.

The right answer depends on bandwidth assessment closer to the time. No commitment now.

---

## Where this lives

This document lives at `docs/lauder-via-polydata.md` for now — alongside the learning curve where the project's status will be revisited.

If the project gets committed to (decision point: late May / early June), the right home is its own GitHub repository. Likely a fork of `warproxxx/poly_data` with Lauder-specific filtering, mapping, and analysis code added. The repo's README would supersede this document and become the canonical project home. This document gets removed at that point.

For now: project idea, lives in FlashFlow's docs folder, accessible from both machines via the existing two-machine workflow, retrievable without setup overhead.

---

## Decision triggers

The project commits or doesn't commit at one of these moments:

- **Mid-May**: bandwidth assessment after Kalshi conversation and contractor selection are underway. If May commissioner-readiness work is on track and MontereyDemo recruitment is going well, decide whether to add this as a third parallel commitment.
- **Early June**: if MontereyDemo recruitment has stalled or scope concerns surface, this project becomes the natural fallback. Decide at that point whether to swap.
- **Late June or later**: if neither of the above resolves it, the project is effectively passed on for the November 2026 cycle. Could be revisited post-November as a Year 2 analytical exercise.

---

## What this document is not

This is a project idea, not a plan. The phases above are estimates, not commitments. Numbers and scope will sharpen if the project commits. The point of the document is to make the option clear and accessible — so that when the decision moment arrives, the option is well-understood and ready to act on, rather than re-derived from scratch under time pressure.
