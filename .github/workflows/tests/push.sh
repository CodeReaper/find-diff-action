#!/bin/sh

set -e

export GITHUB_EVENT_NAME=push
MOCKED_DATA_DIFF="$(mock-data push)"
export MOCKED_DATA_DIFF

sh "$1" >/dev/null || {
  printf 'Did not exit cleanly.\n'
  exit 1
}

sequence=$(printf "LICENSE\nREADME.md" | sort)
{
  printf 'list<<hashhashhash\n'
  echo "$sequence"
  printf 'hashhashhash\npattern=^'
  printf "%s" "$sequence" | tr '\n' ' ' | sed 's/ /|^/g'
  printf "\n"
  printf "matches=true\n"
} >"$TMP/expected"

diff -q "$TMP/expected" "$GITHUB_OUTPUT" || {
  echo "Unexpected difference:"
  diff "$TMP/expected" "$GITHUB_OUTPUT"
  exit 1
}
