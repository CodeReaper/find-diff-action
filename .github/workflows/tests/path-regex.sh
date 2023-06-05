#!/bin/sh

set -e

export GITHUB_EVENT_NAME=push
MOCKED_DATA_DIFF="$(mock-data diff)"
export MOCKED_DATA_DIFF

export TEST_SCRIPT="$1"
hit_test() {
  printf '' >"$GITHUB_OUTPUT"

  sh "$TEST_SCRIPT" >"$TMP/log" || {
    printf 'Did not exit cleanly.\n'
    exit 1
  }

  sequence="$SEQUENCE"
  {
    printf 'list<<hashhashhash\n'
    echo "$sequence"
    printf 'hashhashhash\npattern=^'
    printf "%s" "$sequence" | tr '\n' ' ' | sed 's/ /|^/g'
    printf "\n"
    printf "matches=true\n"

  } >"$TMP/expected"

  diff -q "$TMP/expected" "$GITHUB_OUTPUT" || {
    echo "Log #$TEST:"
    cat "$TMP/log"
    echo "Unexpected difference:"
    diff "$TMP/expected" "$GITHUB_OUTPUT"
    exit 1
  }
}

miss_test() {
  printf '' >"$GITHUB_OUTPUT"

  sh "$TEST_SCRIPT" >"$TMP/log" || {
    printf 'Did not exit cleanly.\n'
    exit 1
  }

  sequence="$SEQUENCE"
  {
    printf 'list=\n'
    printf 'pattern=\n'
    printf "matches=false\n"
  } >"$TMP/expected"

  diff -q "$TMP/expected" "$GITHUB_OUTPUT" || {
    echo "Log #$TEST:"
    cat "$TMP/log"
    echo "Unexpected difference:"
    diff "$TMP/expected" "$GITHUB_OUTPUT"
    exit 1
  }
}

export TEST=1
export PATHS='.devcontainer/**'
SEQUENCE=$(printf ".devcontainer/devcontainer.json\n.devcontainer/Dockerfile" | sort)
export SEQUENCE
hit_test

export TEST=2
export PATHS='.github/**/*.sh'
SEQUENCE=$(printf ".github/workflows/test-wrapper.sh" | sort)
export SEQUENCE
hit_test

export TEST=3
export PATHS='LIC*'
SEQUENCE=$(printf "LICENSE" | sort)
export SEQUENCE
hit_test

export TEST=4
export PATHS='*/'
SEQUENCE=$(printf ".devcontainer/\n.github/\n.vscode/" | sort)
export SEQUENCE
hit_test

export TEST=5
export PATHS='.devcontainer/** .github/**/*.sh'
SEQUENCE=$(printf ".devcontainer/devcontainer.json\n.devcontainer/Dockerfile\n.github/workflows/test-wrapper.sh" | sort)
export SEQUENCE
hit_test

export TEST=6
export PATHS='not-a-folder/'
SEQUENCE=""
export SEQUENCE
miss_test

export TEST=7
export PATHS='not-there/** **/*.not-there'
SEQUENCE=""
export SEQUENCE
miss_test

export TEST=8
export PATHS='.github/**/'
SEQUENCE=$(printf ".github/workflows/" | sort)
export SEQUENCE
hit_test

export TEST=9
export PATHS='not-a-folder/ .github/**/'
SEQUENCE=$(printf ".github/workflows/" | sort)
export SEQUENCE
hit_test
