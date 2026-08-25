# shellcheck shell=bash
# ABOUTME: Provides rendered-site helpers for the example-site polish tracked under issue #82.
# ABOUTME: Assertions exercise the public example output and its fingerprinted visitor CSS.

example_polish_build() {
    build_examplesite
}

example_polish_page() {
    local route="${1:-}"
    local build_dir
    local page
    build_dir="$(example_polish_build)" || return 1
    if [[ -n "$route" ]]; then
        page="$build_dir/$route/index.html"
    else
        page="$build_dir/index.html"
    fi
    if [[ ! -f "$page" ]]; then
        printf '    expected rendered example page at %s\n' "$page" >&2
        return 1
    fi
    printf '%s\n' "$page"
}

example_polish_tagcloud_css() {
    local page="$1"
    local build_dir
    local href
    build_dir="$(dirname "$page")"
    href="$(htmlq -f "$page" -a href 'link[rel="stylesheet"][href*="tagcloud."]')"
    if [[ -z "$href" ]]; then
        printf '    rendered example page has no fingerprinted tag-cloud stylesheet\n' >&2
        return 1
    fi
    printf '%s/%s\n' "$build_dir" "${href#/}"
}

