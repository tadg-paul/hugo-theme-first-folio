# shellcheck shell=bash
# ABOUTME: RT-83.18 - the linked built stylesheet delivers responsive and accessibility rules.
# ABOUTME: Exercises visitor-visible output from a Hugo-rendered route.

# What user action does this test simulate?
#   A visitor loads the prepared tag-cloud route in the generated site.
# What would the user observe?
#   The linked built stylesheet delivers responsive and accessibility rules.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    run_tagcloud_case "83.18"
}
