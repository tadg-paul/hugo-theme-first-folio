<!-- Version: 1.9 | Last updated: 2026-09-01 -->

# Frontmatter Reference

Every content page in Hugo uses YAML frontmatter (between `---` markers) to control how it is displayed. This reference covers all frontmatter fields supported by the First Folio theme.

---

## Basic fields

```yaml
---
title: "Page Title"
date: 2026-01-15
draft: true
description: "Short description for cards and metadata"
author: "Author Name"
tags:
  - tag1
  - tag2
---
```

| Field | Required | Description |
|-------|----------|-------------|
| `title` | yes | Page title. Displayed in headings, cards, browser tab. |
| `date` | yes | Publication date. Used for sorting and display. |
| `draft` | no | `true` hides the page from production builds. |
| `description` | no | Short text shown on masonry cards. Defaults to Hugo's auto-summary if not set. |
| `author` | no | Author name. Displayed on article pages and cards. |
| `tags` | no | List of tags for taxonomy. |

---

## Layout

Controls how the article page is rendered.

```yaml
layout: banner
```

| Value | Description |
|-------|-------------|
| `banner` | Full-width image banner with title overlaid. |
| `hero` | Large image above the article content. |
| `audio` | Theme-owned audio player layout for `type: audiobook` pages. |
| `featured` | Image floated beside content. |
| `background` | Image behind the entire article. Forces dark mode for the page. |
| `columns` | Two-column layout with image. |
| `featured-columns-left` | Image on left, content on right. |
| `featured-columns-right` | Content on left, image on right. |
| *(not set)* | If `image.src` is set but no layout is specified, defaults to `background`. Otherwise, a plain text article. |

## Review metadata

The presence of `review` adds reviewed-item metadata without changing `layout`:

```yaml
review:
  itemType: book
  title: "The Left Hand of Darkness"
  creator: "Ursula K. Le Guin"
  artwork:
    src: cover.jpg
    alt: "Book cover"
  rating:
    value: 4.9
    scale: 5
```

`review.title` is required. All other review fields are optional. `review.artwork.src` resolves within the page bundle; its `alt` falls back to the reviewed title. Rating scale precedence is page `review.rating.scale`, then `params.review.rating.scale`, then `5`. Values may be decimal but must remain between zero and the resolved scale.

Article `author` identifies the writer of the page; `review.creator` identifies the creator of the reviewed work. Article `image` controls the selected page layout; `review.artwork` is the optional reviewed-item graphic. `review.itemType` selects an optional presentation partial and is distinct from Hugo's top-level `type`.

Review metadata always precedes article prose. Background and image-free articles keep it below the breadcrumb; banner and hero articles place it below their principal media; featured articles begin the text flow with it beside the floated media; and column articles place it first in the text column.

When review metadata is enabled for masonry or carousel listings, the section/topic remains visible while the article author and publication date are omitted. The reviewed-item title is bold; the localized connector plus creator are italic and share one accent treatment with the title. A missing creator also omits the connector. Connector text is configured under `params.review.attribution`, not in page frontmatter.

See [Review metadata](reviews.md) for listing controls, extension partials, validation, and demonstrations.

---

## Audio

Audio pages use Hugo `type: audiobook` plus `layout: audio` when the page should render the theme-owned web player as the primary page experience. The detailed contract is documented in [Audiobook Pages and Podcast Feeds](audiobook.md).

```yaml
type: audiobook
layout: audio
outputs:
  - html
  - podcast
params:
  audiobook:
    id: about-time-part-2
    title: About Time, Part Two
    description: Audio chapters from About Time.
    language: en-GB
    explicit: false
    type: serial
    itemTerm: Chapter
    itemTermPlural: Chapters
    startNumber: 13
    chapters:
      - id: chapter-13
        title: Telling the Truth
        displayNumber: 13
        src: ch13.m4a
        mimeType: audio/mp4
        byteLength: 10512465
```

| Field | Description |
|-------|-------------|
| `params.audiobook.type` | Feed ordering type: `episodic` by default, or `serial` for audiobook-style sequential works. |
| `params.audiobook.itemTerm` | Singular fallback label term, such as `Episode`, `Chapter`, `Track`, or `Stanza`. |
| `params.audiobook.itemTermPlural` | Plural label for grouped list labelling. Defaults to a simple `s` suffix. |
| `params.audiobook.startNumber` | First generated serial item number. Useful when a split work starts at `Chapter 13` rather than `Chapter 1`. |
| `params.audiobook.chapters[].displayNumber` | Item-level generated label number or string, such as `13`, `A`, or `Bonus`. |
| `params.audiobook.chapters[].episode` | Podcast episode number used for episodic generated labels when `displayNumber` is absent. |
| `params.audiobook.chapters[].label` | Full visible item label. Takes precedence over generated labels and numeric helpers. |
| `params.audiobook.chapters[].role` | `section` or `part` marks non-numbered serial items that do not consume generated chapter numbers. |

