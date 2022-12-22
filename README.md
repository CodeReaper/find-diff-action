[![Build and Test](https://github.com/codereaper/find-diff-action/actions/workflows/test.yaml/badge.svg)](https://github.com/codereaper/find-diff-action/actions/workflows/test.yaml)

# find-diff-action

This action lets you find which areas of your repository has changed, so you can customize or skip parts of subsequent workflows.

By default all changes are reported, but the action can be configured to only consider certain folders or files and certain depths.

The action produces both a list of relevant changes and a pattern for these changes.

# Usage

> This action requires [full checkout with full history](https://github.com/actions/checkout#Fetch-all-history-for-all-tags-and-branches).

## List all changes

```yaml
- uses: CodeReaper/find-diff-action@v1
```

## List all changes, but ignore toplevel files

```yaml
- uses: CodeReaper/find-diff-action@v1
  with:
    paths: */
```

## List all changes in src and doc folders

```yaml
- uses: CodeReaper/find-diff-action@v1
  with:
    paths: src doc
```

## List all folders containing changes in src and doc folders

```yaml
- uses: CodeReaper/find-diff-action@v1
  with:
    paths: src doc
    type: directories
```

## List all changed files

```yaml
- uses: CodeReaper/find-diff-action@v1
  with:
    type: files
```

## List all folders containing changes matching classes/\*/\*

```yaml
- uses: CodeReaper/find-diff-action@v1
  with:
    paths: classes
    type: directories
    minimumDepth: 1
    maximumDepth: 3
```

# Outputs

The action outputs two variables, one is a plain new line separated list of changes, the other a regular expression that can match everything on the list of changes.

## Sample for `list`

```
.github/workflows/tests
action.yaml
LICENSE
```

## Sample for `pattern`

```
^.github/workflows/tests|^action.yaml|^LICENSE
```

# License

The scripts and documentation in this project are released under the [MIT License](LICENSE)