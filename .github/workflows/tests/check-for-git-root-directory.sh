#!/bin/sh

set -e

ACTION=$(readlink -fem "$1")
REPO="$TMP/fake-repo"
mkdir "$REPO"
cd "$REPO" || exit 2

sh "$ACTION" >"$TMP/output" && {
    echo 'Unexpectedly exited cleanly.'
    exit 1
}

grep '::error' "$TMP/output" >/dev/null || {
    echo 'Did not print an error.'
    exit 1
}
