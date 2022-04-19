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

clear_all_builds () {
    rm -rf "$ROOT/packages/liveblocks-"*"/lib"
}

test_client () {
    clear_all_builds
    npm install
    tsc --noEmit
    eslint src
    jest
}

test_secondary_pkg () {
    clear_all_builds
    npm install
    link-liveblocks.sh -f
    tsc --noEmit
    eslint src
    jest
    npm run build
}

err_context () {
    echo "^^^ Errors happened in $1" >&2
    exit 2
}

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
