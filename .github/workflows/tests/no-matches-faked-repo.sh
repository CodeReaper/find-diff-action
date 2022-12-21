#!/bin/sh

export PATHS=stuff
export TYPE=directories
export MINDEPTH=1
export MAXDEPTH=1

export GITHUB_EVENT_NAME=pull_request
export MOCKED_GIT_DIFF='   .github/workflows/does-not-exist.yml | 38 +++++++++++++-------------------------
   .github/workflows/does-not-exist.yml | 38 +++++++++++++-------------------------
   2 files changed, 26 insertions(+), 50 deletions(-)'

ACTION=$(readlink -fem "$1")
REPO="$TMP/fake-repo"
mkdir "$REPO"
cd "$REPO" || exit 2

mkdir -p "$REPO/.git"
mkdir -p "$REPO/stuff/one"
mkdir -p "$REPO/stuff/two"

bash "$ACTION" >/dev/null || {
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
