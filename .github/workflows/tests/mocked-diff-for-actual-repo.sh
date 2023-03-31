#!/bin/sh

set -e

export PATHS='*.*'
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
} >"$TMP/expected"

diff -q "$TMP/expected" "$GITHUB_OUTPUT" || {
    echo "Log:"
    cat "$TMP/log"
    echo "Unexpected difference:"
    diff "$TMP/expected" "$GITHUB_OUTPUT"
    exit 1
}
