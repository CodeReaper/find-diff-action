#!/bin/sh

BIN=/tmp/$$.bin
HUB=/tmp/$$.hub
TMP=/tmp/$$.tmp

mkdir -p "$BIN"
mkdir -p "$HUB"
mkdir -p "$TMP"

cat <<EOF >$BIN/git
if [ "\$1" = "diff" ]; then
    printf "\$MOCKED_GIT_DIFF"
elif [ "\$1" = "show" ]; then
    printf "\$MOCKED_GIT_DIFF"
elif [ "\$1" = "fetch" ]; then
    printf "fetch\n"
fi
exit 0
EOF
chmod +x $BIN/git

cat <<EOF >$BIN/md5sum
echo 'hashhashhash'
EOF
chmod +x $BIN/md5sum

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

export TMP="$TMP"
export BIN="$BIN"

export PATHS=\*\*

sh "$1" "$2"
EXIT=$?

rm -rf "$BIN" "$HUB" "$TMP"

exit $EXIT
