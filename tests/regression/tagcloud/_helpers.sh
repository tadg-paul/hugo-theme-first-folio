# shellcheck shell=bash
# ABOUTME: Provides rendered-site helpers and assertions for issue #83 tag-cloud tests.
# ABOUTME: Every assertion targets Hugo output or the fingerprinted CSS delivered to visitors.

tagcloud_build() {
    local fixture="$1"
    build_fixture "$fixture"
}

tagcloud_page() {
    local fixture="$1"
    local route="$2"
    local build_dir
    local page
    build_dir="$(tagcloud_build "$fixture")" || return 1
    page="$build_dir/$route/index.html"
    if [[ ! -f "$page" ]]; then
        printf '    expected rendered tag-cloud page at %s\n' "$page" >&2
        return 1
    fi
    printf '%s\n' "$page"
}

tagcloud_fresh_build() {
    local fixture="$1"
    local out
    out="$(mktemp -d "$REGRESSION_TMP/ff-${fixture}-XXXXXX")"
    if ! hugo --quiet --source "$FIXTURES_ROOT/$fixture" --destination "$out" \
        --themesDir "$THEME_ROOT/.." --theme "$(basename "$THEME_ROOT")"; then
        printf '    fresh Hugo build failed for %s\n' "$fixture" >&2
        return 1
    fi
    printf '%s\n' "$out"
}

tagcloud_links() {
    local page="$1"
    htmlq -f "$page" -a href '.tagcloud-link'
}

tagcloud_terms() {
    local page="$1"
    htmlq -f "$page" -t '.tagcloud-link'
}

tagcloud_styles() {
    local page="$1"
    htmlq -f "$page" -a style '.tagcloud-term'
}

tagcloud_css_file() {
    local build_dir="$1"
    local page="$2"
    local href
    href="$(htmlq -f "$page" -a href 'link[rel="stylesheet"][href*="tagcloud."]')"
    if [[ -z "$href" ]]; then
        printf '    rendered page has no fingerprinted tag-cloud stylesheet\n' >&2
        return 1
    fi
    printf '%s/%s\n' "$build_dir" "${href#/}"
}

tagcloud_expect_no_generic_output() {
    local page="$1"
    [[ -z "$(htmlq -f "$page" '.tagcloud')" ]] || return 1
    [[ -z "$(htmlq -f "$page" 'link[rel="stylesheet"][href*="tagcloud."]')" ]]
}

tagcloud_extract_hue() {
    local style="$1"
    if [[ "$style" =~ --tagcloud-hue:[[:space:]]*([0-9]+) ]]; then
        printf '%s\n' "${BASH_REMATCH[1]}"
        return 0
    fi
    printf '    no tag-cloud hue in rendered style: %s\n' "$style" >&2
    return 1
}

tagcloud_rt_83_1() {
    local page
    page="$(tagcloud_page tagcloud-default cloud-shortcode)" || return 1
    tagcloud_expect_no_generic_output "$page"
}

tagcloud_rt_83_2() {
    local page
    page="$(tagcloud_page tagcloud-disabled cloud-shortcode)" || return 1
    tagcloud_expect_no_generic_output "$page"
}

tagcloud_rt_83_3() {
    local page
    page="$(tagcloud_page tagcloud-default tags)" || return 1
    [[ -n "$(htmlq -f "$page" '.tag-cloud .tags a[href="/tags/alpha/"]')" ]]
}

tagcloud_rt_83_4() {
    local page
    page="$(tagcloud_page tagcloud-enabled cloud-default)" || return 1
    [[ "$(tagcloud_links "$page")" == $'/tags/alpha/\n/tags/beta/\n/tags/extraordinarylongterm/\n/tags/gamma/\n/tags/zeta/' ]]
}

tagcloud_rt_83_5() {
    local page
    page="$(tagcloud_page tagcloud-enabled cloud-custom)" || return 1
    [[ "$(tagcloud_links "$page")" == $'/series/series-one/\n/series/series-two/' ]]
}

tagcloud_rt_83_6() {
    local page
    local ranks
    local styles
    page="$(tagcloud_page tagcloud-enabled cloud-default)" || return 1
    ranks="$(htmlq -f "$page" -a data-rank '.tagcloud-term')"
    styles="$(tagcloud_styles "$page")"
    [[ "$ranks" == $'1\n3\n4\n5\n2' ]] || return 1
    [[ "$styles" == *'--tagcloud-weight: 1.000;'* ]] || return 1
    [[ "$styles" == *'--tagcloud-weight: 0.000;'* ]]
}

