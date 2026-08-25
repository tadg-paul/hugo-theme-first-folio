<!-- Version: 1.0 | Last updated: 2026-08-25 -->

# Proposal: configurable list presentation for taxonomy term pages

For implementation in
[First Folio](https://github.com/tigger-developer/hugo-theme-first-folio).
Drafted from tigger.dev, where tags are the primary navigation and the
current term-page presentation undersells them.

## Problem

A taxonomy term page (for example `/tags/git/`) renders as a bare list of
title-plus-date entries, while section pages get the full cards treatment:
carousel, masonry grid, pagination. The difference is template selection, not
capability:

- For page kind `term`, Hugo's lookup order finds `layouts/_default/term.html`
  first and stops. The theme ships one -- a minimal `<ul class="posts">` loop.
- The cards flow lives in `layouts/_default/list.html`, which term pages never
  reach precisely because `term.html` exists.

On a site navigated by tags (tigger.dev's word cloud links straight to term
pages), a reader clicks a large, colourful term and lands on the plainest
page on the site.

## Proposal

Teach `layouts/_default/term.html` the same `list_style` idea `list.html`
already has, with a site-level default so per-term front matter is not
required.

### Configuration

New site parameter, defaulting to today's behaviour so existing consumers
see no change:

```yaml
params:
  termListStyle: cards   # or "list"; absent means "list", today's rendering
```

Per-term override in the term's own bundle, for sites that want one odd
term out (creating `content/tags/<term>/_index.md` is already how Hugo adds
term front matter):

```yaml
list_style: list
```

Resolution: term front matter, else `site.Params.termListStyle`, else
`list`. Naming follows the theme's existing conventions -- camelCase for site
parameters (`excludedTypes`, `dateFormatShort`), snake_case for page front
matter (`list_style`, `breadcrumb_list`).

### Template sketch

Replace the body of `layouts/_default/term.html` along these lines (the
heading logic and the `excludedTypes` filter are today's behaviour,
preserved):

```
{{ define "main" }}
{{- $style := .Params.list_style | default (site.Params.termListStyle | default "list") -}}

{{- /* Filter excluded types once, before either presentation. The masonry
     partial does no filtering of its own, so the filter must happen here or
     site pages carrying a tag would surface in cards mode. */ -}}
{{- $excluded := site.Params.excludedTypes | default (slice "page") -}}
{{- $pages := slice -}}
{{- range .Pages -}}
  {{- if not (in $excluded .Type) -}}{{- $pages = $pages | append . -}}{{- end -}}
{{- end -}}

{{ if isset .Data "Term" }}
<h1>Entries tagged - "{{ .Data.Term }}"</h1>
{{ else }}
<h1 class="page-title">All articles</h1>
{{ end }}

{{ if .Content }}<div class="page-content">{{ .Content }}</div>{{ end }}

{{ if eq $style "cards" }}
  {{ $paginator := .Paginate $pages }}
  {{ partial "masonry-grid.html" (dict "pages" $paginator.Pages "showSection" false "Site" .Site) }}
  {{ partial "pagination.html" $paginator }}
{{ else }}
  <ul class="posts">
    {{ range $pages }}
    <li class="post">
      <a href="{{ .RelPermalink }}">{{ .Title }}</a> <span class="meta">{{ dateFormat (site.Params.dateFormatShort | default ":date_medium") .Date }}{{ if .Draft }} <span class="draft-label">DRAFT</span>{{ end }}</span>
    </li>
    {{ end }}
  </ul>
{{ end }}
{{ end }}
```

Plus, in cards mode only, the masonry initializer the grid depends on
(`list.html` loads it unconditionally at the bottom of its `main` block):

```
<script src="{{ "js/masonry-init.js" | relURL }}"></script>
```

`carousel.js` is not needed: term pages have no carousel front matter to
honour, and proposing one here would be scope creep.

## Design decisions, made explicit

- **Extend `term.html` rather than delete it.** Deleting would let lookup
  fall through to `list.html`, and the defaults there do land on the cards
  branch -- but the term heading is lost, the collections-specific branching
  is inherited, and term pages become hostage to every future `list.html`
  change aimed at sections. A small dedicated template that shares the
  partials is clearer.
- **Default is `list`.** Backwards compatible; the theme's other consumers
  render exactly as before until they opt in. tigger.dev sets
  `termListStyle: cards`.
- **Filter before paginating.** `.Paginate` must receive the filtered set,
  or excluded pages consume pager slots and page counts drift. `.Paginate`
  can also only be called once per page, so both modes could share the
  paginator if list mode should ever paginate too -- left unpaginated here to
  match today's rendering.
- **`.Pages` over `.Data.Pages`.** Equivalent on a term page, and `.Pages`
  is the documented modern accessor.
- **Two styles only.** `list.html` also knows `gallery` and `prose`; neither
  has an evident term-page use, and each brings assumptions (gallery includes
  sections, prose suppresses listing entirely). Add later if a need appears.

## Follow-on candidates, out of scope here

- The same treatment for `terms.html` (the `/tags/` index): First Folio
  renders it as a plain term list; the tag cloud partial arriving with the
  same import (see `theme-overrides-2026-08-25.md`) would make a natural
  `termsListStyle: cloud` option.
- A post-grid content region on `index.html` and `list.html`, replacing
  tigger.dev's one allowlisted override; documented in the same overrides
  inventory.

## Acceptance sketch

1. With no configuration, a term page renders byte-identical semantics to
   today's list (title link, date, draft label, `excludedTypes` respected).
2. With `termListStyle: cards`, a term page renders the masonry grid and
   pagination, and pages of excluded types appear in neither mode.
3. A term bundle's `list_style` overrides the site default in both
   directions.
4. `masonry-init.js` is loaded on cards-mode term pages and absent from
   list-mode ones.
