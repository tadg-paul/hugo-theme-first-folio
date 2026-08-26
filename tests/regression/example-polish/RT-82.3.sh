# shellcheck shell=bash
# ABOUTME: RT-82.3 - the example navigation demonstrates opt-in buttons and nested menus.
# ABOUTME: Tags are discoverable from the cloud rather than duplicated in the top bar.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    local top_links
    local css_file
    page="$(example_polish_page)" || return 1
    top_links="$(htmlq -f "$page" -t '#main-nav > a.nav-item')"
    css_file="$(example_polish_theme_css "$page")" || return 1

    [[ -n "$(htmlq -f "$page" '#main-nav.nav--buttons')" ]] || return 1
    [[ "$top_links" == $'Home\nProfile' ]] || return 1
    [[ "$(htmlq -f "$page" -t '#main-nav > details.nav-group > summary')" == $'Explore\nReviews' ]] || return 1
    [[ "$(htmlq -f "$page" -a href '#main-nav > details.nav-group:first-of-type .nav-submenu a')" == $'/recipes/\n/journal/\n/photography/\n/stories/\n/poetry/' ]] || return 1
    [[ "$(htmlq -f "$page" -a href '#main-nav > details.nav-group:last-of-type .nav-submenu a')" == $'/book-reviews/\n/game-reviews/' ]] || return 1
    [[ "$(htmlq -f "$page" -t '#main-nav')" != *'Tags'* ]] || return 1
    grep -qF 'font-family: var(--font-heading);' "$css_file" || return 1
    grep -qF 'font-weight: 700;' "$css_file" || return 1
    grep -qF 'border-radius: 0.65rem;' "$css_file" || return 1
    grep -qF 'border: 1px solid color-mix(in srgb, var(--text-color) 22%, transparent);' "$css_file" || return 1
    grep -qF 'animation: none;' "$css_file"
}