tagcloud_rt_83_7() {
    local page
    local styles
    page="$(tagcloud_page tagcloud-enabled cloud-equal)" || return 1
    styles="$(tagcloud_styles "$page")"
    [[ "$(tagcloud_terms "$page")" == $'blue\nred' ]] || return 1
    [[ "$(printf '%s\n' "$styles" | grep -c -- '--tagcloud-weight: 1.000;')" -eq 2 ]] || return 1
    [[ "$styles" != *NaN* && "$styles" != *Inf* ]]
}

tagcloud_rt_83_8() {
    local first
    local second
    first="$(tagcloud_fresh_build tagcloud-enabled)" || return 1
    second="$(tagcloud_fresh_build tagcloud-enabled)" || return 1
    [[ "$(tagcloud_styles "$first/cloud-default/index.html")" == "$(tagcloud_styles "$second/cloud-default/index.html")" ]]
}

tagcloud_rt_83_9() {
    local default_page
    local counts_page
    default_page="$(tagcloud_page tagcloud-enabled cloud-default)" || return 1
    counts_page="$(tagcloud_page tagcloud-enabled cloud-counts)" || return 1
    [[ -z "$(htmlq -f "$default_page" '.tagcloud-count')" ]] || return 1
    [[ "$(htmlq -f "$counts_page" -a aria-hidden '.tagcloud-count')" == $'true\ntrue\ntrue\ntrue\ntrue' ]]
}

tagcloud_rt_83_10() {
    local page
    page="$(tagcloud_page tagcloud-enabled cloud-min-count)" || return 1
    [[ "$(tagcloud_terms "$page")" == $'alpha\nbeta\nzeta' ]]
}

tagcloud_rt_83_11() {
    local limited
    local unlimited
    limited="$(tagcloud_page tagcloud-enabled cloud-limit-two)" || return 1
    unlimited="$(tagcloud_page tagcloud-enabled cloud-limit-all)" || return 1
    [[ "$(tagcloud_terms "$limited")" == $'alpha\nzeta' ]] || return 1
    [[ "$(htmlq -f "$unlimited" '.tagcloud-term' | grep -c 'tagcloud-term')" -eq 5 ]]
}

tagcloud_rt_83_12() {
    local alpha_page
    local count_page
    alpha_page="$(tagcloud_page tagcloud-enabled cloud-alpha)" || return 1
    count_page="$(tagcloud_page tagcloud-enabled cloud-count)" || return 1
    [[ "$(tagcloud_terms "$alpha_page")" == $'alpha\nbeta\nextraordinarylongterm\ngamma\nzeta' ]] || return 1
    [[ "$(tagcloud_terms "$count_page")" == $'alpha\nzeta\nbeta\nextraordinarylongterm\ngamma' ]]
}

tagcloud_rt_83_13() {
    local linear_page
    local log_page
    linear_page="$(tagcloud_page tagcloud-enabled cloud-linear)" || return 1
    log_page="$(tagcloud_page tagcloud-enabled cloud-log)" || return 1
    [[ "$(tagcloud_styles "$linear_page")" == *'--tagcloud-weight: 0.333;'* ]] || return 1
    [[ "$(tagcloud_styles "$log_page")" == *'--tagcloud-weight: 0.500;'* ]]
}

tagcloud_rt_83_14() {
    local rows
    local columns
    local float
    rows="$(tagcloud_page tagcloud-enabled cloud-rows)" || return 1
    columns="$(tagcloud_page tagcloud-enabled cloud-columns)" || return 1
    float="$(tagcloud_page tagcloud-enabled cloud-float)" || return 1
    [[ -n "$(htmlq -f "$rows" '.tagcloud--rows')" ]] || return 1
    [[ -n "$(htmlq -f "$columns" '.tagcloud--columns')" ]] || return 1
    [[ -n "$(htmlq -f "$float" '.tagcloud--float')" ]]
}

tagcloud_rt_83_15() {
    local page
    page="$(tagcloud_page tagcloud-enabled cloud-float)" || return 1
    [[ "$(tagcloud_terms "$page")" == $'alpha\nzeta\nbeta\nextraordinarylongterm\ngamma' ]] || return 1
    [[ "$(htmlq -f "$page" -a data-rank '.tagcloud-term--float')" == '1' ]]
}

tagcloud_rt_83_16() {
    local wrap_page
    local nowrap_page
    wrap_page="$(tagcloud_page tagcloud-enabled cloud-wrap)" || return 1
    nowrap_page="$(tagcloud_page tagcloud-enabled cloud-nowrap)" || return 1
    [[ "$(htmlq -f "$wrap_page" '.tagcloud-term--wrapped' | grep -c 'tagcloud-term--wrapped')" -eq 1 ]] || return 1
    [[ "$(htmlq -f "$wrap_page" -a style '.tagcloud-term--wrapped')" == *'--tagcloud-line-ch:'* ]] || return 1
    [[ -z "$(htmlq -f "$nowrap_page" '.tagcloud-term--wrapped')" ]]
}

