#!/bin/sh

for event in push workflow_dispatch pull_request pull_request_target; do
    export GITHUB_EVENT_NAME="$event"
    sh "$1" >>"$TMP/output" || {
        printf 'Did not exit cleanly for %s.\n' "$event"
        exit 1
    }
done

[ "$(grep -c 'fetch' "$TMP/output")" -eq 4 ] || {
    printf 'Did not call the correct number of fetches.\n'
    exit 1
}
