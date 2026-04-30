# FlashFlow — Architecture

*Layer 7 of the design sequence. Status: accepted, session 02.*

## Purpose

This document describes the major parts of the FlashFlow system and how
they communicate. It deliberately does not name specific frameworks,
databases, or hosting platforms — those decisions belong to Layer 8
(Tech Stack). The architecture should remain valid even if the
underlying technology choices change.

## The shape

FlashFlow is a three-component system, with the browser as the user's
window onto two backend services:

```
[ Browser (PWA client) ]
          │  HTTP / REST
          ▼
[ Node.js application server ]
          │
    ┌─────┴──────────────┐
    ▼                    ▼
[ Database ]   [ Python scheduler service ]
                  (HTTP / REST)
```

The browser only ever talks to the application server. The application
server talks to the database for storage and to the scheduler service
for algorithmic decisions. The scheduler has no direct contact with the
browser.

## Components

**Browser (PWA client).** The Progressive Web App that runs in the user's
browser on the iMac, MacBook, and iPhone. Draws the screen, captures
input, makes requests when it needs data. Holds no canonical state — if
the browser is closed, no information is lost.

**Application server.** The conductor of the system. Receives requests
from the browser, reads and writes the database, asks the scheduler
service for due-date and interval decisions, returns responses. Owns the
user-facing workflows (daily review, in-app authoring, edit-during-review,
maintenance) but not the algorithm that decides them.

**Scheduler service.** Owns the spaced-repetition algorithm. Given a
card's ladder, computes the next interval. Given the current date,
identifies which cards are in the stack. Given a Pass or Fail, computes
the next ladder entry's due date. Stateless — receives the data it needs
in each request, returns an answer, holds nothing between requests.

**Database.** The single source of truth for cards, ladders, sources,
and any other persistent data. Reachable only by the application server.

## Connections

**Browser ↔ application server.** HTTP requests in the REST style.
Resources (cards, today's stack, ladder entries) are addressable by URL;
HTTP verbs (GET, POST, PUT, DELETE) carry the meaning of the request.

**Application server ↔ scheduler service.** Also HTTP/REST. The
scheduler exposes a small set of endpoints for the algorithmic questions
the application server needs answered.

**Application server ↔ database.** A database driver — a library running
inside the application server process, speaking the database's native
protocol. Not HTTP.

## Why this shape

The Python scheduler is carved out from the Node.js application server
deliberately, for two reasons:

1. **Each language plays to its strengths.** Node.js handles concurrent
   web requests well; Python's scientific ecosystem is unmatched for
   numerical and statistical work. The scheduler is the natural place
   for future statistical refinements (forgetting-curve fitting,
   retention analysis), so keeping it in Python keeps the door open.

2. **Direct preparation for WhiteGlove.** WhiteGlove's intended structure
   is the same split: a TypeScript/Node.js application backend with a
   Python pricing model carved out as a separate service. Practising the
   pattern in FlashFlow — how the two services are deployed, how they
   communicate, how errors propagate — transfers to the larger project.

A simpler architecture (Node.js does everything; the scheduler is a
function call inside the request handler) would be defensible for
FlashFlow alone. The carve-out earns its place through learning value,
not user value.

## Trade-offs accepted

- **Two services to deploy** instead of one. Twice the deployment
  surface; twice the place where things can break.
- **A network hop inside every review action.** Milliseconds, but real.
- **Two languages' tooling and idioms** in one project. More to learn,
  more to keep current.
- **Distributed-system failure modes.** Two processes communicating over
  a network can fail in ways one process cannot — partial failures,
  timeouts, version mismatches. Small versions of these are expected;
  living with them is part of the learning.

## Out of scope for this document

- Specific frameworks (Layer 8: Tech Stack).
- Specific database product (Layer 8).
- Hosting and deployment (Layer 8).
- Offline operation, multi-user support, sync (v2; see backlog.md).