tagcloud_rt_83_17() {
    local configured
    local fallback
    configured="$(tagcloud_page tagcloud-enabled cloud-default)" || return 1
    fallback="$(tagcloud_page tagcloud-fallback cloud)" || return 1
    [[ "$(htmlq -f "$configured" -a style '.tagcloud')" == *'--tagcloud-base: 0.8rem;'* ]] || return 1
    [[ "$(htmlq -f "$configured" -a style '.tagcloud')" == *'--tagcloud-multiplier: 2.5;'* ]] || return 1
    [[ -z "$(htmlq -f "$fallback" -a style '.tagcloud')" ]]
}

tagcloud_rt_83_18() {
    local build_dir
    local page
    local css_file
    build_dir="$(tagcloud_build tagcloud-enabled)" || return 1
    page="$build_dir/cloud-default/index.html"
    css_file="$(tagcloud_css_file "$build_dir" "$page")" || return 1
    [[ -f "$css_file" ]] || return 1
    grep -qF '@media screen and (min-width: 48rem)' "$css_file" || return 1
    grep -qF 'html[data-theme="dark"] .tagcloud' "$css_file" || return 1
    grep -qF '.tagcloud > .tagcloud-term:focus-within' "$css_file" || return 1
    grep -qF '@media (prefers-reduced-motion: reduce)' "$css_file"
}

tagcloud_rt_83_19() {
    local build_dir
    local page
    build_dir="$(build_examplesite)" || return 1
    page="$build_dir/index.html"
    [[ -n "$(htmlq -f "$page" '.tagcloud .tagcloud-link')" ]] || return 1
    [[ -n "$(htmlq -f "$page" 'link[rel="stylesheet"][href*="tagcloud."]')" ]]
}

tagcloud_rt_83_20() {
    local default_page
    local false_page
    default_page="$(tagcloud_page tagcloud-default cloud-partial)" || return 1
    false_page="$(tagcloud_page tagcloud-disabled cloud-partial)" || return 1
    tagcloud_expect_no_generic_output "$default_page" || return 1
    tagcloud_expect_no_generic_output "$false_page"
}

tagcloud_rt_83_21() {
    local page
    page="$(tagcloud_page tagcloud-enabled cloud-unknown)" || return 1
    [[ -z "$(htmlq -f "$page" '.tagcloud')" ]]
}

tagcloud_rt_83_22() {
    local page
    page="$(tagcloud_page tagcloud-enabled cloud-partial)" || return 1
    [[ -n "$(htmlq -f "$page" '.tagcloud .tagcloud-link[href="/tags/alpha/"]')" ]] || return 1
    [[ -n "$(htmlq -f "$page" 'link[rel="stylesheet"][href*="tagcloud."]')" ]]
}

tagcloud_rt_83_23() {
    local first
    local second
    local first_styles
    local second_styles
    local alpha_hue
    local beta_hue
    first="$(tagcloud_fresh_build tagcloud-enabled)" || return 1
    second="$(tagcloud_fresh_build tagcloud-enabled)" || return 1
    first_styles="$(tagcloud_styles "$first/cloud-default/index.html")"
    second_styles="$(tagcloud_styles "$second/cloud-default/index.html")"
    [[ "$first_styles" == "$second_styles" ]] || return 1
    mapfile -t rendered_styles <<< "$first_styles"
    alpha_hue="$(tagcloud_extract_hue "${rendered_styles[0]}")" || return 1
    beta_hue="$(tagcloud_extract_hue "${rendered_styles[1]}")" || return 1
    [[ "$alpha_hue" != "$beta_hue" ]]
}

tagcloud_rt_83_24() {
    local default_page
    local false_page
    local true_page
    default_page="$(tagcloud_page tagcloud-enabled cloud-default)" || return 1
    false_page="$(tagcloud_page tagcloud-enabled cloud-counts-false)" || return 1
    true_page="$(tagcloud_page tagcloud-enabled cloud-counts)" || return 1
    [[ -z "$(htmlq -f "$default_page" '.tagcloud-count')" ]] || return 1
    [[ -z "$(htmlq -f "$false_page" '.tagcloud-count')" ]] || return 1
    [[ "$(htmlq -f "$true_page" -t '.tagcloud-count')" == $'4\n2\n1\n1\n3' ]] || return 1
    [[ "$(htmlq -f "$true_page" -a aria-hidden '.tagcloud-count')" == $'true\ntrue\ntrue\ntrue\ntrue' ]]
}

run_tagcloud_case() {
    local test_id="$1"
    local function_name="tagcloud_rt_${test_id//./_}"
    if ! declare -F "$function_name" >/dev/null; then
        printf '    missing tag-cloud helper for RT-%s\n' "$test_id" >&2
        return 1
    fi
    "$function_name"
}
