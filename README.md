# First Folio

[Live demo](https://demo.theme.tadg.ie) | [In production](https://tadg.ie) | [Shortcode reference](docs/shortcodes.md) | [Review metadata](docs/reviews.md) | [Audiobook pages](docs/audiobook.md)

## What this is

First Folio is a Hugo theme built to run a single site that does many different things well. It grew out of a practical problem: four separate websites - a poetry collection, an art gallery, a tech blog, and a personal site - that needed to become one, without any section feeling like a second-class citizen.

The result is a theme that handles image galleries with EXIF metadata and lightbox, long-form articles with six distinct layout options, poetry with preserved line breaks, play scripts with dialogue and stage directions, recipe cards, technical documentation with table of contents, and video streaming via Cloudflare Stream - all from the same installation, all looking like they belong together.

## What it does well

**Content variety without compromise.** Poetry pages preserve every line break. Gallery pages read EXIF metadata from your images. Blog posts get hero banners or background images. Play scripts render character names in small caps with stage directions in accent colour. Each content type has its own card style on the masonry grid, but shares the same responsive framework.

**Article layouts.** Six layout options controlled by a single frontmatter field: full-width banner with title overlay, hero image below title, side-by-side columns (image left or right), inline featured image, and background image with configurable blur and opacity. Plus a clean text-only default.

**Review metadata.** A layout-independent review block identifies books, games, music, film, or other reviewed items before article prose. Its position adapts to the selected presentation so that it follows banner or hero media, begins the text flow beside featured media, and occupies the text column in column layouts. Optional artwork and continuously filled ratings support author-selected scales without conflating the reviewed creator with the article author.

**The masonry grid.** A hybrid CSS Grid and JavaScript approach that adapts to viewport width using em-based breakpoints (WCAG 2.1 compliant - respects browser font size). Configurable columns, gaps, and breakpoints. A carousel card rotates featured content above the grid. Pin values control homepage ordering.

**21 shortcodes.** Callout boxes, collapsible details, block quotes with decorative marks, expandable quotes, poetry formatting, play dialogue and stage directions, an opt-in weighted taxonomy cloud, inline images with responsive thumbnails and WebP, image galleries, side-by-side layouts, video embeds, contact forms with CAPTCHA, and more. Each is documented in the [shortcode reference](docs/shortcodes.md), with examples on the [demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/).

**Taxonomy browsing.** Term pages preserve their unpaginated title/date list by default, or can opt into paginated section-style summary rows or masonry cards site-wide or per term. Term-bundle content, excluded-type filtering, precedence, and supported values are documented in the [configuration](docs/config.md#taxonomy-term-page-presentation) and [frontmatter](docs/frontmatter.md#taxonomy-term-bundles) references.

**Navigation and CTAs.** Breadcrumb trails with section hierarchy, author, and date. Signpost bars for calls to action - configurable per page or cascaded across entire sections. Table of contents as a sticky sidebar on desktop, collapsible on mobile.

**Responsive throughout.** All breakpoints in em units. Sidebar collapses to a toggle on mobile. Masonry grid adjusts column count. Images serve responsive srcsets with WebP. Galleries, carousels, and layouts all adapt.

## New to Hugo?

If this is your first Hugo site, start with the [Quickstart guide](docs/quickstart-new-website.md). It walks through installation, creating content, previewing locally, and deploying - with links to the official Hugo docs for anything beyond the basics.

For non-developers who need to edit content on an existing site, see the [Content editing guide](docs/content-editing-guide.md) - covers Markdown, front matter, images, and editing through GitHub's web interface.

## Quick Start

1. Add the theme to your Hugo site:
   ```bash
   git submodule add https://github.com/tigger-developer/hugo-theme-first-folio.git themes/first-folio
   ```

   Or clone directly:
   ```bash
   git clone https://github.com/tigger-developer/hugo-theme-first-folio.git themes/first-folio
   ```

2. Update your `hugo.yaml`:
   ```yaml
   theme: first-folio
   ```

3. Create content in sections matching your site structure (e.g., `blog/`, `portfolio/`, `gallery/`)

4. Run Hugo:
   ```bash
   hugo server
   ```

## Compatibility

First Folio targets Hugo Extended 0.155.0 or newer. The theme is published as the Hugo module `github.com/tigger-developer/hugo-theme-first-folio`, with the live example site at https://demo.theme.tadg.ie.

The repository includes portal metadata in `theme.toml` and preview assets under `images/` for submission to the public Hugo theme directory.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Page Templates](#page-templates)
3. [Article Layouts](#article-layouts)
4. [Masonry Grid System](#masonry-grid-system)
5. [Carousel Card](#carousel-card)
6. [Section Display Configuration](#section-display-configuration)
7. [Pagination](#pagination)
8. [Section-Specific Behaviour](#section-specific-behaviour)
9. [Gallery System (Artwork)](#gallery-system-artwork)
10. [Shortcodes](#shortcodes)
11. [Configuration Options](#configuration-options)
12. [Index Files and Page Bundles](#index-files-and-page-bundles)
13. [Frontmatter Reference](#frontmatter-reference)
14. [CSS Customization](#css-customization)
15. [Social Icons (Footer)](#social-icons-footer)
16. [JavaScript Components](#javascript-components)
17. [Scripts](#scripts)
18. [Troubleshooting](#troubleshooting)

---

## Architecture Overview

The theme provides a complete set of templates:

```
themes/first-folio/
├── layouts/
│   ├── index.html             # Homepage template
│   ├── _default/
│   │   ├── baseof.html        # Base template wrapper
│   │   ├── single.html        # Article/page template
│   │   └── list.html          # Section list template
│   ├── artwork/
│   │   └── single.html        # Individual gallery page
│   ├── partials/
│   │   ├── grid-config.html   # Responsive grid CSS from params
│   │   ├── masonry-grid.html  # Shared masonry grid component
│   │   ├── carousel-card.html # Hero-sized rotating carousel card
│   │   ├── list-view.html     # Simple list layout
│   │   ├── gallery-section.html # Gallery grid layout
│   │   ├── pagination.html    # Pagination controls
│   │   └── ...
│   └── shortcodes/
│       └── ...
├── assets/
│   └── css/
│       ├── custom.css         # Theme customizations
│       ├── fonts.css          # Font definitions
│       └── lightbox.css       # Lightbox styling
├── scripts/
│   └── pins.pl               # List pinned content
└── static/
    └── js/
        ├── masonry-init.js    # Masonry layout
        ├── carousel.js        # Carousel card rotation
        ├── lightbox.js        # Image lightbox
        └── burger-menu.js     # Mobile nav
```

---

## Page Templates

### Homepage (`layouts/index.html`)

The homepage displays a masonry grid with pinned/featured content from each section.

**Pin Logic:**
1. For each section defined in `mainSections`, find pages with `pin` frontmatter
2. Select the page with the lowest `pin` value (e.g., `pin: 1` beats `pin: 10`)
3. If no pinned page exists, use the most recent page from that section
4. Pinned pages appear first in the grid, followed by remaining pages by date

**Structure:**
```html
<main class="home">
  <!-- Optional subtitle from site params -->
  <!-- Optional homepage content from _index.md -->
  <!-- Masonry grid with pinned + recent content -->
  <!-- Pagination for remaining content -->
</main>
```

### List Pages (`layouts/_default/list.html`)

Used for section index pages (`/poetry/`, `/blog/`, etc.) and taxonomy pages.

**Features:**
- Page header with title and optional description
- Optional content from `_index.md`
- Configurable display style (cards, list, gallery)
- Optional sidebar for subsection navigation
- Pagination with per-section override

### Single Pages (`layouts/_default/single.html`)

The article template supports multiple layout modes selected via the `layout` frontmatter field.

---

## Article Layouts

The `layout` frontmatter field controls how a single article is displayed. Available layouts:

### `banner`
Full-width banner image at the top with title overlay.

```yaml
layout: banner
image:
  src: my-image.jpg
  dark: true  # Optional: adds dark overlay for light text
  caption: "Photo by Example"  # Optional
```

### `hero`
Large featured image below the title.

```yaml
layout: hero
image:
  src: hero-image.jpg
  alt: "Description"
  caption: "Optional caption"
```

### `columns` / `featured-columns-left`
Two-column layout with image on the left, text on the right.

```yaml
layout: columns
image:
  src: side-image.jpg
```

### `featured-columns-right`
Two-column layout with text on the left, image on the right.

### `featured`
Inline featured image within the content flow.

### `background` (default when image present)
Background image behind the content with blur and opacity.

```yaml
layout: background
image:
  src: bg-image.jpg
  opacity: 0.3      # Override default
  blur: 10px        # Override default
  dark: true        # Dark context (default)
```

**Mode-independent rendering:** Background layout pages are rendered independently of the site's light/dark theme mode. The image fills the viewport - the site theme is irrelevant.

- `image.dark: true` (or not set) - dark context: dark page background, light text, dark wash
- `image.dark: false` - light context: light page background, dark text, light wash

When a background layout page is displayed, the entire page (navigation, TOC, sidebar, footer) is forced into the matching theme. The user's theme preference is restored on navigation to the next page. The theme toggle button is hidden on these pages.

**Wash:** A configurable tinted layer behind text panels (article content, TOC sidebar, related articles) that boosts legibility over background images. The wash fades at the edges using a gradient mask - no hard borders. See [Wash Configuration](#wash-configuration).

### No Layout (text-only)
When no `layout` is specified and no image exists, a simple text layout is used.

---

## Masonry Grid System

The masonry grid (`layouts/partials/masonry-grid.html`) is the core component for displaying content on homepages and list pages.

### How It Works

**Hybrid CSS Grid + JavaScript Approach:**

1. **CSS Grid** provides the responsive column structure:
   ```css
   grid-template-columns: repeat(auto-fill, minmax(17.5rem, 1fr));
   ```

2. **JavaScript** (`static/js/masonry-init.js`) adjusts vertical positioning to fill gaps using a shortest-column algorithm.

**Accessibility Note:** Both CSS media queries and JavaScript breakpoints use relative units (`em`/`rem`) rather than fixed pixels. This ensures the layout adapts when users change their browser's default font size (WCAG 2.1 Success Criterion 1.4.4).

### Responsive Breakpoints

Breakpoints and column counts are configurable via `params.grid` in `hugo.yaml` (see [Grid Configuration](#grid-configuration)). Defaults shown below:

| Viewport | Columns | With Sidebar |
|----------|---------|--------------|
| ≤ 48em   | 2       | Sidebar collapses to `<details>` toggle |
| 48-64em  | 3       | 2 + narrow sidebar = 3 total |
| 64-80em  | 4       | 3 + sidebar = 4 total |
| ≥ 80em   | 5       | 4 + sidebar = 5 total |

**Constraint:** Min 2, max 5 columns total (including sidebar when present).

Per-section overrides are supported via `grid` frontmatter in `_index.md` files. Page-level values override site-level defaults.

### Card Styles

Masonry cards have two layouts:

| Type     | When Used                    | Elements Shown                        |
|----------|------------------------------|---------------------------------------|
| Gallery  | `gallery: true` in frontmatter | Image-dominant with frosted glass text overlay |
| Default  | All other content             | Title, excerpt, date, section label, read-more link |

**CSS customization:** All cards include a `.masonry-{section}` class (e.g., `.masonry-blog`, `.masonry-gallery`) for section-specific styling via custom CSS. The theme itself treats all non-gallery content identically, but site owners can add custom styles for their specific sections.

### Background Images on Cards and List Items

Both masonry cards and list-view items display a background image when `image.src` is set in frontmatter (or `featured_image` / first image resource for gallery pages). The image is rendered with blur and opacity from configuration.

**Three independent scopes control background image treatment:**

| Config key | Controls | Fallback |
|---|---|---|
| `params.bgImage` | Article pages (background layout), list-view items | Hardcoded defaults |
| `params.cardImage` | Masonry cards | `params.bgImage` |
| `params.carousel.bgImage` | Carousel cards | Hardcoded defaults |

Each scope supports three keys:

| Key | Meaning | Used when |
|---|---|---|
| `opacity` | Image opacity for **light images** | `image.dark: false` or `image.dark` not set |
| `opacityDark` | Image opacity for **dark images** | `image.dark: true` |
| `blur` | Blur radius applied to the background image | Always |

**Important:** `opacity` and `opacityDark` refer to the **image's declared lightness** (the `image.dark` frontmatter field), not the site's theme mode (light/dark). A dark image typically benefits from a higher opacity to let its mood come through, while a light image needs lower opacity to avoid washing out the text. Per-page overrides via `image.opacity` in frontmatter take precedence over both config values.

On cards with background images (`.has-image`), the category and date metadata gets a frosted glass pill (`backdrop-filter: blur(8px)` with a semi-transparent background) to ensure legibility over the image. Cards without images are unaffected.

Cards also carry `image-dark` or `image-light` CSS classes based on the `image.dark` frontmatter field. On carousel cards, this drives text colour (dark images get white text, light images get dark text). On regular masonry cards, the bg image is faint so text uses theme-mode colours.

### Usage in Templates

```go-html-template
{{ partial "masonry-grid.html" (dict
    "pages" .Pages
    "showSection" true
    "Site" .Site
) }}
```

---

## Carousel Card

The carousel card is a hero-sized masonry card that sits above the masonry grid, rotating through featured content. It only appears in masonry/cards view (not list or gallery modes).

### Enabling

Add `carousel: [integer]` to any page's frontmatter. Pages are displayed lowest number first and rotate in order. Carousel pages are excluded from the masonry grid below.

```yaml
---
title: "Featured Article"
carousel: 10
image:
  src: hero.jpg
  dark: false
---
```

### Visual Treatment

- **Height:** 24rem (collapses to regular masonry card at the `sm` breakpoint)
- **Title:** `h2` with frosted glass background, bold
- **Meta strip:** Section name and date with frosted glass background
- **Excerpt:** Bottom-aligned with a dark gradient scrim for legibility
- **Chevron:** Right-aligned at bottom, larger than standard masonry cards
- **Background image:** Uses carousel-specific opacity/blur (see Configuration below)
- **Text colour:** Driven by `image.dark` - dark images get white text, light images get dark text (title and excerpt only; meta uses theme-mode colours via frosted glass)

### Behaviour

- **Auto-rotation:** Advances every N seconds (configurable). Pauses on mouse hover.
- **Navigation:** Translucent prev/next arrows appear on hover near the left/right edges. Keyboard left/right arrows when focused.
- **Single item:** No transition or arrows - static hero card.
- **Crossfade:** Smooth opacity transition between slides.

### Responsive Collapse

At the `sm` breakpoint (30em), carousel items collapse into regular masonry cards in the grid. Background image switches to masonry card opacity/blur, text reverts to theme-mode colours, and the frosted glass / gradient scrim are removed.

### Image Overrides

Carousel cards support per-context image source and position overrides via frontmatter:

```yaml
image:
  src: cover.jpg                    # default for article page
  card_src: cover-square.jpg        # override for masonry cards
  carousel_src: cover-wide.jpg      # override for carousel
  position: center center           # default for all contexts
  card_position: top center         # override for masonry cards
  carousel_position: 25% center     # override for carousel
```

**Fallback chain for source:** `carousel_src` > `card_src` > `src`
**Fallback chain for position:** `carousel_position` > `card_position` > `position` > `center center`

Position values use CSS `background-position` syntax: `horizontal vertical`. Keywords (`top`, `center`, `bottom`, `left`, `right`) or percentages (e.g. `30% 20%` - the point at 30% across and 20% down in the image aligns with the same point in the container).

### Configuration

```yaml
params:
  carousel:
    interval: 6            # seconds between slides
    bgImage:
      opacity: 0.8         # light images (dark: false)
      opacityDark: 0.9     # dark images (dark: true)
      blur: 0px
```

---

## Wash Configuration

The wash is a tinted layer behind text panels (article content, TOC sidebar, related articles) on background-layout pages. It boosts legibility by darkening or lightening the area behind text without hard borders - the wash fades at the edges using a four-sided gradient mask.

### Site-level configuration

```yaml
params:
  wash:
    opacity: 0.4                  # tint strength (0 = none, 1 = solid)
    blur: 3px                     # backdrop blur behind text panels
    gradient: 1rem 2rem 1rem 1rem # edge fade: left top right bottom
```

| Key | Default | Description |
|---|---|---|
| `opacity` | `0.25` | Alpha of the wash tint. `0` disables the wash. |
| `blur` | `0px` | Backdrop blur radius - softens image detail behind text. |
| `gradient` | `0% 10% 0% 10%` | How far the wash fades inward from each edge (left top right bottom). Accepts any CSS length: `%`, `rem`, `px`. |

**Gradient shorthand:** `gradient` supports 1, 2, or 4 values:
- `10%` -> all four edges
- `5% 15%` -> horizontal vertical
- `0% 20% 0% 10%` -> left top right bottom

### Per-page override

Override any wash property via `image.wash` in frontmatter:

```yaml
image:
  src: hero.jpg
  dark: true
  wash:
    opacity: 0.6
    blur: 5px
    gradient: 0rem 3rem 0rem 1rem
```

Resolution chain: **page frontmatter** > **site params** > **built-in defaults**.

### Dark vs light context

The wash colour is determined by the background layout context:
- **Dark context** (`image.dark: true` or not set): dark wash (`rgba(0,0,0,opacity)`)
- **Light context** (`image.dark: false`): light wash (`rgba(255,255,255,opacity)`)

---

## Section Display Configuration

These frontmatter fields control how section list pages (`_index.md` / `_index.org`) display content:

```yaml
---
list_style: cards       # "cards" (default), "list", or "gallery"
sidebar: true           # true or false (default), or a map with content
list_recursive: false   # true or false (default)
paginate: 12            # items per page (default: 12)
---
```

**Note:** The theme uses `list_style` (not `layout`) because Hugo reserves `layout` for template selection.

### Field Descriptions

| Field | Default | Description |
|-------|---------|-------------|
| `list_style` | `cards` | Display mode: `cards` (masonry grid), `list` (vertical list with background images), `gallery` (image grid) |
| `sidebar` | `false` | Show sidebar. Can be `true` (subsection nav), or a map with `title`, `content`, `sections`, `root` |
| `list_recursive` | `false` | Include all nested content recursively (uses `.RegularPagesRecursive`) |
| `paginate` | `12` | Items per page before pagination links appear |

### Sidebar Configuration

On viewports ≤ 48em (mobile/tablet), the sidebar collapses into a `<details>`/`<summary>` toggle with a ▼ chevron indicator. Users can tap to expand or collapse the navigation; expanded content pushes cards down in normal flow. On desktop, the sidebar title displays as a plain heading (no toggle affordance) and the sidebar fits its content width (capped at 20% viewport). A small inline script closes the sidebar on narrow viewports at page load and responds to orientation changes. The sidebar title defaults to "Navigation" but can be overridden with `sidebar.title`.

The sidebar is entirely configured via frontmatter. Two main modes:

#### Mode 1: Simple (`sidebar: true`)

Shows subsections of the current page automatically. Use this for section pages.

```yaml
# content/recipes/_index.md
sidebar: true
```

Result: Shows subsections of the current section (e.g., Starters, Mains, Desserts...)

#### Mode 2: Content-based (`sidebar.content`)

Full control via markdown and shortcodes. Use this for custom content like bios, or mixed layouts.

```yaml
# content/_index.md (homepage)
sidebar:
  title: "About"
  content: |
    Welcome to my site.

    {{< section-list >}}

    Based in Dublin.
```

The `section-list` shortcode behaviour is consistent everywhere:
- `{{< section-list >}}` -> shows sections defined in `mainSections`
- `{{< section-list sections="blog,portfolio" >}}` -> shows those specific sections

#### Mode 3: Explicit sections list

A simpler alternative to content-based when you just need section links:

```yaml
sidebar:
  title: "Browse"
  sections:
    - blog
    - portfolio
    - gallery
```

#### Mode 4: Root-based sibling navigation (`sidebar.root`)

Shows subsections of a specified root section. Use this for sibling navigation in deeply nested pages.

```yaml
# content/gallery/landscapes/_index.org
sidebar:
  root: gallery
```

Result: Shows all subsections of the root section (e.g., Landscapes, Portraits, Abstract...) regardless of which subsection you're viewing. This enables consistent navigation across sibling sections.

### Display Combinations

| list_style | sidebar | list_recursive | Result |
|------------|---------|----------------|--------|
| cards | false | false | Current default: masonry grid |
| cards | true | false | Sidebar + masonry grid |
| cards | true | true | Sidebar + all nested content as cards |
| list | false | false | Simple vertical list |
| list | true | false | Sidebar + list |
| gallery | false | false | Image gallery grid |
| gallery | true | false | Sidebar + gallery grid |

### Example Section Defaults

These are illustrative examples from the [demo site](https://tadg.ie). Adapt section names and settings to suit your site structure.

| Section | list_style | sidebar | Notes |
|---------|------------|---------|-------|
| Blog | cards | true | Sidebar for categories |
| Portfolio | cards | true | Sidebar for subsections |
| Notes | cards | true | Sidebar for topics |
| Stories | list | false | Simple list for narrative content |
| Gallery | gallery | true | Gallery grid with folder navigation |

---

## Pagination

Site-wide pagination default is set in `hugo.yaml`:

```yaml
pagination:
  pagerSize: 12   # Items per page (default)
```

Override per-section using `paginate` frontmatter field in section `_index.md` files:

```yaml
---
title: My Section
paginate: 20  # Show 20 items per page in this section
---
```

The pagination partial (`layouts/partials/pagination.html`) displays prev/next links and page numbers with ellipsis for large page counts.

---

## Section Examples

These examples show how the theme is used on the demo site (tadg.ie). You can organize your content with any section names - the theme adapts to your structure.

### Gallery Content (e.g., `/artwork/`)

Set `gallery: true` in frontmatter for image-dominant cards with overlay text. See [Gallery System](#gallery-system-artwork).

### Text Content (e.g., `/poetry/`, `/blog/`, `/plays/`)

All non-gallery content uses the same card layout:
- Title
- Excerpt/summary (150 characters)
- Date and section label
- Read-more link

Customize appearance using CSS:
```css
/* Custom styling for a "recipes" section */
.masonry-recipes .masonry-excerpt {
  font-style: italic;
}
```

### Collections (`/collections/`)

Example of grouping related content:
- Main page lists all collections
- Individual collection pages show their items
- Uses `collection` frontmatter to group content

---

## Gallery System (Artwork)

The artwork section uses the `{{< gallery >}}` shortcode for flexible image display.

### Gallery List Page

Displays all gallery folders (subsections) with:
- Hero image for each gallery (first image or `featured_image`)
- Gallery title and description
- Image count badge

### Gallery Shortcode (`layouts/shortcodes/gallery.html`)

Any page can display its image resources as a gallery by including `{{< gallery >}}` in its content.

**Features:**

1. **Metadata Priority:**
   - Frontmatter resource params (highest priority)
   - EXIF data (`DocumentName`, `ImageDescription`)
   - Filename (fallback)

2. **EXIF Metadata Extraction:**
   - `DocumentName` -> Image title
   - `ImageDescription` -> Image caption/description
   - Used for alt text and captions

3. **Responsive Images:**
   - Three sizes: 400px, 800px, 1600px
   - WebP format for modern browsers
   - Original format fallback
   - Lazy loading enabled

4. **Lightbox Integration:**
   - Click to open full-size image
   - Keyboard navigation (arrows, Escape)
   - Caption display from EXIF or frontmatter

### Gallery Frontmatter

```yaml
---
title: "Gallery Name"
description: "Gallery description"
params:
  featured_image: "hero.jpg"  # Optional: hero image for list page
resources:
  - src: "*.jpg"
    params:
      weight: 10  # Sort order
  - src: "special.jpg"
    params:
      title: "Custom Title"      # Overrides EXIF
      caption: "Custom caption"  # Overrides EXIF
---

{{< gallery >}}
```

---

## Shortcodes

> **Detailed reference with visual examples:** See [docs/shortcodes.md](docs/shortcodes.md) for the full shortcode reference including parameter tables and screenshot placeholders.

### `{{< callout >}}`

Styled alert/callout boxes with colour-coded types.

```markdown
{{< callout type="tip" text="This is a helpful tip!" >}}
{{< callout type="alert" text="Important alert message" >}}
{{< callout type="warning" text="Warning message" >}}
{{< callout type="custom" title="Custom Title" text="Custom message" style="background: #fee;" >}}
```

**Types:** `tip`, `alert`, `warning`, `custom`

**Rendered output:**

```
┌──────────────────────────────────────┐
│ Tip                                  │
│ This is a helpful tip!               │  (green background)
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│ Alert                                │
│ Important alert message              │  (red background)
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│ Warning                              │
│ Warning message                      │  (yellow background)
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│ Custom Title                         │
│ Custom message                       │  (custom style)
└──────────────────────────────────────┘
```

### `{{< details >}}`

Collapsible content block with a styled summary line. Closed state shows an ellipsis hint; open state reveals the full content.

```markdown
{{< details "Click to expand" >}}
Hidden content goes here.
Can include **markdown**.
{{< /details >}}
```

**Rendered output (closed):**

```
- Click to expand ···
```

**Rendered output (open):**

```
▾ Click to expand
┃ Hidden content goes here.
┃ Can include markdown.
```

### `{{< dialogue >}}`

Character speech for plays and screenplays. Character name renders in small caps with optional parenthetical (delivery direction) in italics.

Supports both positional and named parameters:

```markdown
{{< dialogue "TOM" "pleading" >}}Please don't shake off the water!{{< /dialogue >}}
{{< dialogue "ALISON" >}}You've waited since yesterday, Tom.{{< /dialogue >}}
{{< dialogue name="BAYANI" parenthetical="chuckling" >}}Oh is that all?{{< /dialogue >}}
```

**Parameters:**
- First positional or `name` - character name (required)
- Second positional or `parenthetical` - delivery direction (optional)

**Rendered output:**

```
  ᴛᴏᴍ (pleading)
  Please don't shake off the water!

  ᴀʟɪꜱᴏɴ
  You've waited since yesterday, Tom.

  ʙᴀʏᴀɴɪ (chuckling)
  Oh is that all?
```

### `{{< direction >}}`

Stage directions for plays. Renders in italics with secondary accent colour.

```markdown
{{< direction >}}A bare stage. Single chair centre. TOM enters.{{< /direction >}}
{{< direction >}}Pause.{{< /direction >}}
{{< direction >}}Lights fade.{{< /direction >}}
```

**Rendered output:**

```
  A bare stage. Single chair centre. TOM enters.
  Pause.
  Lights fade.
```

(Italic text in the theme's secondary colour - orange in light mode, bright orange in dark mode.)

### `{{< popquote >}}`

Expandable quote with styled summary. Uses the same collapsible styling as `details`.

```markdown
{{< popquote "Opening line..." >}}
Full quote content here.
Multiple paragraphs supported.
{{< /popquote >}}
```

**Rendered output (closed):**

```
- Opening line... ···
```

**Rendered output (open):**

```
▾ Opening line...
┃ Full quote content here.
┃ Multiple paragraphs supported.
```

### `{{< quote >}}`

Pull-quote with a decorative opening quotation mark and optional attribution. Block-form: body is markdown. Distinct from `popquote` - always visible rather than expandable, designed as a featured highlight within the flow of an article.

```markdown
{{< quote attribution="A. Person" >}}
The actual quote text - can include **markdown** and span multiple lines.
{{< /quote >}}
```

**Rendered output:**

```
  ❝
      The actual quote text - can include markdown and
      span multiple lines.
                                               - A. Person
```

Large decorative opening quote in the theme's primary accent colour; italic body text; right-aligned muted attribution caption prefixed with an em-dash. Responsive across light and dark modes.

### `{{< poem >}}`

Poetry formatting with preserved line breaks. Newlines in the source are converted to `<br />` tags so verse structure is maintained.

```markdown
{{< poem >}}
Roses are red,
Violets are blue,
This preserves
Line breaks for you.
{{< /poem >}}
```

**Rendered output:**

```
Roses are red,
Violets are blue,
This preserves
Line breaks for you.
```

(Line breaks preserved exactly as written - no paragraph collapsing.)

### `{{< video >}}`

Embed video - local files via HTML5 `<video>` or [Cloudflare Stream](https://developers.cloudflare.com/stream/) via iframe. Auto-detects source type: 32-character hex string -> Cloudflare Stream, anything else -> local file.

See [docs/shortcodes.md](docs/shortcodes.md#video) for the full parameter reference.

```markdown
{{< video "/videos/my-video.mp4" >}}
{{< video "ea95132c15732412d22c1476fa83f27a" >}}
{{< video id="ea95132c15732412d22c1476fa83f27a" autoplay="true" muted="true" >}}
```

Cloudflare Stream requires `params.cloudflareStream.customerCode` in `hugo.yaml`.

Cloudflare Stream videos can also be used as the primary visual in page layouts (`hero`, `featured`, `columns`) via the `video` frontmatter field - see [docs/shortcodes.md](docs/shortcodes.md#video-in-page-layouts) for details.

**Rendered output (local):**

```
┌──────────────────────────────────────┐
│                                      │
│           ▶  Video Player            │
│                                      │
│  ▶ advancement ━━━━━━━━━━ 🔊 ⛶     │
└──────────────────────────────────────┘
```

### `{{< contactform >}}`

Self-hosted contact form with Cloudflare Turnstile CAPTCHA, Worker backend, and optional newsletter signup.

```markdown
{{< contactform >}}
{{< contactform newsletter="true" >}}
```

**Rendered output:**

```
┌──────────────────────────────────────┐
│  Email:    [__________________________]│
│  Name:     [__________________________]│
│  Message:  [__________________________]│
│            [__________________________]│
│            [__________________________]│
│  ☐ Subscribe to newsletter           │
│                                      │
│  [Turnstile CAPTCHA widget]          │
│                          [ Send -> ]  │
└──────────────────────────────────────┘
```

(Newsletter checkbox only appears with `newsletter="true"`.)

Requires Cloudflare Worker deployment and Hugo configuration. See [docs/contactform.md](docs/contactform.md) for full setup guide.

### `{{< formspree >}}`

Embed a Formspree contact form (simpler alternative to `contactform` - no CAPTCHA, no self-hosting).

```markdown
{{< formspree id="your-formspree-id" >}}
```

**Rendered output:**

```
┌──────────────────────────────────────┐
│  Email:    [__________________________]│
│  Name:     [__________________________]│
│  ☐ Newsletter                        │
│  Message:  [__________________________]│
│                          [ Send -> ]  │
└──────────────────────────────────────┘
```

### `{{< rawhtml >}}`

Pass through raw HTML without markdown processing. Use for embedding widgets, iframes, or any HTML that Hugo's markdown renderer would alter.

```markdown
{{< rawhtml >}}
<div class="custom-widget">
  <iframe src="..."></iframe>
</div>
{{< /rawhtml >}}
```

**Rendered output:** The HTML is passed through verbatim - whatever you write is what appears in the page source.

### `{{< section-list >}}`

Renders a navigation list of site sections with chevron icons. Behaviour is consistent on any page (homepage, section pages, single pages).

```markdown
{{< section-list >}}
{{< section-list sections="blog,gallery" >}}
{{< section-list limit="3" >}}
```

**Parameters:**
- `sections` - comma-separated list of sections (defaults to `site.Params.mainSections`)
- `limit` - show this many items per section (optional; omit for section links only)

**Rendered output:**

```
  › Poetry
  › Artwork
  › Blog
  › Stories
```

With `limit="3"`:

```
  › Poetry
      Recent poem title one
      Recent poem title two
      Recent poem title three
  › Blog
      Recent blog post one
      Recent blog post two
      Recent blog post three
```

| Usage | Shows |
|-------|-------|
| `{{< section-list >}}` | All sections defined in `mainSections` |
| `{{< section-list sections="blog,gallery" >}}` | Those specific sections |
| `{{< section-list limit="3" >}}` | Sections with up to 3 recent items each |

---

## Configuration Options

### Grid Configuration

The responsive grid is configurable via `params.grid` in `hugo.yaml`. All breakpoints use `em` units (WCAG 2.1 compliant - adapts to browser font size preferences). CSS media queries and JavaScript masonry both read from this single configuration source.

```yaml
params:
  grid:
    contentMaxWidth: 100rem       # max content area width
    sidebarWidth: 15rem           # sidebar column width at desktop
    sidebarWidthNarrow: 12rem     # sidebar column width at tablet
    gap: 1.5rem                   # grid gap between items
    breakpoints:
      sm: 30em                    # small / mobile
      md: 48em                    # medium / tablet
      lg: 64em                    # large / desktop
      xl: 80em                    # extra large / wide desktop
    columns:
      sm: 2                       # columns at small breakpoint
      md: 3                       # columns at medium breakpoint
      lg: 4                       # columns at large breakpoint
      xl: 5                       # columns at extra large breakpoint
```

All values above are the defaults. Omitting `params.grid` entirely produces identical behaviour.

**Per-section overrides:** Add a `grid` block to any section's `_index.md` frontmatter. Page-level values override site-level defaults:

```yaml
# content/photography/_index.md
---
title: Photography
grid:
  columns:
    xl: 6   # more columns for small thumbnails
---
```

**Implementation:** The `grid-config.html` partial generates a `<style>` block with CSS media queries and sets CSS custom properties (`--content-max-width`, `--sidebar-width`, `--grid-gap`). It also writes a `data-grid-config` JSON attribute on `<body>` that `masonry-init.js` reads for JavaScript layout calculations.

### `hugo.yaml` Settings

For the full configuration reference, see [docs/config.md](docs/config.md).

For all available frontmatter fields, see [docs/frontmatter.md](docs/frontmatter.md).

See `exampleSite/config/_default/hugo.yaml` for a complete working example.

### Menu Configuration

```yaml
menu:
  main:
    - name: Blog
      url: /blog/
      weight: 10
    - name: Gallery
      url: /gallery/
      weight: 20
    # ...
```

---

## Index Files and Page Bundles

Hugo uses two types of index files to organize content.

### File Types Overview

| File | Type | Purpose | URL Example |
|------|------|---------|-------------|
| `_index.md` | Branch bundle | Section/list page metadata and content | `/poetry/` |
| `index.md` | Leaf bundle | Individual page content | `/poetry/my-poem/` |

### `_index.md` - Branch Bundles (Sections)

A `_index.md` (or `_index.org`) file defines metadata for a **section** or **list page**.

**Example:**
```yaml
---
title: Poetry
description: A collection of verses and musings
list_style: cards
sidebar: true
---

Welcome to my poetry section.
```

### `index.md` - Leaf Bundles (Individual Pages)

An `index.md` file defines an **individual content page** within a page bundle.

**Example:**
```yaml
---
title: That Day
date: 2004-05-01
layout: columns
image:
  src: sunset.jpg
---

Take me to that place in time...
```

### Org-mode Support

Both `.md` (Markdown) and `.org` (Org-mode) files are supported. Frontmatter in Org files uses the same YAML format.

---

## Frontmatter Reference

For the full frontmatter reference, see [docs/frontmatter.md](docs/frontmatter.md).

---

## CSS Customization

### CSS Variables (Light Mode)

```css
:root {
  --text-color: #000;
  --text-secondary: #333;
  --text-muted: #666;
  --bg-color: #fff;
  --bg-secondary: #f5f5f5;
  --bg-hover: #f1f1f1;
  --border-color: #ddd;
  --accent-color: hsl(27, 100%, 35%);
  --link-color: #007acc;
  --content-max-width: 100rem;    /* configurable via params.grid */
  --sidebar-width: 15rem;         /* configurable via params.grid */
  --sidebar-width-narrow: 12rem;  /* configurable via params.grid */
  --grid-gap: 1.5rem;             /* configurable via params.grid */
}
```

### Dark Mode

Supports both system preference (`prefers-color-scheme: dark`) and manual toggle (`data-theme="dark"`).

### Key Classes

| Class | Purpose |
|-------|---------|
| `.masonry-grid` | Container for masonry layout |
| `.masonry-item` | Individual grid item |
| `.masonry-{section}` | Section-specific styling |
| `.masonry-bg` | Background image layer (masonry cards and carousel) |
| `.carousel-container` | Carousel wrapper with rotation controls |
| `.carousel-card` | Individual carousel slide |
| `.carousel-active` | Currently visible carousel slide |
| `.image-dark` / `.image-light` | Image lightness classes (from `image.dark` frontmatter) |
| `.list-view-bg` | Background image layer (list items) |
| `.list-view-content` | Content wrapper above background (list items) |
| `.gallery-grid` | Gallery image container |
| `.gallery-item` | Individual gallery image |
| `.lightbox` | Lightbox overlay |
| `.sidebar-collapse` | Collapsible `<details>` wrapper for mobile sidebar |
| `.sidebar-collapse-title` | `<summary>` toggle - plain heading on desktop, tap target on mobile |
| `.toc-mobile-title` | Mobile-only article title shown above TOC (hidden on desktop) |
| `.pagination` | Pagination container |
| `.pagination-link` | Pagination button |

---

## Social Icons (Footer)

The footer displays social links as icons, configured via `params.social` in `hugo.yaml`.

### Icon Systems

Two icon sets are supported:

| Format | Example | Icon Set | Rendering |
|--------|---------|----------|-----------|
| `icon: github` | Feather icon (default) | [Feather Icons](https://feathericons.com/) | SVG sprite (`<svg><use>`) |
| `icon: "simple:bluesky"` | Simple Icons (`simple:` prefix) | [Simple Icons](https://simpleicons.org/) | Icon font (`<i class="si si-bluesky">`) |

Use Feather for common icons (`github`, `twitter`, `mail`, `instagram`, `linkedin`, etc.). Use Simple Icons with the `simple:` prefix for platforms not in the Feather set (e.g., `bluesky`, `mastodon`).

### Configuration Example

```yaml
params:
  useCDN: false          # false = local assets (default), true = CDN
  social:
    - name: BlueSky
      icon: "simple:bluesky"    # Simple Icons (not in Feather set)
      url: https://bsky.app/profile/username
    - name: Instagram
      icon: instagram           # Feather icon
      url: https://www.instagram.com/username/
    - name: GitHub
      icon: github              # Feather icon
      url: https://github.com/username/
    - name: Email
      icon: mail                # Feather icon
      url: mailto:you@example.com
```

### Assets

- **Feather sprites:** `assets/svg/feather-sprite.svg` (local) or unpkg CDN
- **Simple Icons font:** `static/fonts/SimpleIcons.woff2` + `assets/css/simple-icons.css`
- The Simple Icons CSS is only loaded when at least one `simple:` icon is configured

### Copyright

The footer also displays a copyright line from the site-level `copyright` field:

```yaml
copyright: "Your Name. All rights reserved."
```

Rendered as: `{copyright text} |`

---

## JavaScript Components

### Masonry Layout (`static/js/masonry-init.js`)

**Purpose:** Positions masonry items using shortest-column algorithm.

**Features:**
- Responsive column calculation using em-based breakpoints
- Waits for images to load before positioning
- Debounced resize handling
- Falls back to CSS Grid for single column

**Public API:**
```javascript
window.masonryLayout();  // Re-run layout
window.masonryInit();    // Full re-initialization
```

### Carousel (`static/js/carousel.js`)

**Purpose:** Crossfade rotation for carousel cards with auto-advance, hover pause, and arrow navigation.

**Features:**
- Auto-advances every N seconds (reads `data-interval` from container)
- Pauses on mouse hover
- Translucent prev/next arrows appear on hover near edges
- Keyboard left/right arrows when carousel is focused
- Single-item mode: no transitions or arrows - inert

### Lightbox (`static/js/lightbox.js`)

**Purpose:** Full-screen image viewing for galleries.

**Features:**
- Click to open, click outside to close
- Keyboard navigation (<-, ->, Escape)
- WebP source detection for best quality
- EXIF-based captions

### Burger Menu (`static/js/burger-menu.js`)

Mobile navigation toggle.

---

## Scripts

Utility scripts live in `scripts/`. Run them from the root of your Hugo project.

### `scripts/pins.pl`

Lists all content files with a `pin:` value in their frontmatter, sorted numerically. Useful for reviewing pin assignments before reordering or adding new ones.

```bash
$ themes/first-folio/scripts/pins.pl
Pin  File
---  ------------------------------------------------
100  blog/2026-01-29-dark-optimism-ai/index.org
200  artwork/remy/_index.org
300  poetry/secrets/quadriplegia/index.md
400  poetry/secrets/what-the-tide-brought-in/index.md

4 pinned item(s)
```

**Requirements:** Perl 5 (standard on macOS and Linux).

**Detection:** The script checks for a Hugo config file (`hugo.yaml`, `hugo.toml`, `config.yaml`, etc.) in the current directory. It also works from within the `content/` tree. Running it elsewhere produces an error:

```
This must be run from the root of a Hugo project or its content directory.
```

### `scripts/org-play-to-shortcodes.pl`

Converts orgmode play scripts to use Hugo shortcodes for dialogue and stage directions. Modifies files in-place, so commit changes first.

**Conversions:**
- `*** Stage direction` -> `{{< direction >}}Stage direction{{< /direction >}}`
- `**** CHARACTER text` -> `{{< dialogue "CHARACTER" >}}text{{< /dialogue >}}`
- `**** CHARACTER direction` -> `{{< dialogue "CHARACTER" "direction" >}}text{{< /dialogue >}}`

All other content (frontmatter, `*` and `**` headers, bullet points, regular text) is preserved unchanged.

```bash
$ themes/first-folio/scripts/org-play-to-shortcodes.pl content/plays/myplay/index.org
Converted to shortcodes: content/plays/myplay/index.org
```

**Requirements:** Perl 5 with standard modules (utf8, strict, warnings).

**Usage:** Run from anywhere, passing the path to your orgmode play file. Use `--help` for full documentation.

---

## Troubleshooting

### Images Not Displaying

1. **Check path:** Image paths should be relative filenames for page bundles
   ```yaml
   # Correct (page bundle)
   image:
     src: my-image.jpg

   # Incorrect
   image:
     src: /posts/old-path/my-image.jpg
   ```

2. **Run tests:** `make test` validates image paths

### Masonry Not Working

1. Check browser console for JS errors
2. Ensure `masonry-init.js` is loaded
3. Verify `.masonry-grid` container exists
4. Check images have loaded (lazy loading delay)

### Gallery Images Missing Captions

EXIF metadata must include `DocumentName` or `ImageDescription` tags.

### Dark Mode Not Toggling

Ensure both CSS files are loaded:
- `css/main.css` (base)
- `css/dark.css` (dark mode)

### Pagination Not Appearing

- Pagination only shows when there are more items than `pagerSize`
- Check that `paginate` frontmatter value is a positive integer
- Verify the section has enough content pages

---

## Licence

Copyright (c) 2023-2026 Taḋg Paul.

Licensed under the Apache License, Version 2.0 (the "Licence"); you may not
use this work except in compliance with the Licence. A copy of the Licence is
in the [LICENSE](LICENSE) file.

This theme is derived from the [Archie](https://github.com/athul/archie) Hugo
theme by Athul Cyriac Ajay, originally licensed under the MIT Licence. See
[NOTICE](NOTICE) and [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md) for
attribution.
