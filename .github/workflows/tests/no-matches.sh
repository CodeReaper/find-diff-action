#!/bin/sh

set -eo pipefail

export GITHUB_EVENT_NAME=pull_request
export MOCKED_GIT_DIFF='   .github/workflows/does-not-exist.yml | 38 +++++++++++++-------------------------
   .github/workflows/does-not-exist.yml | 38 +++++++++++++-------------------------
   2 files changed, 26 insertions(+), 50 deletions(-)'

sh "$1" >/dev/null || {
    printf 'Did not exit cleanly.\n'
    exit 1
}

printf 'list=
pattern=
' >"$TMP/expected"

diff -q "$TMP/expected" "$GITHUB_OUTPUT" || {
    echo "Unexpected difference:"
    diff "$TMP/expected" "$GITHUB_OUTPUT"
    exit 1
}
