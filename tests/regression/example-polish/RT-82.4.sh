# shellcheck shell=bash
# ABOUTME: RT-82.4 - configured tag-cloud opacity mutes labels until interaction.
# ABOUTME: The effect is delivered by fingerprinted CSS and respects reduced motion.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    local css_file
    page="$(example_polish_page)" || return 1
    css_file="$(example_polish_tagcloud_css "$page")" || return 1

    grep -qF 'opacity: var(--tagcloud-text-opacity, 1);' "$css_file" || return 1
    grep -qF '.tagcloud > .tagcloud-term:focus-within .tagcloud-link' "$css_file" || return 1
    grep -qF 'opacity: 1;' "$css_file" || return 1
    grep -qF 'transition: none;' "$css_file"
}

