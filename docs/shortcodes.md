<!-- Version: 1.9 | Last updated: 2026-09-01 -->

# Shortcodes Reference

The First Folio theme provides 21 custom shortcodes for varied content types.

## Table of Contents

1. [callout](#callout) - Styled alert/notice boxes
2. [`center`](#centre) - Centre-aligned content block
3. [colorbold](#colorbold) - Inline accent-coloured bold text
4. [details](#details) - Collapsible content
5. [spoiler](#spoiler) - Deliberately concealed inline or block content
6. [dialogue](#dialogue) - Character speech for plays
7. [direction](#direction) - Stage directions
8. [popquote](#popquote) - Alias for `details`; retained for existing content
9. [quote](#quote) - Pull-quote with decorative quotation marks and attribution
10. [poem](#poem) - Poetry with preserved line breaks
11. [stat / stats](#stat--stats) - Number+label "stats rows" with optional responsive grid
12. [video](#video) - HTML5 video player
13. [contactform](#contactform) - Self-hosted contact form with CAPTCHA
14. [formspree](#formspree) - Formspree-backed contact form
15. [rawhtml](#rawhtml) - Raw HTML pass-through
16. [section-list](#section-list) - Section navigation list
17. [tagcloud](#tagcloud) - Opt-in weighted taxonomy cloud
18. [img](#img) - Inline image with responsive thumbnails
19. [gallery](#gallery) - Image gallery with lightbox
20. [side-by-side](#side-by-side) - Side-by-side content wrapper

---

## callout

Styled alert/callout boxes with colour-coded types.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `type` | Yes | One of: `info`, `tip`, `alert`, `warning`, `custom` |
| `text` | Yes | Message content |
| `title` | No | Custom title (for `info`, `tip`, `warning`, `custom` - overrides the default) |
| `link` | No | URL - makes the title a clickable link |
| `linktext` | No | Link text when `link` is used without a title (default: "More info") |
| `align` | No | Text alignment: `left`, `center`, `right` |
| `width` | No | Max width of the callout box, any CSS unit (`30rem`, `60%`, etc.). Box is auto-centred on the page |
| `position` | No | Float direction: `left` or `right`. Omit for default block layout |
| `style` | No | Inline CSS (only for `type="custom"`) |

### Usage

```markdown
{{< callout type="tip" text="This is a helpful tip!" >}}
{{< callout type="info" text="Informational note" >}}
{{< callout type="info" title="Buy Now" text="Available worldwide" link="https://example.com" align="center" width="60%" >}}
{{< callout type="alert" text="Important alert message" >}}
{{< callout type="warning" text="Warning message" >}}
{{< callout type="custom" title="Custom Title" text="Custom message" style="background: #fee;" >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#callout).

---

## `center` {#centre}

Centre-aligned content block. Wraps inner content in a `<div class="text-center">`.

**Note:** In Org-mode files, shortcodes with inner Org markup (links, lists) may not render correctly. For Org content, prefer using `#+BEGIN_EXPORT html` with `<div class="text-center">` directly.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| Inner content | Yes | Content to centre |

### Usage

```markdown
{{< center >}}
This text is centred.
{{< /center >}}
```

**Org-mode alternative:**

```org
#+BEGIN_EXPORT html
<div class="text-center">
<p>Centred text with <a href="https://example.com">a link</a></p>
</div>
#+END_EXPORT
```

---

## colorbold

Inline text rendered in the secondary accent colour (`--color-secondary`) and bold. Underlined by default. Designed for emphasis within a sentence.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| First positional or `text` | Yes | Text to display |
| `underlined` | No | Set to `"false"` to remove underline (default: `true`) |

### Usage

```markdown
Are these only {{< colorbold "words" >}} I'm meant to frame?
This has {{< colorbold text="no underline" underlined=false >}} here.
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#colorbold).

---

## details

Collapsible content block. Closed state shows an ellipsis hint; open state reveals full content.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| First positional | Yes | Summary/title text (supports markdown) |
| Inner content | Yes | Body content (supports markdown) |

### Usage

```markdown
{{< details "Click to expand" >}}
Hidden content goes here.
Can include **markdown**.
{{< /details >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#details).

---

## spoiler

Conceals review spoilers and other sensitive editorial details until the reader deliberately reveals them. Both forms replace the protected characters with a deterministic, low-opacity symbol pattern that follows the text's whitespace and wrapping. The symbols inherit the surrounding text colour; `params.spoiler.opacity` controls their opacity and defaults to `0.38`. The concealed state has no filled background, border, or card.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| First positional or `text` | Inline form | Protected inline text; may contain inline Markdown |
| Inner content | Block form | Protected block content; supports paragraphs, emphasis, links, and lists |
| `label` | No | Accessible inline label and visible block control; defaults to `Spoiler` |

### Inline usage

```markdown
The culprit is {{< spoiler "the village doctor" />}}.
The motive is {{< spoiler text="hidden in the first letter" label="Motive" />}}.
```

Inline spoilers stay inside the surrounding paragraph. Their symbol pattern follows the protected text's width and spaces, and each spoiler has independent reveal state. The inline label is available as hover text, keyboard focus, and the control's accessible name without inserting a visible word into the sentence. The closing slash is required because the same Hugo shortcode also supports paired block content.

### Block usage

```markdown
{{< spoiler label="Ending" >}}
The final scene reveals **why the letters stopped**.

- The first clue is reinterpreted.
- The last conversation gains a different meaning.
{{< /spoiler >}}
```

The block's symbol pattern takes its dimensions from the protected Markdown, so the reader sees the rhythm of the concealed lines rather than a generic Details accordion or a solid rectangle. A full-width control using the spoiler's `label`, with centred label text, remains visible above the protected lines before and after reveal. In the revealed state, clicking non-interactive text conceals the block again; links and form controls remain operable. The visible label also remains the native reveal and conceal control.

Supplying both `text` and inner content is an error, as is supplying neither. Hugo stops the build and identifies the source page rather than rendering ambiguous or empty markup.

Both forms are concealed by default, and their native controls operate with pointer, touch, or keyboard without JavaScript. The revealed-text click behaviour is a JavaScript enhancement for block spoilers. The symbol copy is inert and hidden from assistive technology; protected content becomes available only after reveal. Closed spoilers remain concealed in print; a spoiler deliberately revealed before printing is included.

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#spoiler).

---

## dialogue

Character speech for plays and screenplays. Character name renders in small caps with optional parenthetical (delivery direction) in italics.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| First positional or `name` | Yes | Character name |
| Second positional or `parenthetical` | No | Delivery direction |
| Inner content | Yes | Dialogue text |

Supports both positional and named parameters.

### Usage

```markdown
{{< dialogue "TOM" "pleading" >}}Please don't shake off the water!{{< /dialogue >}}
{{< dialogue "ALISON" >}}You've waited since yesterday, Tom.{{< /dialogue >}}
{{< dialogue name="BAYANI" parenthetical="chuckling" >}}Oh is that all?{{< /dialogue >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#dialogue).

---

## direction

Stage directions for plays. Renders in italics with secondary accent colour.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| Inner content | Yes | Stage direction text (supports markdown) |

### Usage

```markdown
{{< direction >}}A bare stage. Single chair centre. TOM enters.{{< /direction >}}
{{< direction >}}Pause.{{< /direction >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#direction).

---

## popquote

Alias for [`details`](#details). Produces identical HTML (`<details class="styled-details">…</details>`). The name dates from a use pattern of revealing aphorism-like quotes one at a time, but the rendering is a generic collapsible disclosure widget, not a pull-quote.

For new content, prefer `details` - its name matches the underlying HTML element and removes the implied (but absent) relationship with [`quote`](#quote). `popquote` is retained for backward compatibility with existing content; there is no plan to remove it.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| First positional | Yes | Opening/summary text |
| Inner content | Yes | Full body content (supports markdown) |

### Usage

```markdown
{{< popquote "Opening line..." >}}
Full quote content here.
Multiple paragraphs supported.
{{< /popquote >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#popquote).

---

## quote

Pull-quote with a decorative opening quotation mark and optional attribution. Block-form shortcode — the body is markdown and can span multiple lines, contain inline formatting, links, and other shortcodes.

Distinct from [`popquote`](#popquote) / [`details`](#details), which render a collapsible disclosure widget. `quote` is an always-visible featured pull-quote intended to draw the eye within the flow of an article.

Two attribution paths: a back-compat single-line `attribution=` for casual literary quotes, and a structured testimonial path (`name` / `role` / `organization` / `photo` / `featured`) for richer named-speaker layouts.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `attribution` | No | Single-line attribution. When set, all structured fields below are ignored (back-compat). |
| `name` | No | Speaker's name — rendered with the heaviest weight in the structured attribution. |
| `role` | No | Speaker's role — rendered on a secondary line below the name. |
| `organization` | No | Speaker's organisation — joined to the role with a comma when both are set, or rendered alone otherwise. |
| `photo` | No | Path to a speaker portrait. Resolution chain: bare filename (page resource) > leading-slash (site-root path) > `http://` / `https://` (absolute URL). Unresolvable photos emit a build warning and the `<img>` is omitted. |
| `featured` | No | `true` applies a stronger visual treatment (larger type, more padding, larger photo). Use sparingly — for hero-style testimonials. |
| Inner content | Yes | The quote text itself; supports full markdown. |

### Usage

Back-compat single-line attribution:

```markdown
{{< quote attribution="A. Person" >}}
The actual quote text — can include **bold**, *italic*, [links](https://example.com).
{{< /quote >}}
```

Structured testimonial:

```markdown
{{< quote
    name="A. Client"
    role="Director"
    organization="Example Co"
    photo="client.jpg"
    featured=true >}}
Working with them clarified what we'd been circling for years.
{{< /quote >}}
```

Unattributed (decorative quote mark, no caption):

```markdown
{{< quote >}}
An unattributed pull-quote.
{{< /quote >}}
```

### Photo resolution chain

The `photo` parameter resolves in three tiers, identical to the `video` shortcode's `poster_image`:

1. **Page resource** — bare filename like `client.jpg` is looked up against the page bundle's resources.
2. **Site-root path** — leading-slash path like `/portraits/client.jpg` is used verbatim from the site root.
3. **Absolute URL** — `http://` or `https://` prefix is used verbatim.

If none resolve, `<img>` is omitted from the output and Hugo emits a stderr WARN naming the offending filename. **This is by design**: the warning surfaces typos and missing assets at build time rather than silently failing. The theme's `RT-54.11` regression test asserts the warning fires, using an intentionally-missing demo file (`intentionally-missing-file.jpg`) in `exampleSite/content/journal/shortcode-showcase/`.

### Styling

- Large decorative opening quotation mark (`"`) coloured by `--pull-quote-mark` (red at 0.3 alpha in light mode, 0.6 alpha in dark mode — tuned per mode for legibility under the body text the mark sits behind), positioned top-left.
- Quote body in serif, slightly larger than body text, full body colour in both modes.
- Back-compat `attribution=` renders right-aligned with an em-dash prefix.
- Structured attribution renders below the quote as: optional photo (circular crop, 3rem / 4rem when featured), name (weighted), role line (smaller, muted).
- `pull-quote-featured` modifier class on the outer `<figure>` enables larger typography and more padding.
- Responsive: on screens narrower than ~32rem the decorative quote mark shrinks and the indent tightens.

---

## poem

Poetry formatting with preserved line breaks. Newlines in source convert to `<br />` tags so verse structure is maintained.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| Inner content | Yes | Poem text with line breaks |

### Usage

```markdown
{{< poem >}}
Roses are red,
Violets are blue,
This preserves
Line breaks for you.
{{< /poem >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#poem).

---

## stat / stats

A pair of shortcodes for portfolio- or consultancy-style "stats rows" — a large number with a short label, individually or in a responsive grid. The `stat` block can be used standalone inline, or wrapped in `stats` for a row-of-numbers layout that reflows responsively.

### `stat` parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `number` | Yes | The headline figure. String, not numeric — supports `"80"`, `"20"`, `"£500k"`, `"4.7"`, etc. |
| `label` | Yes | Caption shown below the number. |
| `prefix` | No | Small glyph or text before the number (e.g. `"~"`, `"£"`, `"$"`). |
| `suffix` | No | Small glyph or text after the number (e.g. `"+"`, `"%"`, `"k"`, `"/5"`). |

### `stats` parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `columns` | No | Fixed column count (`columns=4`). Default behaviour without this parameter is responsive `auto-fit` columns. |
| Inner content | Yes | One or more nested `stat` shortcodes. |

### Usage

Standalone:

```markdown
{{< stat number="80" label="Countries" >}}
```

Prefix and suffix:

```markdown
{{< stat number="20" label="Years" prefix="~" suffix="+" >}}
```

Responsive grid (auto-fit columns — reflows from N across to fewer columns as the viewport narrows):

```markdown
{{< stats >}}
{{< stat number="40" label="Years experience" >}}
{{< stat number="80" label="Countries advised" >}}
{{< stat number="200" suffix="+" label="Parties advised" >}}
{{< /stats >}}
```

Fixed-column grid (override the auto-fit default):

```markdown
{{< stats columns=4 >}}
{{< stat prefix="£" number="500" suffix="k" label="Saved" >}}
{{< stat number="12" label="Awards" >}}
{{< stat number="4.7" suffix="/5" label="Score" >}}
{{< stat number="99.9" suffix="%" label="Uptime" >}}
{{< /stats >}}
```

### Styling

- `.stat-value` in the accent font, large clamp-sized typography (`clamp(2rem, 5vw, 3rem)`), `--color-primary`.
- `.stat-prefix` / `.stat-suffix` ~50% of value size, slightly muted.
- `.stat-label` body font, small, slightly letter-spaced.
- `.stats-grid` uses CSS Grid with `auto-fit, minmax(8rem, 1fr)` by default; `columns=N` emits an inline `style="grid-template-columns: repeat(N, 1fr)"` override.

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#stats).

---

## video

Embed video - either local files via HTML5 `<video>` or Cloudflare Stream videos via iframe. The shortcode auto-detects the source type from the argument.

### Detection Logic

- **32-character hex string** (positional or `id` named param) -> Cloudflare Stream iframe embed
- **Anything else** (file path or URL) -> local HTML5 `<video>` player

### Parameters

**Local video (positional):**

| Parameter | Required | Description |
|-----------|----------|-------------|
| First positional | Yes | Video file path or URL |

**Cloudflare Stream (positional - no player options):**

| Parameter | Required | Description |
|-----------|----------|-------------|
| First positional | Yes | 32-character Cloudflare Stream video UID |

**Cloudflare Stream (named - with player options):**

| Parameter | Required | Description |
|-----------|----------|-------------|
| `id` | Yes | 32-character Cloudflare Stream video UID |
| `autoplay` | No | Auto-start playback (`true`/`false`) |
| `muted` | No | Start muted (`true`/`false`) |
| `loop` | No | Repeat on end (`true`/`false`) |
| `controls` | No | Show player controls (default: `true`) |
| `preload` | No | Browser preload hint (`none`, `metadata`, `auto`) |
| `poster_image` | No | Thumbnail shown before playback - see [Poster Image Resolution](#poster-image-resolution) |
| `startTime` | No | Start at specific time (e.g. `1m30s`) |
| `primaryColor` | No | Player UI accent colour (URI-encoded CSS) |
| `letterboxColor` | No | Player background colour (URI-encoded CSS) |

**Note:** Hugo shortcodes do not allow mixing positional and named parameters. Use all-named syntax (`id="..."`) when you need player options.

### Site Configuration (Cloudflare Stream)

Cloudflare Stream requires a customer code in `hugo.yaml`:

```yaml
params:
  cloudflareStream:
    customerCode: "YOUR_CUSTOMER_CODE"
```

The customer code is the public subdomain identifier visible in all embed URLs - it is not a secret.

#### Site-wide Video Defaults

You can set site-wide defaults for video player params. These apply to every video embed that does not explicitly set that param in page frontmatter or shortcode attributes:

```yaml
params:
  cloudflareStream:
    customerCode: "YOUR_CUSTOMER_CODE"
    videoDefaults:
      autoplay: true    # autoplay all videos by default
      muted: false      # do not mute by default
      loop: false       # do not loop by default
```

**Precedence (highest to lowest):**
1. Page frontmatter / shortcode attribute
2. Site-wide `videoDefaults`
3. Absent - Cloudflare applies its own default

Page frontmatter takes precedence in all cases, including an explicit `false` which suppresses a site-wide `true`. Setting `autoplay: false` in frontmatter will prevent autoplay even when the site default is `autoplay: true`.

**Autoplay and iframe loading:** When autoplay is effectively true (via frontmatter or site default), the embed iframe uses `loading="eager"` so the player initializes immediately on page load. When autoplay is not enabled, `loading="lazy"` is used and the player defers until scrolled into view.

### Usage

**Local video:**

```markdown
{{< video "/videos/my-video.mp4" >}}
```

**Cloudflare Stream (simple):**

```markdown
{{< video "ea95132c15732412d22c1476fa83f27a" >}}
```

**Cloudflare Stream (with options):**

```markdown
{{< video id="ea95132c15732412d22c1476fa83f27a" autoplay="true" muted="true" loop="true" >}}
{{< video id="ea95132c15732412d22c1476fa83f27a" poster_image="toast.jpg" >}}
{{< video id="ea95132c15732412d22c1476fa83f27a" poster_image="https://example.com/thumb.jpg" >}}
```

### Video in Page Layouts

In addition to the shortcode, Cloudflare Stream videos can be used as the primary visual in page layouts via the `video` frontmatter field. This places the video in the layout's media slot (where `image` would normally go).

#### Frontmatter Schema

```yaml
video:
  id: "fd20681eb60dc4cc9c2058f30b977a7a"   # CF Stream UID (required)
  caption: "Open Your Heart"                # optional
  width: 1080                               # optional - see Dimension Resolution below
  height: 1920                              # optional - see Dimension Resolution below
  poster_image: toast.jpg                   # optional - see Poster Image Resolution below
  autoplay: true                            # optional
  muted: true                               # optional
  loop: true                                # optional
  controls: true                            # optional (default: true)
  preload: "auto"                           # optional
  startTime: "5"                            # optional, seconds
  primaryColor: "#ff6600"                   # optional
  letterboxColor: "#000000"                 # optional
```

> **Boolean params and CF defaults:** Pass `true` to enable a feature. Omit the field (or set `false`) to use Cloudflare's default. Setting a boolean param to `false` is equivalent to not setting it - the param is not forwarded to the player URL. If site-wide `videoDefaults` are configured, a `false` value in page frontmatter overrides a `true` site default.

#### Compatible Layouts

| Layout | Behaviour |
|--------|-----------|
| `hero` | Video floats right, text wraps around it |
| `featured` | Video centred above content |
| `featured-columns-left` / `columns` | Video in left column, text in right |
| `featured-columns-right` | Text in left column, video in right |

**Incompatible layouts:** `banner` and `background` (default when `image` is set without a layout). These produce a Hugo build warning if `video` is present.

#### Dimension Resolution

The video container's `aspect-ratio` is resolved in this order:

1. **Frontmatter** - `video.width` and `video.height` if both are present
2. **Video inventory** - `data/video-inventory.yaml` in the site root, keyed by UID (`where .videos "uid" $id`)
3. **Cloudflare Stream API** - fetched at build time when `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` are set. Both vars must be listed under `security.funcs.getenv` in `hugo.yaml`. When the vars are absent, this step is silently skipped
4. **CSS default** - 16:9 (`aspect-ratio: 16 / 9` in the stylesheet); no inline style is added

For the inventory lookup to work, add a `data/video-inventory.yaml` to the site root with this format:

```yaml
videos:
  - uid: "fd20681eb60dc4cc9c2058f30b977a7a"
    width: 1080
    height: 1920
```

The upload script in the content repo (`scripts/upload-video.sh`) writes this format automatically.

#### Poster Image Resolution

The `poster_image` field sets a thumbnail shown in the CF player before the video plays. It is appended to the embed URL as `?poster=[url]`.

The value is resolved to an absolute URL based on its format:

| Format | Example | Resolved as |
|--------|---------|-------------|
| Relative filename (no leading `/`) | `toast.jpg` | `[page.Permalink]toast.jpg` |
| Site-root-relative (leading `/`) | `/images/thumb.jpg` | `[site.BaseURL]images/thumb.jpg` |
| Absolute URL | `https://cdn.example.com/thumb.jpg` | Used verbatim |

**Priority chain:**

1. Frontmatter `poster_image` (or shortcode `poster_image` param)
2. `poster_image` in `data/video-inventory.yaml` for the matching UID - must be an absolute URL
3. No poster - CF Stream default (first frame of video)

**Inventory format:**

```yaml
videos:
  - uid: "fd20681eb60dc4cc9c2058f30b977a7a"
    width: 1080
    height: 1920
    poster_image: "https://tadg.ie/poetry/secrets/open-your-heart/toast.jpg"
```

The inventory `poster_image` must be an absolute URL - the upload script cannot populate it automatically since it is site- and page-specific.

#### Precedence

If both `video` and `image` are set, `video` takes precedence in compatible layouts. A build warning is emitted noting the conflict.

#### Examples

**Hero with video:**

```yaml
---
title: "My Post"
layout: hero
video:
  id: "fd20681eb60dc4cc9c2058f30b977a7a"
  autoplay: true
  muted: true
  loop: true
---
```

**Columns with video:**

```yaml
---
title: "My Post"
layout: featured-columns-left
video:
  id: "fd20681eb60dc4cc9c2058f30b977a7a"
  caption: "Open Your Heart"
---
```

**Featured with video:**

```yaml
---
title: "My Post"
layout: featured
video:
  id: "fd20681eb60dc4cc9c2058f30b977a7a"
---
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#video).

---

## contactform

Self-hosted contact form with Cloudflare Turnstile CAPTCHA, Worker backend, and optional newsletter signup.

Requires Cloudflare Worker deployment and Hugo configuration. See [contactform.md](contactform.md) for the full setup guide.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `newsletter` | No | Set to `"true"` to show newsletter checkbox |

### Site Configuration Required

```yaml
params:
  contactform:
    worker_url: "https://your-worker.example.workers.dev"
    turnstile_sitekey: "0x..."
```

### Usage

```markdown
{{< contactform >}}
{{< contactform newsletter="true" >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#contact-form).

---

## formspree

Contact form using Formspree as the backend. Simpler alternative to `contactform` - no CAPTCHA, no self-hosting required.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `id` | Yes | Formspree form ID |

### Usage

```markdown
{{< formspree id="your-formspree-id" >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#formspree).

---

## rawhtml

Pass through raw HTML without markdown processing. Use for embedding widgets, iframes, or any HTML that Hugo's markdown renderer would alter.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| Inner content | Yes | Raw HTML content |

### Usage

```markdown
{{< rawhtml >}}
<div class="custom-widget">
  <iframe src="https://example.com/embed"></iframe>
</div>
{{< /rawhtml >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#raw-html).

---

## section-list

Renders a navigation list of site sections with chevron icons. Behaviour is consistent on any page (homepage, section pages, single pages).

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `sections` | No | Comma-separated section names (defaults to `site.Params.mainSections`) |
| `limit` | No | Number of recent items to show per section |

### Usage

```markdown
{{< section-list >}}
{{< section-list sections="blog,gallery" >}}
{{< section-list limit="3" >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#section-list).

---

## tagcloud

Renders terms from a Hugo taxonomy as a responsive weighted cloud. Term size represents its page count; each term receives a stable colour derived from its name and follows the theme's light or dark ambience.

The component is opt-in. Set `params.tagcloud.enabled: true` before placing the shortcode. When the setting is absent or false, the shortcode emits nothing and the theme does not load `tagcloud.css`.

### Parameters

| Parameter | Required | Default | Description |
|---|---|---|---|
| `taxonomy` | No | `tags` | Taxonomy key to render, such as `series`. An absent or unknown taxonomy emits nothing. |
| `sort` | No | `alpha` | `alpha` for alphabetical display or `count` for descending frequency. |
| `scale` | No | `log` | `log` or `linear` frequency scaling. Logarithmic scaling gives long-tail taxonomies more visible size variation. |
| `minCount` | No | `1` | Exclude terms used fewer than this many times. |
| `limit` | No | `0` | Keep the most-used N terms; `0` renders all eligible terms. |
| `counts` | No | `false` | Set to `true` to show each term's page count. |
| `pack` | No | `rows` | `rows`, `columns`, or `float` layout. Rows preserve ordinary reading order; columns pack vertically; float lets the largest terms lead the flow. |
| `floatTop` | No | `1` | In float packing, number of highest-ranked terms to float. |
| `leadTop` | No | `floatTop` | In float packing, number of highest-ranked terms moved to the start of document order. |
| `maxLines` | No | `2` | Maximum lines for long terms. Use `1` to prevent wrapping. |
| `wrapOver` | No | `15` | Apply the line-width cap only to terms longer than this character count. |

Term sizing and resting text opacity are intentionally not configurable per call. Set the site-wide floor, maximum ratio, and optional muted state with `params.tagcloud.base`, `params.tagcloud.multiplier`, and `params.tagcloud.opacity`; see [Configuration Reference](config.md#tag-cloud).

### Usage

```yaml
# hugo.yaml
params:
  tagcloud:
    enabled: true
    base: 0.75rem
    multiplier: 3
    opacity: 0.6
```

```markdown
{{< tagcloud >}}
{{< tagcloud taxonomy="series" sort="count" minCount="2" limit="20" counts="true" >}}
{{< tagcloud limit="24" pack="rows" >}}
```

### Homepage placement

The homepage offers two shortcode-aware positions. Both are configured in the
downstream site's `content/_index.md`; neither requires a template override.

To render the cloud immediately below the site menu and before the homepage
listing, put it in the page body after the closing frontmatter delimiter:

```markdown
---
title: Home
---

{{< tagcloud limit="24" pack="rows" >}}
```

To render the cloud after the homepage listing and pagination, put it in the
`footer_content` frontmatter field:

```yaml
---
title: Home
footer_content: |
  {{< tagcloud limit="24" pack="rows" >}}
---
```

`footer_content` is a homepage content region immediately before the site's
footer. It does not insert the cloud inside the shared footer and does not make
it appear on other page types.

Templates can reuse the same implementation directly:

```go-html-template
{{ partial "tagcloud.html" (dict "page" . "taxonomy" "tags" "limit" 24) }}
```

The enable switch applies to direct partial calls as well as the shortcode.

### Live Demo

The example site's homepage enables a 24-term row-packed tag cloud. Its selected
placement can be inspected in `exampleSite/content/_index.md`.

---

## img

Inline image for embedding within article text. Generates responsive thumbnails with WebP support, matching gallery behaviour.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `src` | Yes | Image filename (from page resources) |
| `alt` | Yes | Alt text for accessibility |
| `caption` | No | Caption text below image |
| `position` | No | Placement: `left`, `right` (default), or `center` |
| `width` | No | Width when floated - any CSS unit: `40%`, `15rem`, `30vw` (default: `40%`) |
| `link` | No | URL to wrap the image in a link |
| `noborder` | No | Set to `"true"` to remove the orange accent border |
| `blur` | No | Set to `"true"` for blurred caption background |
| `opacity` | No | Caption background opacity override |

### Usage

```markdown
{{< img src="photo.jpg" alt="A scenic view" >}}
{{< img src="portrait.jpg" alt="Author" caption="Photo by Jane" position="left" >}}
{{< img src="hero.jpg" alt="Banner" position="center" width="80%" >}}
{{< img src="cover.jpg" alt="Book cover" width="15rem" position="left" link="https://example.com/buy" >}}
{{< img src="mood.jpg" alt="Atmosphere" caption="Dreamy" blur="true" opacity="0.7" >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#img).

---

## gallery

Displays page image resources as a responsive gallery with lightbox support.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `exclude` | No | Comma-separated filenames to exclude from gallery |

### Metadata Priority

1. Frontmatter resource params (`title`, `caption`, `alt`, `weight`)
2. EXIF data (`DocumentName` -> title, `ImageDescription` -> caption)
3. Filename (fallback)

### Frontmatter Configuration

```yaml
resources:
  - src: "*.jpg"
    params:
      weight: 10
  - src: "special.jpg"
    params:
      title: "Custom Title"
      caption: "Custom caption"
```

### Usage

```markdown
{{< gallery >}}
{{< gallery exclude="hero.jpg" >}}
{{< gallery exclude="inline1.jpg,inline2.jpg" >}}
```

Use `exclude` when you have images displayed inline (via `img` shortcode) that you don't want duplicated in the gallery grid.

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#gallery).

---

## side-by-side

Wrapper shortcode that places inner content side by side on desktop. Collapses to stacked layout on mobile (below 48em). Commonly used to wrap two `img` shortcodes.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| Inner content | Yes | Content to arrange side by side (typically two shortcodes) |

### Usage

```markdown
{{< side-by-side >}}
{{< img src="cover-front.jpg" alt="Front cover" link="https://example.com" >}}
{{< img src="cover-back.jpg" alt="Back cover" link="https://example.com" >}}
{{< /side-by-side >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#side-by-side).

---

## Changelog

- **1.9** (2026-09-01): Documented body and `footer_content` homepage placement, including their rendering order and override-free downstream configuration.
- **1.8** (2026-08-25): #82 example-site polish. Documented the site-wide tag-cloud resting opacity control.
- **1.7** (2026-08-25): #83 documentation. Added the opt-in `tagcloud` shortcode, its template partial, parameters, sizing configuration, and example-site placement.
- **1.6** (2026-07-14): #76 documentation. Changed the block spoiler label to a full-width control with centred text.
- **1.5** (2026-07-14): #76 documentation. Documented inherited mask colour, configurable opacity, the upper-left block label, and revealed-text re-conceal behaviour.
- **1.4** (2026-07-14): Replaced filled spoiler masks with low-opacity symbol patterns, kept block labels visible before reveal, and clarified the concealed accessibility state.
- **1.3** (2026-07-14): Added the `spoiler` shortcode contract for inline and block conceal/reveal content, including validation, accessibility, and print behaviour.
- **1.2** (2026-05-12): #54 documentation. Rewrote the `quote` section to cover the structured-attribution path (`name`, `role`, `organization`, `photo`, `featured`) added in #54 item 1, including the photo resolution chain (page resource > site-root > absolute URL) and the intentional-warning demo. Added a new `stat / stats` section for the shortcodes added in #54 item 3. Corrected the `--pull-quote-mark` alpha values quoted in the styling notes (light 0.3, dark 0.6).
- **1.1** (2026-05-10): Clarified that `popquote` renders identical HTML to `details` and is retained as an alias for backward compatibility; new content should use `details`. Restored the `center` shortcode name in the ToC and H2 heading (previously OED-normalized to `centre` by sanitize because the identifier was not in backticks); the section title is now backticked so future sanitize passes will leave it alone, with an explicit `{#centre}` anchor attribute to keep the URL fragment stable across sanitize runs.
