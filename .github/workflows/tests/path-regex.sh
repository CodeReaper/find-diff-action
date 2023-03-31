#!/bin/sh

set -e

export GITHUB_EVENT_NAME=push
export MOCKED_GIT_DIFF=' .devcontainer/Dockerfile             |  4 ++++
 .devcontainer/devcontainer.json      | 17 +++++++++++++++++
 .github/workflows/test-wrapper.sh    | 26 ++++++++++++++++++++++++++
 .github/workflows/test.yaml          | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 .gitignore                           | 36 ++++++++++++++++++++++++++++++++++++
 .vscode/extensions.json              |  8 ++++++++
 .vscode/settings.json                |  3 +++
 LICENSE                              |  2 +-
 action.yaml                          | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 test.sh                              |  4 ++++
 12 files changed, 266 insertions(+), 1 deletion(-)
'

TEST=1

printf '' >"$GITHUB_OUTPUT"
export PATHS='.devcontainer/**'

sh "$1" >"$TMP/log" || {
    printf 'Did not exit cleanly.\n'
    exit 1
}

sequence=$(printf ".devcontainer/devcontainer.json\n.devcontainer/Dockerfile" | sort)
{
    printf 'list<<hashhashhash\n'
    echo "$sequence"
    printf 'hashhashhash\npattern=^'
    printf "%s" "$sequence" | tr '\n' ' ' | sed 's/ /|^/g'
    printf "\n"
} >"$TMP/expected"

diff -q "$TMP/expected" "$GITHUB_OUTPUT" || {
    echo "Log #$TEST:"
    cat "$TMP/log"
    echo "Unexpected difference:"
    diff "$TMP/expected" "$GITHUB_OUTPUT"
    exit 1
}

TEST=2

printf '' >"$GITHUB_OUTPUT"
export PATHS='.github/**/*.sh'

sh "$1" >"$TMP/log" || {
    printf 'Did not exit cleanly.\n'
    exit 1
}

sequence=$(printf ".github/workflows/test-wrapper.sh" | sort)
{
    printf 'list<<hashhashhash\n'
    echo "$sequence"
    printf 'hashhashhash\npattern=^'
    printf "%s" "$sequence" | tr '\n' ' ' | sed 's/ /|^/g'
    printf "\n"
} >"$TMP/expected"

diff -q "$TMP/expected" "$GITHUB_OUTPUT" || {
    echo "Log #$TEST:"
    cat "$TMP/log"
    echo "Unexpected difference:"
    diff "$TMP/expected" "$GITHUB_OUTPUT"
    exit 1
}

TEST=3

printf '' >"$GITHUB_OUTPUT"
export PATHS='.github/*/*.sh'

sh "$1" >"$TMP/log" || {
    printf 'Did not exit cleanly.\n'
    exit 1
}

sequence=$(printf ".github/workflows/test-wrapper.sh" | sort)
{
    printf 'list<<hashhashhash\n'
    echo "$sequence"
    printf 'hashhashhash\npattern=^'
    printf "%s" "$sequence" | tr '\n' ' ' | sed 's/ /|^/g'
    printf "\n"
} >"$TMP/expected"

diff -q "$TMP/expected" "$GITHUB_OUTPUT" || {
    echo "Log #$TEST:"
    cat "$TMP/log"
    echo "Unexpected difference:"
    diff "$TMP/expected" "$GITHUB_OUTPUT"
    exit 1
}

TEST=4

printf '' >"$GITHUB_OUTPUT"
export PATHS='LIC*'

sh "$1" >"$TMP/log" || {
    printf 'Did not exit cleanly.\n'
    exit 1
}

sequence=$(printf "LICENSE" | sort)
{
    printf 'list<<hashhashhash\n'
    echo "$sequence"
    printf 'hashhashhash\npattern=^'
    printf "%s" "$sequence" | tr '\n' ' ' | sed 's/ /|^/g'
    printf "\n"
} >"$TMP/expected"

diff -q "$TMP/expected" "$GITHUB_OUTPUT" || {
    echo "Log #$TEST:"
    cat "$TMP/log"
    echo "Unexpected difference:"
    diff "$TMP/expected" "$GITHUB_OUTPUT"
    exit 1
}

TEST=5

printf '' >"$GITHUB_OUTPUT"
export PATHS='*/'

sh "$1" >"$TMP/log" || {
    printf 'Did not exit cleanly.\n'
    exit 1
}

sequence=$(printf ".devcontainer/\n.github/\n.vscode/" | sort)
{
    printf 'list<<hashhashhash\n'
    echo "$sequence"
    printf 'hashhashhash\npattern=^'
    printf "%s" "$sequence" | tr '\n' ' ' | sed 's/ /|^/g'
    printf "\n"
} >"$TMP/expected"

diff -q "$TMP/expected" "$GITHUB_OUTPUT" || {
    echo "Log #$TEST:"
    cat "$TMP/log"
    echo "Unexpected difference:"
    diff "$TMP/expected" "$GITHUB_OUTPUT"
    exit 1
}

TEST=6

printf '' >"$GITHUB_OUTPUT"
export PATHS='.devcontainer/** .github/**/*.sh'

sh "$1" >"$TMP/log" || {
    printf 'Did not exit cleanly.\n'
    exit 1
}

sequence=$(printf ".devcontainer/devcontainer.json\n.devcontainer/Dockerfile\n.github/workflows/test-wrapper.sh" | sort)
{
    printf 'list<<hashhashhash\n'
    echo "$sequence"
    printf 'hashhashhash\npattern=^'
    printf "%s" "$sequence" | tr '\n' ' ' | sed 's/ /|^/g'
    printf "\n"
} >"$TMP/expected"

diff -q "$TMP/expected" "$GITHUB_OUTPUT" || {
    echo "Log #$TEST:"
    cat "$TMP/log"
    echo "Unexpected difference:"
    diff "$TMP/expected" "$GITHUB_OUTPUT"
    exit 1
}

TEST=7

printf '' >"$GITHUB_OUTPUT"
export PATHS='not-there/** **/*.not-there'

sh "$1" >"$TMP/log" || {
    printf 'Did not exit cleanly.\n'
    exit 1
}

printf 'list=\npattern=\n' >"$TMP/expected"

diff -q "$TMP/expected" "$GITHUB_OUTPUT" || {
    echo "Log #$TEST:"
    cat "$TMP/log"
    echo "Unexpected difference:"
    diff "$TMP/expected" "$GITHUB_OUTPUT"
    exit 1
}
