# shellcheck shell=bash
# ABOUTME: Builds taxonomy-term fixtures and asserts issue #84 list/card behavior from rendered HTML.
# ABOUTME: Exercises configuration precedence, filtering, pagination, scripts, and example-site integration.

term_style_build() {
    local environment="${1:-production}"
    local drafts="${2:-false}"
    local suffix="$environment"
    local out
    local -a args
    if [[ "$drafts" == true ]]; then
        suffix="${suffix}-drafts"
    fi
    out="$REGRESSION_TMP/fixture-term-list-style-$suffix"
    if [[ -f "$out/index.html" ]]; then
        printf '%s\n' "$out"
        return 0
    fi
    args=(
        --quiet
        --source "$FIXTURES_ROOT/term-list-style"
        --destination "$out"
        --themesDir "$THEME_ROOT/.."
        --theme "$(basename "$THEME_ROOT")"
        --environment "$environment"
    )
    if [[ "$drafts" == true ]]; then
        args+=(--buildDrafts)
    fi
    if ! hugo "${args[@]}"; then
        printf '    term-list-style Hugo build failed for environment %s\n' "$environment" >&2
        return 1
    fi
    printf '%s\n' "$out"
}

term_style_page() {
    local environment="$1"
    local route="$2"
    local drafts="${3:-false}"
    local build_dir
    local page
    build_dir="$(term_style_build "$environment" "$drafts")" || return 1
    page="$build_dir/$route/index.html"
    if [[ ! -f "$page" ]]; then
        printf '    expected rendered taxonomy page at %s\n' "$page" >&2
        return 1
    fi
    printf '%s\n' "$page"
}

term_style_list_titles() {
    htmlq -f "$1" -t 'ul.posts > li.post > a'
}

term_style_card_titles() {
    htmlq -f "$1" -t '.masonry-grid > .masonry-item h3 > a'
}

term_style_summary_titles() {
    htmlq -f "$1" -t '.list-view > .list-view-item .list-view-title > a'
}

