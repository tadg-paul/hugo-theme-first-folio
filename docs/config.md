<!-- Version: 1.7 | Last updated: 2026-08-25 -->

# Configuration Reference

All configuration lives in `hugo.yaml` (or `hugo.toml` / `hugo.json`) under the `params` key. Every parameter has a sensible hardcoded default - a site works with no `params` block at all.

---

## Pre-release gate

Hides the site behind a passphrase prompt. The page renders fully but stays invisible until the visitor enters the correct passphrase. Not a security feature - the passphrase is checked client-side as a SHA-256 hash - just enough to keep a work-in-progress site out of search indexes and casual browsing.

```yaml
params:
  prereleaseKey: "your-passphrase-here"
```

When unset (or empty), no prompt is shown and the site behaves normally. When set, every page prompts on first visit; the result is stored in `localStorage` so the visitor is not re-prompted on subsequent navigation.

The visitor sees `prompt('This site is not yet public. Enter passphrase:')`. Wrong passphrase or cancel redirects to `about:blank`.

---

## Ambience (colour mode)

Controls the site's light/dark mode behaviour.

```yaml
params:
  ambience:
    default: auto       # auto | light | dark
    toggle: true        # show the user a light/dark toggle button
```

| Key | Default | Description |
|-----|---------|-------------|
| `default` | `auto` | Starting colour mode. `auto` follows the user's OS preference. `light` and `dark` force a fixed mode. |
| `toggle` | `true` | Whether to display a toggle button in the header. When `false`, the user cannot switch modes. |

**Note:** The previous `mode` parameter (`light`/`dark`/`auto`/`toggle`) is deprecated and ignored from v1.0.1. Use `ambience` instead.

---

## Spoiler masks

Controls the visibility of the symbol pattern used in place of concealed spoiler text.

```yaml
params:
  spoiler:
    opacity: 0.38
```

| Key | Default | Description |
|-----|---------|-------------|
| `opacity` | `0.38` | Opacity of concealed inline and block spoiler symbols. The symbols inherit the surrounding text colour, including downstream theme overrides and dark layouts. |

The setting changes opacity only. It does not assign a spoiler text colour.

---

## Review metadata

Controls the default denominator and horizontal image strip for article ratings:

```yaml
params:
  review:
    attribution:
      en: by
      fr: de
    rating:
      scale: 5
      image: /images/review-rating-stars.svg
```

| Key | Default | Description |
|---|---|---|
| `review.attribution.en` | `by` | English connector between a reviewed-item title and creator on review-enabled cards. Other language keys may be added using the same map. |
| `review.rating.scale` | `5` | Rating denominator when the page omits `review.rating.scale`. |
| `review.rating.image` | `/images/review-rating-stars.svg` | Horizontal strip used for the continuously clipped visual rating. |

Card attribution resolves the connector from the page language, site language, `en`, and finally the built-in `by`. Page-level rating scale wins over the site default. The visible authored score remains authoritative and accessible; the strip is decorative. See [Review metadata](reviews.md) for the frontmatter and item-type extension contract.

## Background image defaults

Controls how images appear behind text - on background-layout articles, masonry cards, carousel cards, and list views. Images are always placed on a dark backing. Lowering opacity lets the dark backing show through, darkening the image for text readability.

```yaml
params:
  bgImage:
    opacity: 0.7         # image opacity (0.0-1.0). Lower = darker.
    blur: 2px            # blur applied to the image
```

| Key | Default | Description |
|-----|---------|-------------|
| `opacity` | `0.7` | How transparent the image is. `1.0` = full image, `0.5` = half the dark backing shows through. |
| `blur` | `2px` | Gaussian blur on the image. Higher values soften the image for text readability. |

These are the base defaults. More specific contexts (cards, carousel, banner) fall back to these values when their own are not set.

---

## Card image settings

Controls images on masonry cards (the homepage grid).

