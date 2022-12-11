#!/bin/sh

export GITHUB_EVENT_NAME=push
export MOCKED_GIT_DIFF='e01d0b4c792d72cc96107b20b024db628fbc354d (HEAD -> main, origin/main, origin/HEAD) Commit message
 LICENSE   | 21 +++++++
 README.md |  1 +
 2 files changed, 22 insertions(+)'

sh "$1" >/dev/null || {
    printf 'Did not exit cleanly.\n'
    exit 1
}

printf 'list<<hashhashhash
LICENSE
README.md
hashhashhash
pattern=^LICENSE|^README.md
' >"$TMP/expected"

diff -q "$TMP/expected" "$GITHUB_OUTPUT" || {
    echo "Unexpected difference:"
    diff "$TMP/expected" "$GITHUB_OUTPUT"
    exit 1
}
