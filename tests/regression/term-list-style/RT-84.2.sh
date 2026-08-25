#!/usr/bin/env bash
# shellcheck shell=bash
# ABOUTME: RT-84.2 rendered taxonomy term list/card regression.
# ABOUTME: Delegates to the shared issue #84 fixture assertions.

# What user action does this test simulate?
#   A visitor opens the configured taxonomy term route in a browser.
# What would the user observe?
#   The term uses the compatible list or explicitly selected card presentation.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    run_term_style_case '84.2'
}
