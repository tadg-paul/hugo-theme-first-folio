#!/usr/bin/env bash
# shellcheck shell=bash
# ABOUTME: RT-84.15 rendered taxonomy summary-list regression.
# ABOUTME: Verifies the opt-in section-style rows and term-page header.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    run_term_style_case '84.15'
}
