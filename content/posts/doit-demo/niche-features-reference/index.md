---
title: "Niche Features Reference (DoIt)"
date: 2019-12-01T00:00:00+00:00
draft: true
hiddenFromHomePage: true
hiddenFromSearch: true
description: "Syntax reference for DoIt shortcodes not imported as full demo posts."
tags: ["reference"]
categories: ["documentation"]
---

Reference for DoIt features intentionally **not** imported as full demo posts. Syntax below
is shown literally (fenced) — copy it into a real post to use. Each notes what it needs.
Full live examples live in the DoIt repo under `exampleSite/content/posts/tests/`.

<!--more-->

## Music player (APlayer)

Audio player. No extra config needed (loads its JS on demand).

```
{{</* music url="/music/Wavelength.mp3" name=Wavelength artist=oldmanyoung cover="/images/Wavelength.webp" */>}}
{{</* music auto="https://music.163.com/#/playlist?id=60198" */>}}
{{</* music server="netease" type="song" id="1868553" */>}}
```

Fixture: `exampleSite/content/posts/tests/music-tests`.

## Bilibili video

Embeds a Bilibili video by `BV`/`av` id.

```
{{</* bilibili BV1Sx411T7QQ */>}}
{{</* bilibili id=BV1TJ411C7An p=3 */>}}
```

Fixture: `exampleSite/content/posts/tests/bilibili-tests`.

## Mapbox map

Interactive map. **Requires** a Mapbox access token in config:
`[params.page.mapbox] accessToken = "..."`. Without it, the map renders empty.

```
{{</* mapbox lng=121.485 lat=31.233 zoom=12 */>}}
{{</* mapbox -122.252 37.453 10 false "mapbox://styles/mapbox/navigation-preview-day-v4" "mapbox://styles/mapbox/navigation-preview-night-v4" */>}}
```

Fixture: `exampleSite/content/posts/tests/mapbox-tests`.

## ECharts charts

Charts from inline JSON option objects. Loads ECharts JS on demand.

```
{{</* echarts */>}}
{ "xAxis": { "type": "category", "data": ["A","B","C"] },
  "yAxis": { "type": "value" },
  "series": [ { "data": [120, 200, 150], "type": "bar" } ] }
{{</* /echarts */>}}
```

Fixture: `exampleSite/content/posts/tests/echarts-tests`.

## WaveDrom timing diagrams

Digital timing diagrams. Uses a **fenced code block** (render hook), not a shortcode:

````
```wavedrom
{ signal: [
  { name: 'clk',   wave: 'p......' },
  { name: 'data',  wave: 'x.34.5x', data: 'a b c' }
] }
```
````

Fixture: `exampleSite/content/posts/tests/wavedrom-tests`.

## PlantUML diagrams

UML diagrams. Uses a **fenced code block** (render hook). Rendering calls an external
PlantUML server, so it needs network access at view time.

````
```plantuml
@startuml
Alice -> Bob: Hello
Bob --> Alice: Hi
@enduml
```
````

Fixture: `exampleSite/content/posts/tests/plantuml-tests`.

## Bluesky post embed

Embeds a Bluesky post by URL.

```
{{</* bluesky link="https://bsky.app/profile/bsky.app/post/3latotljnec2h" */>}}
```

Fixture: `exampleSite/content/posts/tests/bluesky-tests.md`.

> **Author note:** the `{{</* … */>}}` and nested ```` ``` ```` fences above are Hugo's
> way of showing shortcode/code-fence syntax *literally* without executing it. Copy the
> inner form (e.g. `{{</* music ... */>}}`) into a real post to actually use the feature.