```yaml
params:
  cardImage:
    opacity: 0.9         # card image opacity (falls back to bgImage.opacity)
    blur: 2px            # card image blur (falls back to bgImage.blur)
    showAuthor: true     # show author name on card meta
    showReview: false    # retain section; replace article author/date with review attribution
    title:
      wash:
        opacity: 0.2     # title wash tint strength
        blur: 5px        # title wash backdrop blur
        gradientV: "10%" # vertical gradient fade at edges
        gradientH: "10%" # horizontal gradient fade at edges
    description:
      wash:
        opacity: 0.35    # bottom scrim max opacity
        coverage: "50%"  # how much of the card the scrim covers, from the bottom up
        gradient: "50%"  # what % of the scrim area is fade (0% = hard edge, 100% = all fade)
        blur: 5px        # backdrop blur behind the scrim
```

| Key | Default | Description |
|-----|---------|-------------|
| `opacity` | inherits `bgImage.opacity` | Image opacity on cards. |
| `blur` | inherits `bgImage.blur` | Image blur on cards. |
| `showAuthor` | `true` | Show the author name in the card meta strip. |
| `showReview` | `false` | On review pages, retain the section/topic, omit article author/date, and add compact reviewed-item attribution. |

### Title wash

A soft-edged tinted layer behind the card title text. Uses gradient masking so the edges dissolve into the image rather than showing a hard box.

| Key | Default | Description |
|-----|---------|-------------|
| `title.wash.opacity` | `0.2` | Tint strength behind the title. |
| `title.wash.blur` | `5px` | Backdrop blur behind the title. |
| `title.wash.gradientV` | `10%` | How far the vertical fade extends inward from each edge. Higher = more fade. |
| `title.wash.gradientH` | `10%` | How far the horizontal fade extends inward from each edge. |

### Description wash

A bottom-up gradient scrim behind the card excerpt/description area.

| Key | Default | Description |
|-----|---------|-------------|
| `description.wash.opacity` | `0.35` | Maximum opacity at the bottom of the scrim. |
| `description.wash.coverage` | `50%` | What share of the card the scrim covers, measured from the bottom up. |
| `description.wash.gradient` | `50%` | What share of the scrim area is fade. `0%` = hard edge, `100%` = pure fade. |
| `description.wash.blur` | `5px` | Backdrop blur behind the scrim. |

---

## Gallery card image settings

Controls images on gallery/artwork masonry cards. These show the full image at 100% opacity with no blur (the image is the content), so the title and footer need stronger wash treatment.

```yaml
params:
  cardGalleryImage:
    title:
      wash:
        opacity: 0.2     # title wash tint strength
        blur: 5px        # title wash backdrop blur
        gradientV: "10%" # vertical gradient fade at edges
        gradientH: "10%" # horizontal gradient fade at edges
    description:
      wash:
        opacity: 0.35    # footer scrim max opacity
        coverage: "20%"  # how much of the card the scrim covers, from the bottom up
        gradient: "50%"  # what % of scrim area is fade
        blur: 5px        # backdrop blur behind the scrim
```

The same `title.wash` and `description.wash` keys as regular cards (see above) apply here. The defaults differ to suit image-dominant cards.

---

## Carousel settings

Controls the rotating hero card above the masonry grid on the homepage.

```yaml
params:
  carousel:
    interval: 6          # seconds between slides
    showAuthor: true     # show author name on carousel meta
    showReview: false    # retain section; replace article author/date with review attribution
    bgImage:
      opacity: 0.9       # carousel image opacity (falls back to bgImage.opacity)
      blur: 0px          # carousel image blur (falls back to bgImage.blur)
    title:
      wash:
        opacity: 0.2     # title wash tint strength
        blur: 5px        # title wash backdrop blur
        gradientV: "10%" # vertical gradient fade at edges
        gradientH: "10%" # horizontal gradient fade at edges
    description:
      wash:
        opacity: 0.3     # bottom scrim max opacity
        coverage: "35%"  # how much of the card the scrim covers, from the bottom up
        gradient: "50%"  # what % of scrim area is fade
        blur: 5px        # backdrop blur behind the scrim
```

