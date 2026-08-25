<!-- Version: 1.0 | Last updated: 2026-08-25 -->

# Theme overrides and additions in place, 2026-08-25

Handover inventory for importing tigger.dev's theme-facing work into
[First Folio](https://github.com/tigger-developer/hugo-theme-first-folio).
The theme is consumed unmodified as a Hugo module; everything below is either
a documented override of one theme file or a project-level addition the theme
knows nothing about. Each entry names what should happen to it once the theme
adopts the capability.

The override discipline is test-enforced: RT-1.1 fails if any project file
under `layouts/` or `assets/` shadows a theme path off the allowlist in
`tests/regression/theme-integration.bats`, and RT-1.50 fails if an allowlist
entry stops shadowing anything.

## 1. Override: `layouts/index.html` (homepage footer content region)

The one true override -- the only entry on the RT-1.1 allowlist.

- A verbatim copy of the theme's `layouts/index.html` plus one block, marked
  `PROJECT ADDITION`, after the pagination partial.
- The addition renders an optional `footer_content` front-matter parameter as
  markdown below the card grid, wrapped in `<div class="homepage-footer-content">`.
  Shortcodes work inside it; tigger.dev uses it to place the tag cloud under
  the cards.
- Rationale: the theme renders the homepage body above the carousel and
  offers no region after the grid.
- On adoption: add the same optional region to the theme's `index.html`
  (and arguably `list.html`, so section pages gain it too), then **delete this
  file entirely** and remove its allowlist entry. RT-1.50 will flag the stale
  entry if the deletion is forgotten.

## 2. Addition: the tag cloud

Three files, no shadowing. Designed from the start for promotion: data and
presentation are strictly separated, and no file references anything
tigger.dev-specific.

### `layouts/partials/tagcloud.html`

The single implementation. Renders any taxonomy as a weighted word cloud.

- Emits data only: per-term `--tagcloud-weight` (frequency normalized 0-1),
  `--tagcloud-hue` (stable FNV32a hash of the term), `--tagcloud-line-ch`
  (characters per line for wrap-capped terms), and `data-rank`. Every visual
  decision lives in the stylesheet.
- Options (all optional except `page`): `taxonomy`, `sort` (alpha/count),
  `scale` (log/linear -- log is the default because tag frequencies are
  Zipf-like), `minCount`, `limit`, `counts`, `pack` (rows/columns/float),
  `floatTop`, `leadTop`, `maxLines`, `wrapOver`. The file's header comment
  documents each.
- Sizing is deliberately **not** a call-site option; see the config entry
  below.

### `layouts/shortcodes/tagcloud.html`

Thin content-facing wrapper. No logic; passes its named parameters to the
partial. Exists so templates and content share one implementation.

### `assets/css/tagcloud.css`

All presentation, loaded through the theme's existing `params.customCSS`
facility (no override needed).

- Size model: least-used term at `--tagcloud-base`, most-used at base x
  `--tagcloud-multiplier`, weighted per term; `--tagcloud-amplitude`
  compresses the spread on narrow viewports (0.5 mobile, 1 from the theme's
  own 48rem breakpoint).
- Colour model: hue from the term, saturation and lightness set once per
  ambience, with `html[data-theme="dark"]` and a `prefers-color-scheme`
  fallback mirroring the theme's ambience mechanism.
- Three packing variants (`rows`, `columns`, `float`), theme list-reset rules
  (the theme's hanging-bullet `ul` padding and `text-indent` must be undone),
  and `prefers-reduced-motion` handling.
- On adoption: move into the theme's stylesheet set so `customCSS` wiring
  disappears here.

### Site configuration: `params.tagcloud`

In `config/_default/hugo.yaml`:

```yaml
params:
  tagcloud:
    base: 0.75rem   # size of the least-used term
    multiplier: 3   # the most-used term renders at base x multiplier
```

One home, site-wide, so every cloud on the site agrees; the stylesheet
carries fallbacks when the keys are absent. The partial emits these as custom
properties on the list element. Note the `%v` (not `%s`) format verb in the
partial: YAML delivers `multiplier` as a number, and `%s` renders a Go type
error into the style attribute.

### Content wiring

`content/_index.md` calls the shortcode from `footer_content`:

```
footer_content: |
  {{</* tagcloud pack="float" floatTop="1" leadTop="2" maxLines="2" */>}}
```

On adoption this stays -- it is ordinary use of a theme feature, not an
override.

## 3. Integration notes the theme import should know about

Not overrides, but site-config accommodations of theme behaviour that the
import may want to revisit:

- **`cascade: type: article`** in `content/_index.md`. The theme's
  `term.html` filters out pages whose `.Type` is in `excludedTypes` (default
  `["page"]`). A flat site's root-level articles are type `page` by default,
  so term pages rendered empty until the cascade retyped them.
- **`mainSections: [""]`** in `hugo.yaml`. The theme gathers carousel and
  pinned pages per main section; with flat content, the empty string is the
  section name that reaches those loops.
- A companion proposal for term-page presentation is in
  `theme-proposed-tag-list-2026-08-25.md`.
