# shellcheck shell=bash
# ABOUTME: RT-82.2 - the demo disclaimer and About link live in the standard footer.
# ABOUTME: The linked About page explains that the example content is fictitious.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local home
    local about
    home="$(example_polish_page)" || return 1
    about="$(example_polish_page about)" || return 1

    [[ "$(htmlq -f "$home" -t '.footer-info')" == *'All content and authors are fictitious.'* ]] || return 1
    [[ "$(htmlq -f "$home" -a href '.footer-info a')" == *'/about/'* ]] || return 1
    [[ "$(htmlq -f "$about" -t 'main')" == *'First Folio theme'* ]] || return 1
    [[ "$(htmlq -f "$about" -t 'main')" == *'fictitious'* ]]
}