| Key | Default | Description |
|-----|---------|-------------|
| `interval` | `6` | Seconds between automatic slide transitions. |
| `showAuthor` | `true` | Show the author name on carousel meta. |
| `showReview` | `false` | On review pages, retain the section/topic, omit article author/date, and add prominent reviewed-item attribution. |
| `bgImage.opacity` | inherits `bgImage.opacity` | Image opacity on carousel cards. |
| `bgImage.blur` | inherits `bgImage.blur` | Image blur on carousel cards. |
| `title.wash.opacity` | `0.2` | Tint strength behind the carousel title. |
| `title.wash.blur` | `5px` | Backdrop blur behind the carousel title. |
| `title.wash.gradientV` | `10%` | Vertical fade distance. |
| `title.wash.gradientH` | `10%` | Horizontal fade distance. |
| `description.wash.opacity` | `0.3` | Maximum opacity at the bottom of the scrim. |
| `description.wash.coverage` | `35%` | What share of the card the scrim covers, from the bottom up. |
| `description.wash.gradient` | `50%` | What share of the scrim area is fade. |
| `description.wash.blur` | `5px` | Backdrop blur behind the scrim. |

---

## Background-layout wash

Controls the tinted overlay behind text panels on background-layout article pages. This is the wash that makes body text readable over a full-page background image.

```yaml
params:
  wash:
    opacity: 0.25              # tint strength (0 = none, 1 = solid)
    blur: 0px                  # backdrop blur behind text panels
    gradient: "0% 10% 0% 10%"  # edge fade: left top right bottom
```

| Key | Default | Description |
|-----|---------|-------------|
| `opacity` | `0.25` | Dark tint strength behind text panels. |
| `blur` | `0px` | Backdrop blur applied to text panels. |
| `gradient` | `0% 10% 0% 10%` | How far the wash fades at each edge (left, top, right, bottom). Higher values = more fade. Accepts 1, 2, or 4 values. |

Per-page override: set `image.wash` in frontmatter (see [Frontmatter Reference](frontmatter.md)).

---

## Banner wash

Controls the tinted overlay behind the title on banner-layout pages.

```yaml
params:
  banner:
    wash:
      opacity: 0.3                 # wash tint strength
      blur: 2px                    # backdrop blur
      gradient: "20% 30% 20% 30%"  # edge fade: left top right bottom
```

| Key | Default | Description |
|-----|---------|-------------|
| `opacity` | `0.3` | Dark tint strength behind the banner title. |
| `blur` | `2px` | Backdrop blur behind the title area. |
| `gradient` | `20% 30% 20% 30%` | Edge fade distances. Banner uses heavier fade than background-layout to avoid a visible box over the image. |

Per-page override: set `image.banner_wash` in frontmatter (see [Frontmatter Reference](frontmatter.md)).

---

## Heading prefixes

Controls the decorative character or symbol displayed before headings in each context.

```yaml
params:
  headingPrefix:
    card: "#"            # masonry card titles (homepage and section grids)
    carousel: "#"        # carousel card titles (rotating hero)
    list: ""             # list-view items (sections with list_style: list)
    page: "#"            # article page title (banner, hero, etc.)
    sectionTitle: "#"    # section page titles (e.g. /blog/, /poetry/)
    h1: "#"              # body content: heading level 1
    h2: "##"             # body content: heading level 2
    h3: "###"            # body content: heading level 3
    h4: "####"           # body content: heading level 4
    h5: "#####"          # body content: heading level 5
    h6: "######"         # body content: heading level 6
```

Set any value to `""` to suppress the prefix entirely (no glyph, no spacing).

`h1`-`h6` apply to headings *inside* article body content (`# Heading 1`, `## Heading 2`, etc. in markdown). `page` applies to the article's main title (the page header).

Supports any text, Unicode character, or emoji.

---

## List bullet glyph

Controls the glyph rendered before each `<li>` in unordered lists across the entire site.

```yaml
params:
  listBullet: '•'   # default
```

Distinct from `headingPrefix.list`: that controls section-page list-view *item titles* (when a section uses `list_style: list`), whereas `listBullet` controls the bullet on every `<ul><li>` in body content.

