# Draft preview workflow — design

**Date:** 2026-07-05
**Status:** approved

## Problem

The root `README.md` documents the create-draft → `draft: false` → publish flow but
says nothing about how draft posts behave, or that the repo already ships draft
content. Two concrete gaps:

1. **No production-like local preview.** `make serve` runs `hugo server -D`, which
   always includes drafts. There is no documented way to preview the site exactly as
   production will publish it (drafts hidden). "Will this draft leak?" cannot be
   answered locally.
2. **Pre-existing drafts are undocumented.** `content/posts/doit-demo/` is
   third-party DoIt reference content, every post `draft: true`. It shows in local
   preview but never publishes. A reader of the README has no way to know this.

The build machinery is already correct: `make build` and the GitHub Actions deploy
both run `hugo --gc --minify` *without* `-D`, so drafts never reach the live site.
The gap is workflow ergonomics + documentation, not correctness.

## Decision

Make **drafts-hidden the default** local preview, and add an **explicit** target for
previewing with drafts while authoring.

### Makefile

- `make serve` → `hugo server` — production-like preview, drafts **hidden** (new default).
- `make serve-drafts` → `hugo server -D` — preview **including** drafts, used while
  writing a post.
- Add `serve-drafts` to the `.PHONY` line.

### README

- **Local development** table/list: document both `make serve` (no drafts) and
  `make serve-drafts` (with drafts).
- **Publishing a post**: the write/preview step switches from `make serve` to
  `make serve-drafts`, since a freshly created post is `draft: true` and would not
  appear under the new default `make serve`.
- **Drafts** note (folded into the Publishing section): explains that `make serve`
  hides drafts to match production, `make serve-drafts` shows them, and that
  `content/posts/doit-demo/` is pre-existing draft reference content that never
  publishes (pointer to its own `README.md` for provenance). Include a one-liner to
  list every draft:
  ```bash
  grep -rl "draft: true" content
  ```

## Rationale

- `make serve` as the production mirror answers the most common safety question
  ("what actually goes live?") with the shortest command.
- An explicit `serve-drafts` keeps the authoring loop one command away and reads
  symmetrically with `serve`.
- Documenting the pre-existing `doit-demo` drafts closes the discovery gap the user
  raised without changing any content — the folder already behaves correctly.

## Out of scope

- No changes to `make build`, the CI workflow, or any post's front matter.
- No new tooling beyond the two Makefile targets (no draft-listing target, no publish
  helper).
