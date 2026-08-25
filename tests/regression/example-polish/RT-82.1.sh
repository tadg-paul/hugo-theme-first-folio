# shellcheck shell=bash
# ABOUTME: RT-82.1 - the example homepage starts with the compact, unlabelled tag cloud.
# ABOUTME: It also demonstrates system-following ambience without forcing dark mode.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    local cloud_style
    page="$(example_polish_page)" || return 1
    cloud_style="$(htmlq -f "$page" -a style '.homepage-content > .tagcloud')"

    [[ -z "$(htmlq -f "$page" '.site-description')" ]] || return 1
    [[ -z "$(htmlq -f "$page" -t '.homepage-content h2')" ]] || return 1
    [[ "$cloud_style" == *'--tagcloud-base: 0.7rem;'* ]] || return 1
    [[ "$cloud_style" == *'--tagcloud-multiplier: 2.2;'* ]] || return 1
    [[ "$cloud_style" == *'--tagcloud-text-opacity: 0.6;'* ]] || return 1
    grep -qF "var defaultTheme = 'auto';" "$page"
}