Generated fallback labels use the precedence documented in [Audiobook Pages and Podcast Feeds](audiobook.md#optional-metadata): full `label`, generated media `label`, `displayNumber`, `episode`, then the serial running number from `startNumber`.

---

## Image

Controls the article's featured image. Article image presentation fields apply to article layouts; card-specific fields control masonry presentations on the homepage and list pages.

```yaml
image:
  src: hero.jpg
  alt: "Descriptive text for accessibility"
  caption: "Photo credit or description"
  opacity: 0.7              # article layouts only
  blur: 3px
  position: "center top"
  size: cover
```

| Field | Default | Description |
|-------|---------|-------------|
| `src` | - | Image filename. Must be in the same page bundle directory. |
| `alt` | title | Alt text for accessibility. Falls back to caption, then title. |
| `caption` | - | Caption displayed below the image (banner and hero layouts). |
| `opacity` | site default | Article-layout image opacity for this page. `1.0` = full image, lower = darker. Does not change masonry cards. |
| `blur` | site default | Blur override for this page. |
| `position` | `center center` | CSS `object-position` / `background-position` for image cropping. |
| `size` | `cover` | CSS `background-size` for background layout. |

### Card-specific image overrides

Different images or crops can be specified for cards and carousel:

```yaml
image:
  src: hero.jpg              # used on the article page
  card_src: card-crop.jpg    # used on masonry cards instead
  card_position: center top  # crop position on cards
  card_opacity: 0.8          # opacity in masonry presentations
  carousel_src: wide.jpg     # used on carousel cards instead
  carousel_position: center  # crop position on carousel
```

| Field | Description |
|-------|-------------|
| `card_src` | Alternative image for masonry cards. Falls back to `src`. |
| `card_position` | CSS position for the card image. Falls back to `position`. |
| `card_opacity` | Image opacity for masonry cards. Falls back to `params.cardImage.opacity`, then `params.bgImage.opacity`. For carousel entries, this applies only when the entry uses the narrow masonry presentation. |
| `carousel_src` | Alternative image for carousel cards. Falls back to `card_src`, then `src`. |
| `carousel_position` | CSS position for the carousel image. Falls back to `card_position`, then `position`. |

---

## Wash overrides

Per-page overrides for the wash (tinted overlay behind text). These override the site-level `params.wash` and `params.banner.wash` settings.

### Background-layout wash

```yaml
image:
  wash:
    opacity: 0.4
    blur: 2px
    gradient: "10% 20% 10% 20%"
```

### Banner-layout wash

```yaml
image:
  banner_wash:
    opacity: 0.4
    blur: 3px
    gradient: "25% 35% 25% 35%"
```

---

## Video

Embeds a Cloudflare Stream video in hero or columns layouts.

```yaml
video:
  id: "abc123def456"
  caption: "Video description"
  autoplay: true
  muted: true
  loop: true
  controls: true
  preload: true
  starttime: 5
  primarycolor: "#ff6600"
  letterboxcolor: "#000000"
  poster_image: "thumbnail.jpg"
  width: 1920
  height: 1080
```

| Field | Default | Description |
|-------|---------|-------------|
| `id` | - | Cloudflare Stream video ID. Required. |
| `caption` | - | Caption displayed below the video. |
| `autoplay` | site default | Auto-play on page load. |
| `muted` | site default | Start with audio muted. |
| `loop` | site default | Loop playback continuously. |
| `controls` | site default | Show player controls. |
| `preload` | site default | Preload video data before play. |
| `starttime` | - | Start playback at this time (seconds). |
| `primarycolor` | - | Player UI primary colour. |
| `letterboxcolor` | - | Colour of letterbox bars. |
| `poster_image` | - | Custom poster/thumbnail. Can be a filename (relative to page bundle), a site-root path (`/images/poster.jpg`), or a full URL. |
| `width` | auto-detected | Video width for aspect ratio calculation. |
| `height` | auto-detected | Video height for aspect ratio calculation. |

**Precedence:** Page frontmatter overrides site-level `cloudflareStream.videoDefaults`. Omitting a field falls through to the site default; omitting both lets Cloudflare apply its own default.

**Aspect ratio** is resolved in order: frontmatter `width`/`height` > `data/video-inventory.yaml` > Cloudflare Stream API (requires env vars) > 16:9 CSS fallback.

**Note:** Video is not supported in `banner` or `background` layouts. Hugo emits a warning if attempted.

---

## Homepage controls

### Homepage content placement

The root homepage bundle, `content/_index.md`, has two shortcode-aware content
positions:

| Position | Source | Rendering order |
|----------|--------|-----------------|
| Top content | Body after the frontmatter | Immediately below the site menu and before the homepage listing |
| Footer content | `footer_content` frontmatter | After the homepage listing and pagination, immediately before the site footer |

Use the page body for a prominent tag cloud below the menu:

```markdown
---
title: Home
---

{{< tagcloud limit="24" pack="rows" >}}
```

Use `footer_content` for the same component below the homepage listing:

```yaml
---
title: Home
footer_content: |
  {{< tagcloud limit="24" pack="rows" >}}
---
```

Both positions accept Markdown and shortcodes. They are homepage regions, not
the shared header or footer partials, and require no downstream template
override. The tag cloud must also be enabled through
`params.tagcloud.enabled`; see the [tag-cloud shortcode reference](shortcodes.md#tagcloud).

### Pin

Pins a page to the top of the homepage masonry grid for its section.

```yaml
pin: 10
```

Lower numbers appear first. Pages without `pin` appear after all pinned pages, sorted by date.

### Carousel

Adds a page to the rotating carousel above the masonry grid.

```yaml
carousel: 1
```

Lower numbers appear first. A page can have both `carousel` and `pin` - it appears in the carousel and is excluded from the grid to avoid duplication.

---

## Display options

```yaml
hideDate: true
hideAuthor: true
toc: true
tocTitle: "Contents"
tldr: "A one-sentence summary shown at the top of the article."
contentLang: ga
linkTitle: "Short Label"
```

| Field | Default | Description |
|-------|---------|-------------|
| `hideDate` | `false` | Hides the publication date on cards and article pages. |
| `hideAuthor` | `false` | Hides the author name. |
| `toc` | `false` | Enables a table of contents sidebar. Set to `true` or a string (used as the ToC heading). |
| `tocTitle` | `"Contents"` | Custom heading for the table of contents. |
| `tldr` | - | Summary box displayed at the top of the article. |
| `contentLang` | - | Language code (e.g. `ga` for Irish). Applies language-specific font styling. |
| `linkTitle` | `title` | Short label shown in auto-generated navigation contexts: sidebar, breadcrumb (both top-section and sub-section segments), and related-articles strips. The page's own `<h1>` and `<title>` tag continue to use `title`. Use this when a long SEO-oriented `title` would clutter a sidebar or breadcrumb. Hugo built-in (`.LinkTitle` falls back to `.Title` when unset, so pages without `linkTitle` are unaffected). |

---

## Signpost (call to action)

Displays a prominent call-to-action link on the article page.

```yaml
signpost:
  text: "BUY THE BOOK"
  url: "https://example.com/book"

signpost_footer:
  text: "VIEW ON GITHUB"
  url: "https://github.com/example"
```

`signpost` appears near the top of the article. `signpost_footer` appears at the bottom.

Also rendered, in the same positions, on **section index pages** (`_index.md`) that use `list_style: prose` (see [Section index fields](#section-index-fields)). The signposts bracket the `.Content` body the same way as on article pages.

---

## Display title

Overrides the rendered title without changing the page's metadata title.

```yaml
displayTitle: "A *Formatted* Title"
```

Supports inline Markdown formatting (bold, italic).

---

## Breadcrumb

Controls breadcrumb navigation on the article page.

```yaml
breadcrumb: false
```

Set to `false` to hide breadcrumbs on a specific page. Breadcrumbs are shown by default.

---

## Gallery mode

For image collection pages (e.g. photography galleries).

```yaml
gallery: true
featured_image: "hero.jpg"
```

| Field | Description |
|-------|-------------|
| `gallery` | `true` enables gallery card rendering (image-dominant with text overlay). |
| `featured_image` | The image from the page bundle to use as the card thumbnail. |

---

## Section index fields

These fields go in `_index.md` files (branch bundles) that define sections.

```yaml
---
title: Photography
description: "A collection of images"
list_style: cards
list_recursive: true
sidebar: true
grid:
  columns:
    xl: 6
---
```

| Field | Default | Description |
|-------|---------|-------------|
| `list_style` | `cards` | How pages in this section are listed. Options: `cards` (masonry grid), `list` (list view), `gallery` (gallery grid), `prose` (free-form landing page --- see below). |
| `list_recursive` | `false` | Include pages from sub-sections in the listing. |
| `sidebar` | `false` | Show a sidebar on the section listing page. |
| `grid` | site default | Per-section grid configuration override (see [Configuration Reference](config.md#grid-configuration)). |

### `list_style: prose`

A free-form landing-page layout. The page renders only its `.Content` body --- no carousel, no masonry grid, no pagination. Optional `signpost` and `signpost_footer` frontmatter render above and below the body (same partials as on article pages). Authors compose the page with shortcodes inside the body --- testimonials via `quote`, stats rows via `stats`, hero copy as prose.

Applies to both the root homepage (`content/_index.md`) and any section index page (`content/<section>/_index.md`).

```yaml
---
title: "About"
list_style: prose
signpost:
  text: "GET IN TOUCH"
  url: /contact/
signpost_footer:
  text: "READ THE JOURNAL"
  url: /journal/
---

A consultancy practice. Three decades across financial services and the public sector.

{{< stats >}}
{{< stat number="20" suffix="+" label="Years experience" >}}
{{< stat number="80" label="Countries advised" >}}
{{< /stats >}}

## What clients say

{{< quote name="A. Client" role="Director" organization="Example Co" featured=true >}}
Clarity where there was none.
{{< /quote >}}
```

See `exampleSite/content/profile/_index.md` for a live demo.

---

## Taxonomy term bundles

A taxonomy term can have its own branch bundle—for example, `content/tags/theme/_index.md`. Its body content appears above the term's entries, and `list_style` can override the site-wide `params.termListStyle` presentation:

```yaml
---
title: Theme
description: Articles about using and extending the theme.
list_style: summary  # list | summary | cards
---

Articles about using and extending the theme.
```

Resolution uses the first supported value: term `list_style`, then site `termListStyle`, then `list`. An unsupported term value is ignored and falls through to the site setting; an unsupported site value falls through to `list`.

`list` preserves the unpaginated title/date presentation and draft labels. `summary` reuses the section list rows with article metadata, originating section, description or first-paragraph summary, optional background image, and site-sized pagination. `cards` uses the existing masonry card partial, follows the site pager size, and loads only the masonry initializer. All modes filter `params.excludedTypes` before rendering or pagination. Term pages do not support the section-only `gallery`, `prose`, or carousel modes. This setting changes neither the taxonomy index at `/tags/` nor tag links rendered elsewhere.

---

## Build control

```yaml
_build:
  list: false
```

Setting `_build.list: false` excludes a page from section listings and the homepage grid while keeping the page itself accessible via its URL. Useful for pages linked only from the carousel or navigation.

---

## Full example

```yaml
---
title: "The Cartographer"
date: 2025-11-10
description: "A poem about maps and the places they miss."
tags:
  - poetry
  - maps
author: "Author Name"
layout: hero
pin: 80
carousel: 1
image:
  src: hero.jpg
  alt: "Antique map with compass rose"
  caption: "Where the roads used to run"
  card_position: center top
signpost:
  text: "READ THE COLLECTION"
  url: /poetry/
toc: true
---
```

---

## Changelog

- **1.9** (2026-09-01): Documented the homepage body and `footer_content` shortcode positions and their rendering order.
- **1.8** (2026-08-26): #82/#84 follow-up. Added the `summary` term-bundle override and documented its section-style rows and pagination.
- **1.7** (2026-08-25): #84 documentation. Added taxonomy term-bundle content and the `list_style` list/cards override contract.
- **1.6** (2026-07-18): Clarified review-enabled card and carousel metadata, semantic attribution styling, and site-level connector localization.
- **1.5** (2026-07-17): Clarified media-aware review placement across banner, hero, featured, background, image-free, and column presentations.
- **1.4** (2026-07-14): #78 documentation. Added layout-independent reviewed-item metadata, artwork, continuous ratings, item types, and list/card presentation behaviour.
- **1.3** (2026-07-14): #77 documentation. Added `image.card_opacity` and clarified that `image.opacity` applies to article layouts rather than masonry cards.
- **1.2** (2026-07-09): #75 documentation. Added `layout: audio` to the layout table and documented audio item numbering fields including `startNumber`, `displayNumber`, `episode`, and `label` precedence.
- **1.1** (2026-05-12): #54 documentation. Added `linkTitle` to the Display Options section (#54 item 4 --- short label for sidebar / breadcrumb / related-articles nav contexts; Hugo built-in falls back to `title` when unset). Added `list_style: prose` to the Section Index Fields section with a dedicated subsection and full example (#54 item 2 --- free-form landing-page layout). Noted that `signpost` and `signpost_footer` also render on `list_style: prose` section pages, bracketing `.Content` the same way as on article pages.
- **1.0** (2026-05-05): Initial frontmatter reference covering basic fields, layouts, image/video, homepage controls, signpost, display title, breadcrumb, gallery, section-index, and build control.
