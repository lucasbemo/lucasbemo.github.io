# Draft Preview Workflow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make drafts-hidden the default local preview (`make serve`) and add an explicit `make serve-drafts` for authoring, then document both plus the pre-existing `doit-demo` reference drafts in the README.

**Architecture:** Two Makefile phony targets wrap `hugo server` (no drafts, production mirror) and `hugo server -D` (with drafts). The README's Local development and Publishing sections are updated to reference the right target for each moment, and a folded Drafts note explains behavior and the repo's pre-existing reference drafts.

**Tech Stack:** Hugo (extended) 0.163.3, GNU Make, Markdown.

## Global Constraints

- No changes to `make build`, `.github/workflows/deploy.yml`, or any post front matter.
- No new tooling beyond the two Makefile targets — no draft-listing target, no publish helper.
- Preserve existing Makefile style (tab-indented recipes, comment above each target).
- Live URL referenced in docs: `http://localhost:1313`.
- Draft-listing one-liner, verbatim: `grep -rl "draft: true" content`.

---

### Task 1: Flip Makefile serve defaults

**Files:**
- Modify: `Makefile` (`.PHONY` line and `serve` target)

**Interfaces:**
- Produces: `make serve` → `hugo server` (drafts hidden); `make serve-drafts` → `hugo server -D` (drafts shown). Task 2's README docs rely on these exact target names.

- [ ] **Step 1: Read the current Makefile**

Run: `cat Makefile`
Confirm the `.PHONY` line is `.PHONY: serve new build update clean` and the `serve` target recipe is `hugo server -D`.

- [ ] **Step 2: Update the `.PHONY` line and the `serve`/`serve-drafts` targets**

Replace the `.PHONY` line and the existing `serve` block with:

```makefile
.PHONY: serve serve-drafts new build update clean

# Live preview (production-like, drafts hidden) at http://localhost:1313
serve:
	hugo server

# Live preview INCLUDING drafts — use while writing a post
serve-drafts:
	hugo server -D
```

Leave the `new`, `build`, `update`, and `clean` targets unchanged.

- [ ] **Step 3: Verify `make serve` hides drafts**

Run: `make serve` in one terminal, then in another: `curl -s http://localhost:1313/posts/ | grep -ci "basic markdown syntax"`
Expected: `0` (the `doit-demo` draft "Basic Markdown Syntax" is NOT listed). Stop the server (Ctrl-C).

Note: if starting a server interactively is impractical, instead run `hugo --gc --minify -D=false -d /tmp/serve-check >/dev/null 2>&1 && grep -rci "basic markdown syntax" /tmp/serve-check/posts/index.html` and expect `0`, then `rm -rf /tmp/serve-check`.

- [ ] **Step 4: Verify `make serve-drafts` shows drafts**

Run: `make serve-drafts` in one terminal, then in another: `curl -s http://localhost:1313/posts/ | grep -ci "basic markdown syntax"`
Expected: `1` or more (the draft IS listed). Stop the server (Ctrl-C).

Note: non-interactive equivalent — `hugo -D -d /tmp/serve-check >/dev/null 2>&1 && grep -rci "basic markdown syntax" /tmp/serve-check/posts/index.html` and expect `1` or more, then `rm -rf /tmp/serve-check`.

- [ ] **Step 5: Commit**

```bash
git add Makefile
git commit -m "build: make 'serve' hide drafts by default, add 'serve-drafts'"
```

---

### Task 2: Document draft preview and pre-existing drafts in README

**Files:**
- Modify: `README.md` (Local development block, Publishing a post section)

**Interfaces:**
- Consumes: `make serve` and `make serve-drafts` targets from Task 1.

- [ ] **Step 1: Update the Local development command list**

In `README.md`, find the fenced block under `## Local development` that begins with `make serve`. Replace the `make serve` line and insert a `make serve-drafts` line so the block reads:

```bash
make serve         # production-like preview (drafts hidden) at http://localhost:1313
make serve-drafts  # preview INCLUDING drafts — use while writing a post
make new title="my-post"   # create content/posts/my-post.md from the archetype
make build      # production build into ./public
make update     # update the DoIt theme to its latest release
make clean      # remove build artifacts
```

- [ ] **Step 2: Update the Publishing a post workflow to preview with drafts**

In the `## Publishing a post` fenced block, change the preview line from `make serve` to `make serve-drafts` so a freshly created (`draft: true`) post is visible while writing:

```bash
make new title="my-first-real-post"   # creates a draft from the archetype
make serve-drafts                     # preview (incl. this draft) at http://localhost:1313
# edit the post, then set `draft: false` in its front matter when ready:
git add content
git commit -m "post: my first real post"
git push
```

- [ ] **Step 3: Add the Drafts note at the end of the Publishing a post section**

Immediately after the paragraph that ends "…No manual builds, no committing `public/`." (the last line of the Publishing a post section), add:

```markdown
### Drafts

Any post with `draft: true` in its front matter shows up **locally** under
`make serve-drafts` (`hugo server -D`) but is **excluded from production** — the
default `make serve`, `make build`, and the GitHub Actions deploy all run Hugo
*without* `-D`, so drafts never reach the live site. Use `make serve` to preview
exactly what will publish; flip `draft: false` and commit when a post is ready.

This repo already ships some drafts: `content/posts/doit-demo/` is third-party
reference content copied from the DoIt theme's example site. Every post there is
`draft: true`, so it appears under `make serve-drafts` but never publishes — it's
kept as a live reference for DoIt shortcodes and post formatting (see
`content/posts/doit-demo/README.md` for provenance). You can ignore or delete that
folder without affecting the deployed site.

To list every draft currently in the repo:

```bash
grep -rl "draft: true" content
```
```

- [ ] **Step 4: Verify the README renders coherently**

Run: `grep -n "serve-drafts\|### Drafts\|draft: true" README.md`
Expected: matches showing the new `serve-drafts` lines in both the Local development and Publishing blocks, the `### Drafts` heading, and the `grep -rl "draft: true" content` line.

- [ ] **Step 5: Commit**

```bash
git add README.md
git commit -m "docs: document serve vs serve-drafts and pre-existing doit-demo drafts"
```

---

## Self-Review

**Spec coverage:**
- Makefile: `serve` = `hugo server`, `serve-drafts` = `hugo server -D`, `.PHONY` updated → Task 1. ✓
- README Local development documents both targets → Task 2 Step 1. ✓
- Publishing switches preview to `make serve-drafts` → Task 2 Step 2. ✓
- Folded Drafts note (serve vs serve-drafts + doit-demo reference drafts + grep one-liner) → Task 2 Step 3. ✓
- Out of scope (no build/CI/front-matter changes) honored — no task touches them. ✓

**Placeholder scan:** No TBD/TODO/vague steps; every code and doc block is complete verbatim content.

**Type consistency:** Target names `serve` and `serve-drafts` are identical across Task 1 (definition) and Task 2 (documentation references).
