#!/bin/sh
set -eu

# Ensure this script can assume it's run from the repo's
# root directory, even if the current working directory is
# different.
ROOT="$HOME/Projects/liveblocks/liveblocks"
if [ "$(pwd)" != "$ROOT" ]; then
    ( cd "$ROOT" && exec "$0" "$@" )
    exit $?
fi

err () {
    echo "$@" >&2
}

usage () {
    err "usage: test-all.sh [-hpec]"
    err
    err "Runs test suites."
    err
    err "Options:"
    err "-h    Show this help"
    err "-p    Run tests for all packages"
    err "-e    Run E2E tests (slow)"
    err "-c    Run Cloudflare tests (slow)"
}

run_packages=0
run_e2e=0
run_cloudflare=0
while getopts hpec flag; do
    case "$flag" in
        p) run_packages=1 ;;
        e) run_e2e=1 ;;
        c) run_cloudflare=1 ;;
        *) usage; exit 2;;
    esac
done
shift $(($OPTIND - 1))

if [ "$run_packages" -eq 0 -a "$run_e2e" -eq 0 -a "$run_cloudflare" -eq 0 ]; then
    usage
    exit 1
fi

CLOUDFLARE_ROOT="$HOME/Projects/liveblocks/liveblocks-cloudflare"

test_client () {
    chronic npm install
    chronic node_modules/.bin/tsc --noEmit
    chronic node_modules/.bin/eslint src
    chronic node_modules/.bin/jest
}

test_secondary_pkg () {
    chronic link-liveblocks.sh
    chronic node_modules/.bin/tsc --noEmit
    chronic node_modules/.bin/eslint src
    chronic node_modules/.bin/jest
    npm run build
}

test_cloudflare () {
    rm -rf node_modules
    chronic npm install
    chronic "$ROOT/scripts/link-liveblocks.sh"
    node_modules/.bin/tsc
    npm run test
}

test_e2e () {
    rm -rf node_modules .next
    chronic npm install
    chronic link-liveblocks.sh
    npm run test
}

err_context () {
    err "^^^ Errors happened in $1"
    exit 2
}

# Clear all builds
rm -rf "$ROOT/packages/liveblocks-"*"/{lib,node_modules}"
rm -rf "$ROOT/e2e/next-sandbox/{lib,node_modules,.next}"

if [ "$run_packages" -eq 1 ]; then
    err ""
    err "===== @liveblocks/client ====================================================="
    ( cd packages/liveblocks-client && test_client ) || err_context "liveblocks-client"

    err ""
    err "===== @liveblocks/react ======================================================"
    ( cd packages/liveblocks-react && test_secondary_pkg ) || err_context "liveblocks-react"

    err ""
    err "===== @liveblocks/redux ======================================================"
    ( cd packages/liveblocks-redux && test_secondary_pkg ) || err_context "liveblocks-redux"

    err ""
    err "===== @liveblocks/zustand ===================================================="
    ( cd packages/liveblocks-zustand && test_secondary_pkg ) || err_context "liveblocks-zustand"
else
    err "==> Skipping package tests"
fi

if [ "$run_cloudflare" -eq 1 ]; then
    err ""
    err "===== liveblocks-cloudflare =================================================="
    ( cd "$CLOUDFLARE_ROOT" && test_cloudflare ) || err_context "liveblocks-cloudflare"
else
    err "==> Skipping Cloudflare tests"
fi

if [ "$run_e2e" -eq 1 ]; then
    err ""
    err "===== Liveblocks E2E test suite =============================================="
    ( cd e2e/next-sandbox && test_e2e ) || err_context "next-sandbox"
else
    err "==> Skipping E2E tests"
fi
