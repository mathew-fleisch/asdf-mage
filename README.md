<div align="center">

# asdf-mage [![Build](https://github.com/mathew-fleisch/asdf-mage/actions/workflows/build.yml/badge.svg)](https://github.com/mathew-fleisch/asdf-mage/actions/workflows/build.yml) [![Lint](https://github.com/mathew-fleisch/asdf-mage/actions/workflows/lint.yml/badge.svg)](https://github.com/mathew-fleisch/asdf-mage/actions/workflows/lint.yml)


[mage](https://github.com/magefile/mage) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add mage
# or
asdf plugin add mage https://github.com/mathew-fleisch/asdf-mage.git
```

mage:

```shell
# Show all installable versions
asdf list-all mage

# Install specific version
asdf install mage latest

# Set a version globally (on your ~/.tool-versions file)
asdf global mage latest

# Now mage commands are available
mage --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/mathew-fleisch/asdf-mage/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Mathew Fleisch](https://github.com/mathew-fleisch/)
