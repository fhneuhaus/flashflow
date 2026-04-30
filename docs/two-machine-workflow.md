# Working Instructions for AI Assistant: Two-Machine FlashFlow Development

*The user develops FlashFlow on two machines: an iMac (primary) and a MacBook Air (secondary). Both must remain functional development environments. This document captures the disciplines that keep them in sync without surprises.*

## The fundamental asymmetries

Differences between the two machines that matter:

- **Username**: iMac is `fn`; MacBook is `user`. This is a real divergence baked into PostgreSQL: each machine's local Postgres has a superuser matching its macOS username. A `DATABASE_URL` valid on one machine is invalid on the other.
- **Hardware/architecture**: iMac (Intel) and MacBook (Apple Silicon, `darwin/arm64`). Mostly invisible to JavaScript but matters for some native binaries.
- **Filesystem layout**: both repos live at `~/Projects/flashflow`. Same path. Same shape. Different `node_modules/` (each machine builds its own).

## Files that travel with the project (in Git)

Everything in `~/Projects/flashflow` *except* the gitignored items. Specifically committed and shared:

- All `docs/` files
- `app/package.json`, `app/package-lock.json`
- `app/tsconfig.json`
- `app/Dockerfile`, `app/.dockerignore`
- `app/fly.toml`
- `app/.gitignore`, `app/.env.example`
- `app/src/**`, `app/migrations/**`

## Files that stay local to each machine (gitignored)

- `app/node_modules/` — each machine builds its own with `npm install`
- `app/dist/` — TypeScript build output, regenerated locally
- `app/.env` — environment variables, **must contain machine-specific values**

## State that lives outside the repo

These are not in Git and not synchronised between machines automatically:

- **Local PostgreSQL database `flashflow_dev`** — each machine has its own. Schema is kept in sync via migrations; data is not synchronised.
- **Homebrew-installed tools** (Node, PostgreSQL, flyctl, etc.) — each machine installs its own.
- **Authentication tokens**: each machine's flyctl is independently authenticated against the same Fly account.
- **VS Code settings, terminal preferences, shell aliases** — diverge freely.

## Discipline at session start

The opening move on whichever machine the user is on:

```
cd ~/Projects/flashflow
git pull
```

If the pull brings down anything new, also run:

```
cd ~/Projects/flashflow/app
npm install
```

`git pull` updates `package.json`. `npm install` actualises that into `node_modules/`. Both are needed; one isn't a substitute for the other.

If the pull brings down a new migration file in `app/migrations/`, also run:

```
npm run migrate:up
```

The migration file is in Git; the *applied state* of the local database is not. Pulling the file is not the same as running it.

## Discipline at session end

The closing move before walking away from a machine:

```
cd ~/Projects/flashflow
git status
```

If `git status` shows anything modified or staged, decide deliberately: commit, stash, or revert. Do not walk away from a machine with uncommitted changes — they will not follow you to the other machine, and you'll discover the gap mid-session there.

The standard close:

```
git add <files>
git commit -m "..."
git push
```

## Discipline when switching machines

Three things that must be true for the second machine to do meaningful work:

1. **Repository up to date** — `git pull`.
2. **Dependencies installed** — `npm install`.
3. **Database migrated** — `npm run migrate:up`.

Verify with: `npm run build && npm start && curl http://localhost:3000/health` (in another terminal). If `/health` returns `{"status":"ok","database":"connected",...}`, the machine is fully equipped.

## The `.env` discipline

The `.env` file is the single most likely source of "works on iMac, fails on MacBook" friction. The discipline:

- `.env.example` is committed and shows the *shape* of the configuration with placeholder values.
- `.env` is gitignored and holds the *actual* values for this machine.
- When setting up a new machine, copy `.env.example` to `.env`, then **change machine-specific values** (notably the username in `DATABASE_URL`).
- Never copy `.env` from another machine verbatim — at minimum, the username must be reviewed.

The current values, for reference:

- iMac `.env`: `DATABASE_URL=postgresql://fn@localhost:5432/flashflow_dev`
- MacBook `.env`: `DATABASE_URL=postgresql://user@localhost:5432/flashflow_dev`

## Production state is shared

The production database (Fly's `flashflow-db`) is shared by both machines. Both machines deploy to the same Fly app (`flashflow`). There is no per-machine production environment.

Implications:

- A migration applied against production from the iMac is also active for the MacBook's deploys.
- A `fly deploy` from either machine deploys the same production state.
- Production credentials live in Fly's secrets store, never in either machine's `.env`.

## What can go wrong, and how to recognise it

A short field guide to common failure modes:

| Symptom | Likely cause | Fix |
|---|---|---|
| `Cannot find module 'X'` on build | `npm install` not run after pulling | `cd app && npm install` |
| `role "fn" does not exist` (or "user") | `.env` username doesn't match this machine's macOS username | Edit `.env`, change username |
| `Did not find any relations` in psql | Migration not applied | `npm run migrate:up` |
| `Could not read package.json` | Wrong directory (run from `app/`, not root) | `cd app` |
| Migrate command fails to find script | Out-of-date `package.json` | `git pull && npm install` |
| Production app shows old code | Not deployed since last commit | `fly deploy` from `app/` |

## When in doubt

The reliable diagnostic for "is this machine working?" is the full chain:

```
cd ~/Projects/flashflow/app
git status              # working tree clean
node --version          # node installed
npm --version           # npm installed
fly auth whoami         # flyctl authenticated
brew services list      # postgresql@16 started
psql flashflow_dev -c "\dt"   # five tables present
npm run build           # build succeeds
npm start               # server starts
# curl http://localhost:3000/health  # in another terminal
```

If every step passes, the machine is fully equipped.
