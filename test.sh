#!/bin/bash
printf '#!/bin/bash\n' >/tmp/run.sh
yq '.runs[].0.run' <action.yaml >>/tmp/run.sh
chmod +x /tmp/run.sh
# shellcheck disable=SC2046
shellcheck test.sh /tmp/run.sh .github/workflows/test-wrapper.sh $(find .github/workflows/tests -name "*.sh" -type f)
find .github/workflows/tests -type f -name '*.[sS][hH]' -exec sh -c '
  for file do
    printf "Testing %s ...\n" "$(basename $file ".sh")"
    if ! sh .github/workflows/test-wrapper.sh "$file" /tmp/run.sh; then
      kill -s PIPE "$PPID"
      exit 1
    fi
  done' sh {} +

# shellcheck disable=SC2181
[ $? -eq 0 ] || {
    echo "Tests failed!"
    exit 1
}