Typographic note: the keyboard `*` (U+002A ASTERISK) is designed to sit at cap-height for footnote use and looks superscripted in proportional fonts. If an asterisk-shaped bullet is desired, prefer `✱` (U+2731 HEAVY ASTERISK), which is vertically centred to x-height.

Supports any text, Unicode character, or emoji.

---

## Print stylesheet

Print rendering is built in and requires no configuration. A dedicated stylesheet (`assets/css/print.css`) is loaded with `media="print"`, so it is only downloaded when the browser's print pipeline triggers.

Print output:

- Forces black text on white paper regardless of the active screen ambience (light/dark/auto).
- Hides site chrome and interactive widgets (navigation, footer, lightbox overlay, burger menu, ambience toggle, sidebars, pagination, contact-form widgets, carousel arrows, embedded video/iframes).
- Retains editorial content: article title, author, date, breadcrumb text, TOC, signposts (with their URL expanded inline), related-articles list, post tags, and the `section-list` shortcode output.
- Resizes content images responsively to print orientation: in portrait, no wider than 70% of page width and no taller than 30% of page height; in landscape, the constraints invert.
- Sets body text to Asap 12pt (weight 400; bold 800). Headings (Special Elite), pull-quotes (IM Fell Extended), and code (IosevkaCustom Extended) retain their screen typefaces.
- Force-opens any `<details>` collapsibles so their content is visible on paper.
- Expands external `http(s)` link URLs after the anchor text; internal anchors and relative links remain plain.
- Applies sensible page breaks: headings stay with the following content; callouts, pull-quotes, code blocks, tables, and figures are not split across pages.

No author action is required to opt in. Cmd+P (or "Save as PDF") on any page produces a reader-view-style output across every layout the theme supports.

---

## Read more button

Controls the "read more" indicator on masonry cards.

```yaml
params:
  readMore:
    type: icon                              # "icon" or "text"
    value: icons/chevron-right-duo-thick.svg # icon path or text string
    valueDark: ""                            # optional dark-mode variant icon
```

---

## Site logo

The site logo appears in the header. Two variants can be provided for light and dark modes.

```yaml
params:
  mainImage: /images/logo-light.svg       # logo for light mode
  mainImageDark: /images/logo-dark.svg    # logo for dark mode (optional)
```

| Key | Default | Description |
|-----|---------|-------------|
| `mainImage` | - | Path to the logo image. When set, replaces the text site title in the header. |
| `mainImageDark` | - | Alternate logo shown in dark mode. Falls back to `mainImage` if absent. |

When neither is set, the site title is rendered as text.

---

## Open Graph image

Default Open Graph image used in social media previews when a page does not provide its own `image.src`.

```yaml
params:
  og_image: /images/social-card.jpg
```

Per-page `image.src` (in frontmatter) takes precedence.

---

## Content width

Controls the maximum width of the page content (article body, masonry grid, etc.).

```yaml
params:
  contentMaxWidth: 80rem      # caps article body and grid width
```

Default `80rem`. Affects both article pages and section list pages uniformly.

---

## Grid configuration

Controls the responsive masonry grid layout.

```yaml
params:
  grid:
    sidebarWidth: 15rem
    sidebarWidthNarrow: 12rem
    gap: 1.5rem
    breakpoints:
      sm: 30em
      md: 48em
      lg: 64em
      xl: 80em
    columns:
      sm: 2
      md: 3
      lg: 4
      xl: 5
```

(`grid.contentMaxWidth` is still accepted as a legacy alias for `contentMaxWidth`.)

All values above are the defaults. Per-section overrides are supported via `grid` in section `_index.md` frontmatter.

---

## Cloudflare Stream (video)

Configuration for video embedding via Cloudflare Stream.

```yaml
params:
  cloudflareStream:
    customerCode: "abc123"         # Cloudflare customer subdomain code (required)
    videoDefaults:
      autoplay: false
      muted: true
      loop: false
      controls: true
      preload: false
      primarycolor: "#ff6600"
      letterboxcolor: "#000000"
```

