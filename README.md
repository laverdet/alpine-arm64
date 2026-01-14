# Fix arm64 Alpine Linux containers in GitHub Actions

There is a long-standing issue in GitHub Actions where Alpine on arm64 cannot use JavaScript Actions
(which is probably most of them).

So, this fails:
```
jobs:
  make:
    runs-on: ubuntu-24.04-arm
    container: alpine
    steps:
      - uses: actions/checkout@v4
```

This action installs a tweaked version of gcompat, which will allow node and other binaries to work
without modification. It also modifies `/etc/os-release` so that GitHub (and other tools, probably)
will not detect Alpine.

```
jobs:
  make:
    runs-on: ubuntu-24.04-arm
    container: alpine
    steps:
      - uses: laverdet/alpine-arm64@v1
      - uses: actions/checkout@v4
```

Note: This takes the place of `gcompat`. Do *not* run `apk add gcompat`.

References:
https://github.com/actions/runner/issues/1637
https://github.com/actions/runner/issues/801
https://github.com/actions/upload-artifact/issues/739
https://github.com/orgs/community/discussions/53407
