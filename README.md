<div align="center">

# mise-android-sdk [![Build](https://github.com/Syquel/mise-android-sdk/actions/workflows/build.yml/badge.svg)](https://github.com/Syquel/mise-android-sdk/actions/workflows/build.yml)

[Android Command-line tools](https://developer.android.com/tools) plugin for [mise](https://mise.jdx.dev/) and [asdf](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`: 4.4+
- `curl`: 7.60+
- `unzip`: 6.0+
- `yq`: 4.41.1+
- `java`: 8+
  - Android SDK 9+ requires Java 11+
  - Android SDK 11+ requires Java 17+
- [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html)

# Environment Variables
- `ANDROID_SDK_MIRROR_URL`: set this environment variable to load the Android SDK from a mirror instead of dl.google.com.

# Install

## Plugin
### mise
```shell
mise plugins install android-sdk https://github.com/Syquel/mise-android-sdk.git
```

### asdf
```shell
asdf plugin add android-sdk https://github.com/Syquel/mise-android-sdk.git
```

## Android SDK
### mise
```shell
# Show all installable versions
mise ls-remote android-sdk

# Install specific version
mise install android-sdk@13.0

# Set a version globally (on your ~/.tool-versions file)
mise use --global android-sdk@13.0
```

### asdf
```shell
# Show all installable versions
asdf list-all android-sdk

# Install specific version
asdf install android-sdk latest

# Set a version globally (on your ~/.tool-versions file)
asdf global android-sdk latest
```

### Usage
```shell
# Now android-sdk commands are available
sdkmanager --help
```

Check [mise](https://mise.jdx.dev/getting-started.html) or [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/Syquel/mise-android-sdk/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Frederik Boster](https://github.com/Syquel/)
