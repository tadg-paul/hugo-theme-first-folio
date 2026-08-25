# shellcheck shell=bash
# ABOUTME: RT-83.3 - the existing taxonomy-index cloud remains available by default.
# ABOUTME: Exercises visitor-visible output from a Hugo-rendered route.

# What user action does this test simulate?
#   A visitor loads the prepared tag-cloud route in the generated site.
# What would the user observe?
#   The existing taxonomy-index cloud remains available by default.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    run_tagcloud_case "83.3"
}
