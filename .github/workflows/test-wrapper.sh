#!/bin/sh

BIN=/tmp/$$.bin
HUB=/tmp/$$.hub
TMP=/tmp/$$.tmp

mkdir -p "$BIN"
mkdir -p "$HUB"
mkdir -p "$TMP"

cat <<EOF >$BIN/gh
printf "\$MOCKED_DATA_DIFF"
exit 0
EOF
chmod +x $BIN/gh

cat <<EOF >$BIN/md5sum
echo 'hashhashhash'
EOF
chmod +x $BIN/md5sum

BASE=$(dirname "$0")/tests/outputs
cat <<EOF >$BIN/mock-data
cat "$BASE/\$1.json"
EOF
chmod +x $BIN/mock-data

export PATH="$BIN:$PATH"

export GITHUB_REPOSITORY="CodeReaper/fictitious-repo"
export GITHUB_REF="main"

export GITHUB_EVENT_PATH="$HUB/event.json"
cat <<EOF >$GITHUB_EVENT_PATH
{
    "repository": {
        "default_branch": "main"
    }
}
EOF

export GITHUB_OUTPUT="$HUB/output"
touch "$GITHUB_OUTPUT"

export TMP="$TMP"
export BIN="$BIN"

export PATHS=\*\*

sh "$1" "$2"
EXIT=$?

rm -rf "$BIN" "$HUB" "$TMP"

exit $EXIT