| Key | Description |
|-----|-------------|
| `customerCode` | The customer subdomain code from Cloudflare Stream. Required for video playback. |
| `videoDefaults.*` | Site-wide defaults for video player behaviour. Per-page frontmatter overrides these. See [Frontmatter Reference](frontmatter.md#video) for all fields. |

---

## Table of contents

Default heading for the table of contents on pages where `toc: true` is set in frontmatter.

```yaml
params:
  tocTitle: "Contents"
```

Default `"Table of contents:"`. Override per-page by setting `tocTitle` (or a string value for `toc:`) in frontmatter.

---

## Social links

Displayed as icons in the footer.

```yaml
params:
  social:
    - name: GitHub
      icon: github                    # Feather icon (default)
      url: https://github.com/username
    - name: BlueSky
      icon: "simple:bluesky"          # Simple Icons (simple: prefix)
      url: https://bsky.app/profile/username
    - name: RSS
      icon: rss
      url: /index.xml
```

Icons can be Feather icons (bare name) or Simple Icons (prefixed with `simple:`).

---

## Footer text links

Plain-text links shown alongside the social icons in the footer (e.g. legal pages, contact, colophon).

```yaml
params:
  footerLinks:
    - name: About
      url: /about/
    - name: Colophon
      url: /colophon/
```

Rendered as `· name · name` between the copyright text and the social icons.

---

## Taxonomy listing filter

Controls which page types appear in tag and term listings.

```yaml
params:
  excludedTypes:
    - page
```

Default `["page"]` (pages of type `page` are excluded from tag/term listings, so standalone pages like `/about/` do not clutter tag pages). Override to include or exclude more types as needed.

---

## Taxonomy term-page presentation

Controls how the pages belonging to one taxonomy term—such as `/tags/theme/`—are presented.

```yaml
params:
  termListStyle: cards  # list | cards
```

| Key | Default | Description |
|---|---|---|
| `termListStyle` | `list` | Site-wide term-page presentation. `list` preserves the unpaginated title/date list; `cards` uses the theme masonry cards and site pager size. |

Only `list` and `cards` are supported. Unsupported values are ignored, so an invalid site value resolves to the backwards-compatible `list` default rather than activating cards. A term bundle can override the site value with `list_style`; see [Frontmatter Reference](frontmatter.md#taxonomy-term-bundles).

Both presentations render term-bundle content above the entries and apply `excludedTypes` before rendering. Cards filter before pagination, load the masonry initializer, and do not add carousel behavior. The `/tags/` taxonomy index and its existing tag cloud are unaffected.

---

## Tag cloud

Enables the reusable weighted taxonomy cloud. It is disabled by default, so upgrading the theme does not add markup or CSS to an existing site. Enabling it makes the component available; the cloud still appears only where a page calls the `tagcloud` shortcode or a template calls the `tagcloud.html` partial.

```yaml
params:
  tagcloud:
    enabled: true
    base: 0.75rem
    multiplier: 3
    opacity: 1
```

| Key | Default | Description |
|---|---|---|
| `enabled` | `false` | Enables tag-cloud rendering and loads its fingerprinted stylesheet. |
| `base` | `0.75rem` | CSS size of the least-used rendered term. Accepts any CSS length. |
| `multiplier` | `3` | Maximum term size as a multiple of `base`. |
| `opacity` | `1` | Text opacity at rest, from `0` to `1`. Hover and keyboard focus restore full opacity. |

Sizing and resting text opacity are site-wide so clouds remain visually consistent. Data selection, sorting, packing, and optional counts belong to each shortcode or partial call; see [Shortcodes Reference](shortcodes.md#tagcloud).

---

## Other settings

```yaml
params:
  browserTitle: "Custom Browser Tab Title"  # overrides site title in <title> only
  description: "Default meta description"   # fallback site-wide meta description
  dateFormat: "2 January 2006"              # Go date format for article pages
  dateFormatShort: "02/01/06"               # short format for cards
  subtitle: "A tagline for the site"
  useCDN: false                             # true to load icons from CDN
  mathjax: false                            # enable MathJax maths rendering
  katex: false                              # enable KaTeX maths rendering
  favicon: /favicon.ico                     # path to favicon

  mainSections:                             # sections shown on homepage
    - blog
    - gallery
    - poetry

  # Hugo's content model requires sections to be branch bundles
  # (directories with _index.md and child pages). A leaf bundle
  # (a single index.md with no children) is not a section - Hugo
  # does not expose it as one, so the homepage grid cannot find it.

  customCSS:                                # additional CSS files
    - css/custom.css
    - css/fonts.css

  customJS:                                 # additional JavaScript files
    - js/lightbox.js
```

| Key | Default | Description |
|-----|---------|-------------|
| `browserTitle` | site `title` | Overrides the site title in the `<title>` tag only. |
| `description` | - | Fallback meta description used when a page has no `description` of its own. |
| `dateFormat` | `2 January 2006` | Go date format for full article pages. |
| `dateFormatShort` | `:date_medium` | Short date format for cards and lists. |
| `subtitle` | - | Optional tagline rendered on the homepage. Supports Markdown. |
| `useCDN` | `false` | When `true`, load Simple Icons from jsDelivr CDN instead of local copy. |
| `mathjax` | `false` | Enable MathJax for maths rendering. |
| `katex` | `false` | Enable KaTeX for maths rendering. |
| `favicon` | - | Path to favicon. Supports `.png`, `.svg`, `.ico`. |
| `mainSections` | `["blog"]` | Sections to feature on the homepage masonry grid. |
| `customCSS` | - | Additional CSS files loaded after the theme styles. |
| `customJS` | - | Additional JavaScript files loaded in the head. |

---

## Menu

Top-level links are the default. Set `params.navigation.style` to `buttons` for a compact button treatment; sites that omit it retain the existing link presentation.

```yaml
params:
  navigation:
    style: buttons  # links | buttons

menu:
  main:
    - name: Home
      url: /
      weight: 1
    - identifier: explore
      name: Explore
      weight: 10
    - name: Blog
      url: /blog/
      parent: explore
      weight: 10
    - name: Gallery
      url: /gallery/
      parent: explore
      weight: 20
```

Lower weight appears first in navigation. A menu item with an `identifier` becomes a one-level disclosure menu when other entries name that identifier as their `parent`. The disclosure uses native `<details>` and `<summary>` controls, so it remains keyboard-accessible without JavaScript; opening one group closes any other open navigation group. Further nesting is not rendered.

---

## Full example

See `exampleSite/config/_default/hugo.yaml` for a complete working configuration.

---

## Changelog

- **1.7** (2026-08-25): #82 example-site polish. Added tag-cloud resting opacity and opt-in button navigation with one-level nested Hugo menus.
- **1.6** (2026-08-25): #84 documentation. Added the backwards-compatible list/cards contract for taxonomy term pages, including precedence, filtering, and pagination behavior.
- **1.5** (2026-08-25): #83 documentation. Added the opt-in tag-cloud activation and site-wide sizing contract.
- **1.4** (2026-07-18): #79 documentation. Added localized review-attribution connectors and clarified retained section metadata on review-enabled cards and carousel items.
- **1.3** (2026-07-14): #78 documentation. Added review rating defaults and the independent masonry/carousel review metadata controls.
- **1.2** (2026-07-14): #76 documentation. Added `params.spoiler.opacity` and documented inherited spoiler mask colour.
- **1.1** (2026-05-10): Added `prereleaseKey`, `mainImage` / `mainImageDark`, `og_image`, `footerLinks`, `excludedTypes`, `tocTitle`, site-level `description`, `carousel.showAuthor`. Corrected stale defaults across `cardImage`, `cardGalleryImage`, and `carousel` wash sections. Added missing wash sub-keys: `coverage` and `blur` on description washes, `gradientV` / `gradientH` on gallery card title wash.
- **1.0** (2026-05-05): Initial reference covering ambience, image/wash settings, heading prefixes, grid, and basic site settings.
