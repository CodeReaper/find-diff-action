#!/bin/sh

set -e

export PATHS=stuff
export GITHUB_EVENT_NAME=pull_request
MOCKED_DATA_DIFF="$(mock-data pull-request-does-not-exist)"
export MOCKED_DATA_DIFF

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
matches=false
' >"$TMP/expected"

diff -q "$TMP/expected" "$GITHUB_OUTPUT" || {
  echo "Unexpected difference:"
  diff "$TMP/expected" "$GITHUB_OUTPUT"
  exit 1
}
