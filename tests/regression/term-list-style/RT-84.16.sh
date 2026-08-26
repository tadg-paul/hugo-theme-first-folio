#!/usr/bin/env bash
# shellcheck shell=bash
# ABOUTME: RT-84.16 rendered taxonomy summary-list regression.
# ABOUTME: Verifies filtered pagination across the richer row presentation.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    run_term_style_case '84.16'
}
