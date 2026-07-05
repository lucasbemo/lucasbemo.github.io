---
# This file is a provenance marker, not a published page.
# build render:never keeps Hugo from rendering it in ANY build (draft or production).
draft: true
build:
  render: never
  list: never
publishResources: false
---

# DoIt demo content — local reference (do not publish)

These posts are **third-party content** copied from the DoIt theme's example site,
kept locally as inspiration/reference for how DoIt posts and features are written.

- **Source:** https://github.com/HEIGE-PCloud/DoIt — `exampleSite/content/posts/`
  (branch `main`), English (`index.en.md`) versions only.
- **License:** DoIt is MIT licensed. This content belongs to the DoIt authors.
- **Status:** every post here is `draft: true` and `hiddenFromHomePage` /
  `hiddenFromSearch: true`. The production deploy runs `hugo` **without** `--buildDrafts`,
  so nothing in this folder ever publishes to https://lucasbemo.github.io/.
- **Refresh:** re-run the import from the same source paths to update.

Not written by Lucasbemo. See `niche-features-reference/` for shortcodes intentionally
not imported as full posts (mapbox, echarts, plantuml, wavedrom, aplayer/music, bilibili,
bluesky).
