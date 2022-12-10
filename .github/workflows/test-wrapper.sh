#!/bin/sh

BIN=/tmp/$$.bin
LOG=/tmp/$$.log

mkdir -p "$BIN"
mkdir -p "$LOG"

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

export GITHUB_OUTPUT="$LOG/output"
touch "$GITHUB_OUTPUT"

export PATHS=\*
export TYPE=both

sh "$1" "$2"

rm -rf "$BIN" "$LOG"
