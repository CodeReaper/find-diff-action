#!/bin/sh

set -e

export PATHS=.github/workflows/
export GITHUB_EVENT_NAME=pull_request
MOCKED_DATA_DIFF="$(mock-data pull-request)"
export MOCKED_DATA_DIFF

ACTION=$(readlink -fem "$1")

sh "$ACTION" >/dev/null || {
  printf 'Did not exit cleanly.\n'
  exit 1
}

printf 'list<<hashhashhash
.github/workflows/
hashhashhash
pattern=^.github/workflows/
matches=true
' >"$TMP/expected"

diff -q "$TMP/expected" "$GITHUB_OUTPUT" || {
  echo "Unexpected difference:"
  diff "$TMP/expected" "$GITHUB_OUTPUT"
  exit 1
}
