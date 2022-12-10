#!/bin/bash
printf '#!/bin/bash\n' >/tmp/run.sh
yq '.runs[].0.run' <action.yaml >>/tmp/run.sh
chmod +x /tmp/run.sh
# shellcheck disable=SC2046
shellcheck test.sh /tmp/run.sh .github/workflows/test-wrapper.sh $(find .github/workflows/tests -name "*.sh" -type f)
find .github/workflows/tests -name "*.sh" -type f -exec sh -c 'printf "\nTest %s:\n" "$(basename $1 ".sh")"; sh .github/workflows/test-wrapper.sh "$1" /tmp/run.sh' -- {} \;
