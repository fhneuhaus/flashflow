# whiteglove/

Commissioner-preparation artefacts for the WhiteGlove project.

## What this folder is

WhiteGlove is a separate project from FlashFlow — a financially-staked event-contract platform for major art auctions, to be built by a contracted software team with the author serving as commissioner rather than developer. This folder holds learning materials, vocabulary, and reference documents specific to that project.

The subject matter is distinct from FlashFlow's: exchange architecture, prediction-market substrate, regulatory frameworks, the operational reality of platforms like Kalshi and Polymarket. The two domains are kept separate so that FlashFlow's own learning materials remain focused on software craft.

## What this folder is not

It is not WhiteGlove's source code. WhiteGlove will be built in its own repository (or repositories) by the contracted team when commissioning begins. This folder holds *preparation* — the reading, vocabulary, and analysis the commissioner does before and during that build.

It is also not authoritative project documentation. The canonical WhiteGlove concept document (V35 at the time of this folder's creation) lives in a separate Anthropic project. What lives here are derivative artefacts: vocabulary cards, comparative API study output when it happens, contractor brief drafts when they happen, learning-project documents like the Lauder analysis if it commits.

## Why it lives in the FlashFlow repo

For convenience of the existing two-machine sync workflow. The FlashFlow repo is already configured on both the iMac and MacBook with SSH keys and Git tracking. A separate repo would mean a second setup. A folder in this repo means the WhiteGlove preparation materials sync alongside FlashFlow's, with no additional infrastructure.

If WhiteGlove preparation eventually requires actual code (e.g., a fork of `warproxxx/poly_data` for the Lauder learning project, or commissioner-tooling), that gets its own repo at that point. This folder is for documents and CSVs, not running code.

## Current contents

- `vocabulary.csv` — atomic-card-format vocabulary entries on exchange architecture, prediction-market substrate, and related concepts. Same schema as FlashFlow's `software-craft-seed-cards.csv` for future SRS-system compatibility.

## Expected future contents

- Comparative API study output (Kalshi vs Polymarket) — May 2026 workstream
- Contractor brief drafts — late May 2026
- Lauder via poly_data project materials, if that project commits — June 2026 onwards
- Reference documents on specific WhiteGlove design decisions as they crystallise
