# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

# TODO: adapt this
asdf plugin test android-sdk https://github.com/Syquel/asdf-android-sdk.git "android-sdk --help"
```

Tests are automatically run in GitHub Actions on push and PR.
