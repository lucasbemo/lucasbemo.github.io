# lucasbemo.github.io

Personal blog built with [Hugo](https://gohugo.io/) (extended) and the
[DoIt](https://github.com/HEIGE-PCloud/DoIt) theme, deployed to GitHub Pages.

**Live site:** https://lucasbemo.github.io/

## Requirements

- Hugo **extended** `0.163.3`
- Go `1.26+` (Hugo Modules fetch the theme)

## Local development

```bash
make serve      # live preview with drafts at http://localhost:1313
make new title="my-post"   # create content/posts/my-post.md from the archetype
make build      # production build into ./public
make update     # update the DoIt theme to its latest release
make clean      # remove build artifacts
```

The theme is a **Hugo Module** pinned in `go.mod` — there are no git submodules.
`public/` is generated and **git-ignored**; it is built by CI, never committed.

## Config

All config lives in `config/_default/`:

| File | Responsibility |
|------|----------------|
| `module.toml` | DoIt theme module import |
| `hugo.toml` | core: baseURL, taxonomies, pagination, outputs, markup |
| `params.toml` | theme params: search, profile, code/math/mermaid, SEO |
| `menu.toml` | top navigation |

## Deployment

Push to `master` → GitHub Actions builds with Hugo and deploys to Pages.
No manual build or upload. One-time setup: **Settings → Pages → Source = "GitHub Actions"**.

## Enabling optional features later

- **Avatar / OG image:** add `static/images/avatar.png` and `static/images/og-default.png`.
- **Comments (Giscus):** enable GitHub Discussions on the repo, then add a
  `[comment.giscus]` block in `params.toml` per the DoIt docs.
- **Analytics (GoatCounter/Plausible):** set `[analytics].enable = true` in
  `params.toml` and fill in the provider block.

## Alternative hosting (future option)

This source is host-agnostic. To get **per-PR preview deploys**, connect the repo to
**Cloudflare Pages** or **Netlify** (build command `hugo --minify`, output `public`,
env `HUGO_VERSION=0.163.3`) and delete `.github/workflows/deploy.yml`. Note: the
`lucasbemo.github.io` domain only works with GitHub Pages — Cloudflare/Netlify would
serve from a `*.pages.dev` / `*.netlify.app` URL or a custom domain you own.
