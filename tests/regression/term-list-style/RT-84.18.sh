#!/usr/bin/env bash
# shellcheck shell=bash
# ABOUTME: RT-84.18 rendered example-site term-presentation regression.
# ABOUTME: Verifies summary defaults alongside a term-level cards override.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    run_term_style_case '84.18'
}
