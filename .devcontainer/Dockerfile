FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

COPY --from=mikefarah/yq:4.30.2 /usr/bin/yq /usr/local/bin/yq
COPY --from=koalaman/shellcheck:v0.8.0 /bin/shellcheck /usr/local/bin/shellcheck
COPY --from=mstruebing/editorconfig-checker:2.7.0 /usr/bin/ec /usr/local/bin/ec
COPY --from=maniator/gh:v2.30.0 /usr/bin/gh /usr/local/bin/gh
