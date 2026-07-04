# Design: DoIt Demo Content as Local Reference

**Date:** 2026-07-04
**Status:** Approved (design) — pending spec review

## Overview

Pull the official DoIt demo's **source markdown** into this blog as local, draft-only
reference material — so the author can study how DoIt posts and features are written.
Source is the theme's own repo (`github.com/HEIGE-PCloud/DoIt`, path
`exampleSite/content/`), **not** the rendered demo site — the repo holds authentic
markdown with real front matter and shortcodes, which the rendered HTML cannot.

The content is **reference only**: everything is `draft: true` and therefore excluded
from the production build (CI runs `hugo --gc --minify` with no `--buildDrafts`), so it
**never publishes** to https://lucasbemo.github.io/.

## Scope

### In scope: the 8 "real" demo posts

Copied as page bundles into `content/posts/doit-demo/<slug>/index.md`:

| Slug | Source path (in DoIt repo) |
|------|----------------------------|
| `basic-markdown-syntax` | `exampleSite/content/posts/basic-markdown-syntax/` |
| `emoji-support` | `exampleSite/content/posts/emoji-support/` |
| `pwa-support` | `exampleSite/content/posts/pwa-support/` |
| `create-diagrams` | `exampleSite/content/posts/how-to-DoIt/create-diagrams/` |
| `theme-documentation-basics` | `exampleSite/content/posts/theme-documentation-basics/` |
| `theme-documentation-content` | `exampleSite/content/posts/theme-documentation-content/` |
| `theme-documentation-built-in-shortcodes` | `exampleSite/content/posts/theme-documentation-built-in-shortcodes/` |
| `theme-documentation-extended-shortcodes` | `exampleSite/content/posts/theme-documentation-extended-shortcodes/` |

### In scope: a niche-features reference doc

One authored post, `content/posts/doit-demo/niche-features-reference/index.md`, that
documents the 7 features intentionally **not** copied as full posts (the `tests/`
fixtures), so they are captured for future use:

**aplayer/music, bilibili, mapbox, echarts, wavedrom, plantuml, bluesky.**

For each feature the doc provides:
- What it does (one line)
- The exact shortcode syntax, shown **inside fenced code blocks** (literal/documentation
  form — not live shortcodes) so the reference is build-safe, copy-pasteable, and free of
  empty-widget / missing-token side effects
- What it requires (e.g. mapbox → `params.page.mapbox.accessToken`; plantuml → an
  external render server)
- A pointer to the original DoIt test fixture (`exampleSite/content/posts/tests/<x>`)
  and the DoIt docs for a full live example

Syntax is copied verbatim from the DoIt source (verified, not guessed).

### Out of scope

- The ~26 `tests/` fixtures (terse QA snippets; their features are already demonstrated
  in the `theme-documentation-*-shortcodes` posts, and the niche ones are captured in the
  reference doc above).
- Section / taxonomy index pages (`about`, `showcase`, `series`, `tags`, `categories`,
  `authors`) — these would collide with the site's own sections; not useful as post
  inspiration.
- All `zh-cn` (Chinese) translations — this site is English-only.

## Transformations applied to each copied post

1. **Language:** take `index.en.md` → save as `index.md`. Drop every `*.zh-cn.*` file
   (both markdown and `*.zh-cn.webp` image variants).
2. **Bundle images:** copy each post's language-neutral resources (e.g.
   `featured-image.webp`, `summary.webp`, `Install-PWA.webp`, `language-switch.gif`)
   into the same destination bundle so `featuredImage` and `{{< image >}}` references
   resolve locally. Skip `*.zh-cn.webp` variants.
3. **Front matter — force these three keys on every copied post** (add if missing,
   overwrite if present):
   - `draft: true`
   - `hiddenFromHomePage: true`
   - `hiddenFromSearch: true`
4. **featuredImage references:** ensure they resolve within the copied bundle (bundle-
   relative filename). Fix any that point at an absolute demo-site path.
5. Otherwise preserve the original content verbatim (tags, categories, series, authors,
   body, shortcodes) — the point is faithful inspiration.

## Placement & local-environment impact

**Destination:** `content/posts/doit-demo/` (a sub-section under `posts/`).

**Live site:** zero impact — all drafts, excluded by CI.

**Local `make serve` (`hugo server -D`, drafts ON):**

| Local surface | Demo posts shown? | Mechanism |
|---|---|---|
| Homepage post stream | No | `paginator.html` filters `hiddenFromHomePage` |
| Local search | No | `index.json` filters `hiddenFromSearch` |
| `/posts/` archive page | Yes | section list ranges all `.Pages` (no hidden filter) |
| `/tags/`, `/categories/` | Yes | term pages list all pages with the term |
| Direct URL `/posts/doit-demo/<slug>/` | Yes (intended) | — |

This local-only, draft-only noise (extra entries on the `/posts/` archive and extra tag/
category terms) is accepted for the simpler "everything under `posts/`" mental model. It
disappears entirely under `make build` or `hugo server` without `-D`.

## Provenance & licensing

- Add `content/posts/doit-demo/README.md` marking the folder as **third-party content
  from the DoIt theme (MIT licensed)**, kept as local reference, all drafts, never
  published. Note the upstream source path so it can be refreshed later.

## Success criteria

- All 8 posts + the niche-features reference doc exist under `content/posts/doit-demo/`,
  en-only, each with `draft: true` + `hiddenFromHomePage: true` + `hiddenFromSearch: true`.
- Each post's bundle images are present; no missing-resource errors for copied posts.
- **Draft build is clean:** `hugo --gc -D` (drafts on) completes with **no fatal errors**.
  Any copied post that fatally errors is culled and reported; non-fatal WARNs (e.g. a
  mapbox example with no access token in a `theme-documentation-*` post) are documented,
  not fixed.
- **Production build unaffected:** `hugo --gc --minify` (no `-D`) produces the exact same
  output as before this change (26 pages) — the demo posts do not appear.
- The niche-features reference doc lists all 7 features with verified syntax in fenced
  code blocks and the config/service each needs.
- The provenance README is present.

## Out-of-scope / YAGNI

- No changes to the live site, config, theme, or existing content.
- No attempt to make niche shortcodes (mapbox/echarts/etc.) actually functional — the
  reference documents them; enabling them is a future, separate task.
- No zh-cn, no tests fixtures, no taxonomy index pages.
