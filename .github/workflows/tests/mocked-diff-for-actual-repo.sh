#!/bin/sh

set -e

export PATHS='*.*'
export GITHUB_EVENT_NAME=push
MOCKED_GIT_DIFF="$(mock-data diff)"
export MOCKED_GIT_DIFF

sh "$1" >"$TMP/log" || {
  printf 'Did not exit cleanly.\n'
  exit 1
}

sequence=$(printf "action.yaml\ntest.sh" | sort)
{
  printf 'list<<hashhashhash\n'
  echo "$sequence"
  printf 'hashhashhash\npattern=^'
  printf "%s" "$sequence" | tr '\n' ' ' | sed 's/ /|^/g'
  printf "\n"
  printf "matches=true\n"
} >"$TMP/expected"

diff -q "$TMP/expected" "$GITHUB_OUTPUT" || {
  echo "Log:"
  cat "$TMP/log"
  echo "Unexpected difference:"
  diff "$TMP/expected" "$GITHUB_OUTPUT"
  exit 1
}