term_style_has_script() {
    local page="$1"
    local source="$2"
    [[ -n "$(htmlq -f "$page" "script[src$=\"$source\"]")" ]]
}

term_style_expect_complete_list() {
    local page="$1"
    [[ "$(term_style_list_titles "$page")" == $'Alpha Entry\nBravo Entry\nCharlie Entry\nDelta Entry' ]] || return 1
    [[ -z "$(htmlq -f "$page" '.masonry-grid, nav.pagination')" ]] || return 1
    ! term_style_has_script "$page" 'js/masonry-init.js'
}

term_style_rt_84_1() {
    local page
    local ordered
    page="$(term_style_page production tags/default)" || return 1
    ordered="$(htmlq -f "$page" -t 'h1, .page-content, ul.posts')"
    [[ "$ordered" == *'Entries tagged - "default"'*'DEFAULT TERM CONTENT'*'Alpha Entry'* ]] || return 1
    term_style_expect_complete_list "$page" || return 1
    [[ "$(htmlq -f "$page" -t '.posts .meta')" == *'2026-08-24'*'2026-08-21'* ]]
}

term_style_rt_84_2() {
    local page
    local ordered
    page="$(term_style_page production tags/default true)" || return 1
    ordered="$(htmlq -f "$page" -t 'h1, .page-content, ul.posts')"
    [[ "$ordered" == *'Entries tagged - "default"'*'DEFAULT TERM CONTENT'*'Draft Entry'* ]] || return 1
    [[ "$(htmlq -f "$page" -t '.posts .draft-label')" == 'DRAFT' ]]
}

term_style_rt_84_3() {
    local page
    page="$(term_style_page production tags/default)" || return 1
    [[ -z "$(htmlq -f "$page" -t '.posts a' | rg 'Excluded (Page|Secret) Entry')" ]]
}

term_style_rt_84_4() {
    local page
    page="$(term_style_page production tags/default)" || return 1
    [[ -z "$(htmlq -f "$page" '.masonry-grid, nav.pagination')" ]] || return 1
    ! term_style_has_script "$page" 'js/masonry-init.js'
}

term_style_rt_84_5() {
    local page
    local ordered
    page="$(term_style_page cards tags/default)" || return 1
    ordered="$(htmlq -f "$page" -t 'h1, .page-content, .masonry-grid')"
    [[ "$ordered" == *'Entries tagged - "default"'*'DEFAULT TERM CONTENT'*'Alpha Entry'* ]] || return 1
    [[ "$(term_style_card_titles "$page")" == $'Alpha Entry\nBravo Entry' ]] || return 1
    [[ "$(htmlq -f "$page" -t '.masonry-item .read-more-btn')" == $'Read entry\nRead entry' ]] || return 1
    [[ -z "$(htmlq -f "$page" '.masonry-section')" ]]
}

term_style_rt_84_6() {
    local first
    local second
    first="$(term_style_page cards tags/default)" || return 1
    second="$(term_style_page cards tags/default/page/2)" || return 1
    [[ "$(term_style_card_titles "$first")" == $'Alpha Entry\nBravo Entry' ]] || return 1
    [[ "$(term_style_card_titles "$second")" == $'Charlie Entry\nDelta Entry' ]] || return 1
    [[ "$(htmlq -f "$first" -a href '.pagination-next > a')" == '/tags/default/page/2/' ]]
}

term_style_rt_84_7() {
    local first
    local second
    first="$(term_style_page cards tags/default)" || return 1
    second="$(term_style_page cards tags/default/page/2)" || return 1
    [[ -z "$(htmlq -f "$first" -t '.masonry-grid' | rg 'Excluded (Page|Secret) Entry')" ]] || return 1
    [[ -z "$(htmlq -f "$second" -t '.masonry-grid' | rg 'Excluded (Page|Secret) Entry')" ]] || return 1
    [[ -z "$(htmlq -f "$first" 'a[href="/tags/default/page/3/"]')" ]]
}

term_style_rt_84_8() {
    local page
    page="$(term_style_page cards tags/default)" || return 1
    term_style_has_script "$page" 'js/masonry-init.js' || return 1
    [[ -z "$(htmlq -f "$page" '.carousel-container, .carousel-card, script[src$="js/carousel.js"]')" ]]
}

term_style_rt_84_9() {
    local page
    page="$(term_style_page production tags/override-cards)" || return 1
    [[ "$(term_style_card_titles "$page")" == $'Alpha Entry\nBravo Entry' ]] || return 1
    term_style_has_script "$page" 'js/masonry-init.js'
}

term_style_rt_84_10() {
    local page
    page="$(term_style_page cards tags/override-list)" || return 1
    term_style_expect_complete_list "$page"
}

term_style_rt_84_11() {
    local cards_page
    local list_page
    local cards_order
    local list_order
    cards_page="$(term_style_page production tags/override-cards)" || return 1
    list_page="$(term_style_page cards tags/override-list)" || return 1
    cards_order="$(htmlq -f "$cards_page" -t 'h1, .page-content, .masonry-grid')"
    list_order="$(htmlq -f "$list_page" -t 'h1, .page-content, ul.posts')"
    [[ "$cards_order" == *'override-cards'*'OVERRIDE CARDS TERM CONTENT'*'Alpha Entry'* ]] || return 1
    [[ "$list_order" == *'override-list'*'OVERRIDE LIST TERM CONTENT'*'Alpha Entry'* ]] || return 1
    [[ -z "$(htmlq -f "$cards_page" -t '.masonry-grid' | rg 'Excluded (Page|Secret) Entry')" ]] || return 1
    [[ -z "$(htmlq -f "$list_page" -t '.posts' | rg 'Excluded (Page|Secret) Entry')" ]]
}

term_style_rt_84_12() {
    local build_dir
    local page
    build_dir="$(build_examplesite)" || return 1
    page="$build_dir/tags/theme/index.html"
    [[ -f "$page" ]] || return 1
    [[ -n "$(htmlq -f "$page" '.masonry-grid > .masonry-item h3 > a')" ]] || return 1
    term_style_has_script "$page" 'js/masonry-init.js'
}

term_style_rt_84_13() {
    local invalid_site
    local invalid_term
    invalid_site="$(term_style_page invalid tags/default)" || return 1
    invalid_term="$(term_style_page production tags/invalid-term)" || return 1
    term_style_expect_complete_list "$invalid_site" || return 1
    term_style_expect_complete_list "$invalid_term"
}

term_style_rt_84_14() {
    local page
    page="$(term_style_page cards tags/invalid-term)" || return 1
    [[ "$(term_style_card_titles "$page")" == $'Alpha Entry\nBravo Entry' ]] || return 1
    term_style_has_script "$page" 'js/masonry-init.js'
}

term_style_rt_84_15() {
    local page
    local ordered
    page="$(term_style_page summary tags/default)" || return 1
    ordered="$(htmlq -f "$page" -t '.page-header, .page-content, .list-view')"
    [[ "$ordered" == *'Entries tagged - "default"'*'Default term description.'*'DEFAULT TERM CONTENT'*'Alpha Entry'* ]] || return 1
    [[ "$(term_style_summary_titles "$page")" == $'Alpha Entry\nBravo Entry' ]] || return 1
    [[ "$(htmlq -f "$page" -t '.list-view-summary')" == $'Alpha card description.\nBravo card description.' ]] || return 1
    [[ "$(htmlq -f "$page" -t '.list-view-section')" == $'Articles\nArticles' ]] || return 1
    [[ "$(htmlq -f "$page" -a href '.pagination-next > a')" == '/tags/default/page/2/' ]] || return 1
    [[ -z "$(htmlq -f "$page" '.masonry-grid, ul.posts, script[src$="js/masonry-init.js"]')" ]]
}

term_style_rt_84_16() {
    local page
    page="$(term_style_page summary tags/default/page/2)" || return 1
    [[ "$(term_style_summary_titles "$page")" == $'Charlie Entry\nDelta Entry' ]] || return 1
    [[ -z "$(htmlq -f "$page" -t '.list-view' | rg 'Excluded (Page|Secret) Entry')" ]] || return 1
    [[ -z "$(htmlq -f "$page" 'a[href="/tags/default/page/3/"]')" ]]
}

term_style_rt_84_17() {
    local page
    local ordered
    page="$(term_style_page cards tags/override-summary)" || return 1
    ordered="$(htmlq -f "$page" -t '.page-header, .page-content, .list-view')"
    [[ "$ordered" == *'Override Summary Term'*'Override summary description.'*'OVERRIDE SUMMARY TERM CONTENT'*'Alpha Entry'* ]] || return 1
    [[ "$(term_style_summary_titles "$page")" == $'Alpha Entry\nBravo Entry' ]] || return 1
    [[ -z "$(htmlq -f "$page" '.masonry-grid, ul.posts, script[src$="js/masonry-init.js"]')" ]]
}

run_term_style_case() {
    local test_id="$1"
    local function_name="term_style_rt_${test_id//./_}"
    if ! declare -F "$function_name" >/dev/null; then
        printf '    missing term-list-style helper for RT-%s\n' "$test_id" >&2
        return 1
    fi
    "$function_name"
}
