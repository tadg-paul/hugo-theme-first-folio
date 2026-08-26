# shellcheck shell=bash
# ABOUTME: RT-82.3 - the example navigation demonstrates opt-in buttons and nested menus.
# ABOUTME: Tags are discoverable from the cloud rather than duplicated in the top bar.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    local top_links
    page="$(example_polish_page)" || return 1
    top_links="$(htmlq -f "$page" -t '#main-nav > a.nav-item')"

    [[ -n "$(htmlq -f "$page" '#main-nav.nav--buttons')" ]] || return 1
    [[ "$top_links" == $'Home\nProfile' ]] || return 1
    [[ "$(htmlq -f "$page" -t '#main-nav > a.nav-item-active, #main-nav > details > summary.nav-item-active')" == 'Home' ]] || return 1
    [[ "$(htmlq -f "$page" -t '#main-nav > details.nav-group > summary')" == $'Explore\nReviews' ]] || return 1
    [[ "$(htmlq -f "$page" -a name '#main-nav > details.nav-group')" == $'main-navigation-group\nmain-navigation-group' ]] || return 1
    [[ "$(htmlq -f "$page" -a href '#main-nav > details.nav-group:first-of-type .nav-submenu a')" == $'/recipes/\n/journal/\n/photography/\n/stories/\n/poetry/' ]] || return 1
    [[ "$(htmlq -f "$page" -a href '#main-nav > details.nav-group:last-of-type .nav-submenu a')" == $'/book-reviews/\n/game-reviews/' ]] || return 1
    [[ "$(htmlq -f "$page" -t '#main-nav')" != *'Tags'* ]]
}
