# Design: Professional Hugo Blog (DoIt theme)

**Date:** 2026-07-04
**Status:** Approved (design) — pending spec review

## Overview

A professional, long-lived personal/tech blog built with Hugo (extended) and the
**DoIt** theme (a maintained fork of LoveIt, same design and config keys). Deployed
as a GitHub **User Pages** site at `https://lucasbemo.github.io/` via GitHub Actions.

### Key facts

| Item | Value |
|------|-------|
| Site title | Lucasbemo's Blog |
| Author | Lucasbemo |
| baseURL | `https://lucasbemo.github.io/` |
| Deploy repo | `lucasbemo.github.io` (User Pages — repo name is mandatory) |
| Language | en |
| Hugo | v0.163.3 extended (installed) |
| Theme | DoIt, via Hugo Modules (Go 1.26 installed) |

> **Note:** Because `baseURL` is the domain root, this must be a GitHub *User Pages*
> repo named exactly `lucasbemo.github.io`. A project-pages repo would serve under a
> subpath and require a different `baseURL`.

## Architecture & tooling

- **Hugo extended** — required for the theme's SCSS pipeline.
- **Theme via Hugo Modules** — DoIt is imported in `config/_default/module.toml` and
  version-pinned in `go.mod`. Updated with `hugo mod get -u`. No git submodules.
- **Split config** under `config/_default/`:
  - `hugo.toml` — core site config (baseURL, title, language, build, taxonomies, outputs, markup)
  - `params.toml` — theme params (features, header/footer, home page, SEO)
  - `menu.toml` — navigation menu
  - `module.toml` — theme module import

## Directory structure

```
blog-generator/
├── config/_default/
│   ├── hugo.toml
│   ├── params.toml
│   ├── menu.toml
│   └── module.toml
├── content/
│   ├── _index.md            # homepage front matter
│   ├── posts/
│   │   └── hello-world.md    # sample post (draft: false)
│   └── about/
│       └── index.md          # about page
├── assets/
│   └── css/_custom.scss      # theme-safe custom style overrides (empty starter)
├── static/
│   ├── robots.txt
│   └── favicon.ico           # placeholder note in README
├── archetypes/
│   └── posts.md              # post template with default front matter
├── layouts/                  # (empty; override slot for future use)
├── .github/workflows/
│   └── deploy.yml            # build + deploy to GitHub Pages
├── go.mod
├── go.sum
├── .gitignore
├── Makefile
└── README.md
```

## Features (enabled)

1. **Local search** — Fuse.js. Adds `JSON` to home output formats; theme generates
   the client-side search index at build time. No external service.
2. **Tech writing extras**:
   - Syntax highlighting (Hugo's Chroma) with copy-to-clipboard button.
   - KaTeX math rendering.
   - Mermaid diagrams.
   - Automatic table of contents.
3. **SEO & analytics**:
   - Open Graph + Twitter card meta, JSON-LD structured data.
   - `sitemap.xml`, RSS feed, `robots.txt`.
   - Privacy-friendly analytics slot (GoatCounter) present but commented out.

**Not enabled (deferred):** comments (Giscus). Documented in README as an easy toggle.

## CI/CD — GitHub Pages

`.github/workflows/deploy.yml`:

- Trigger: push to `main` (+ manual `workflow_dispatch`).
- Steps: checkout → setup Hugo extended (pinned version) → `hugo mod get` →
  `hugo --minify --gc` → upload artifact → `actions/deploy-pages`.
- Permissions: `pages: write`, `id-token: write`. Concurrency guard on `pages`.
- Repo setting required (manual, one-time): Settings → Pages → Source = "GitHub Actions".

## Content workflow

- `make serve` — `hugo server -D` (live preview incl. drafts).
- `make new title="my-post"` — `hugo new posts/my-post.md` from archetype.
- `make build` — production build to `public/`.
- `make update` — `hugo mod get -u` to update the theme.
- **Archetype** `archetypes/posts.md` pre-fills: title, date, `draft: true`,
  `description`, `tags`, `categories`, and toc/math/mermaid front-matter flags.
- Seeded content: one sample post + an about page so the first build looks complete.

## Dev quality

- `.gitignore`: `/public`, `/resources`, `.hugo_build.lock`, `node_modules`, OS files.
- `README.md`: setup, all `make` commands, how to update the theme, how to enable
  comments/analytics, and the GitHub Pages one-time setting.
- Git initialized with a clean initial commit.

## Success criteria

- `hugo` builds with **zero errors** and no fatal deprecation warnings.
- `make serve` renders homepage, sample post, about page, working search, and a
  code block with a copy button locally.
- Pushing to the `lucasbemo.github.io` repo triggers the Action and publishes to
  `https://lucasbemo.github.io/`.
- Config is split, documented, and the theme updates via a single command.

## Out of scope (YAGNI)

- Comments, multilingual content, custom layouts/shortcodes, image CDN,
  newsletter integration. All can be added later without rework.
