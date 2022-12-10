#!/bin/sh

export GITHUB_EVENT_NAME=push
export MOCKED_GIT_DIFF='e01d0b4c792d72cc96107b20b024db628fbc354d (HEAD -> main, origin/main, origin/HEAD) Commit message
 LICENSE   | 21 +++++++
 README.md |  1 +
 2 files changed, 22 insertions(+)'

$1 >/dev/null

cat "$GITHUB_OUTPUT"
