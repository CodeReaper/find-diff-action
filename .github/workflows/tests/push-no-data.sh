#!/bin/sh

set -e

export GITHUB_EVENT_NAME=push
MOCKED_DATA_DIFF="{}"
export MOCKED_DATA_DIFF

sh "$1" >/dev/null || {
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
