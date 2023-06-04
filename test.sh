#!/bin/sh
printf '#!/bin/bash\n' >/tmp/run.sh
yq '.runs[].0.run' <action.yaml >>/tmp/run.sh
chmod +x /tmp/run.sh

file=$(find .github/workflows/tests -name "$1.sh" -type f)

[ -z "$file" ] && {
  echo "File not found: $1"
  exit 1
}

shellcheck tests.sh test.sh /tmp/run.sh .github/workflows/test-wrapper.sh "$file"

printf "Testing %s ...\n" "$(basename "$file" ".sh")"
if ! sh .github/workflows/test-wrapper.sh "$file" /tmp/run.sh; then
  exit 1
fi

ec
