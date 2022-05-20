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
    echo "^^^ Errors happened in $1" >&2
    exit 2
}

# Clear all builds
rm -rf "$ROOT/packages/liveblocks-"*"/{lib,node_modules}"
rm -rf "$ROOT/e2e/next-sandbox/{lib,node_modules,.next}"

echo ""
echo "===== @liveblocks/client ====================================================="
( cd packages/liveblocks-client && test_client ) || err_context "liveblocks-client"

echo ""
echo "===== @liveblocks/react ======================================================"
( cd packages/liveblocks-react && test_secondary_pkg ) || err_context "liveblocks-react"

echo ""
echo "===== @liveblocks/redux ======================================================"
( cd packages/liveblocks-redux && test_secondary_pkg ) || err_context "liveblocks-redux"

echo ""
echo "===== @liveblocks/zustand ===================================================="
( cd packages/liveblocks-zustand && test_secondary_pkg ) || err_context "liveblocks-zustand"

echo ""
echo "===== liveblocks-cloudflare =================================================="
( cd "$CLOUDFLARE_ROOT" && test_cloudflare ) || err_context "liveblocks-cloudflare"

if [ "${1:-}" = "-s" ]; then
    echo "Skipping E2E test"
    exit 0
fi

echo ""
echo "===== Liveblocks E2E test suite =============================================="
( cd e2e/next-sandbox && test_e2e ) || err_context "next-sandbox"
