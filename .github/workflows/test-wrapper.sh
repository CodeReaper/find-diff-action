#!/bin/sh

BIN=/tmp/$$.bin
HUB=/tmp/$$.hub

mkdir -p "$BIN"
mkdir -p "$HUB"

cat <<EOF >$BIN/git
if [ "\$1" = "diff" ]; then
    printf "\$MOCKED_GIT_DIFF"
elif [ "\$1" = "show" ]; then
    printf "\$MOCKED_GIT_DIFF"
fi
exit 0
EOF
chmod +x $BIN/git

export PATH="$BIN:$PATH"

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

export PATHS=\*
export TYPE=both

sh "$1" "$2"

rm -rf "$BIN" "$HUB"
