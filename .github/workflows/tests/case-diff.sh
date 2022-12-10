#!/bin/sh

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

sh "$1" >/dev/null

cat "$GITHUB_OUTPUT" # FIXME: actual asserts and more tests
