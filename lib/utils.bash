#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/magefile/mage"
TOOL_NAME="mage"
TOOL_TEST="mage --version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//'
}

list_all_versions() {
  list_github_tags
}

get_platform() {
  local platform
  platform=$(uname)
  case $platform in
  Darwin) platform="macOS" ;;
  Linux) platform="Linux" ;;
  DragonFly) platform="DragonFlyBSD" ;;
  FreeBSD) platform="FreeBSD" ;;
  OpenBSD) platform="OpenBSD" ;;
  Windows) platform="Windows" ;;
  esac
  echo "$platform"
}

get_system_architecture() {
  local architecture
  architecture=$(uname -m)
  case $architecture in
  armv*) architecture="ARM" ;;
  aarch64) architecture="ARM64" ;;
  x86_64) architecture="64bit" ;;
  esac
  echo "$architecture"
}

download_release() {
  local version platform architecture filename url
  version="$1"
  platform="$(get_platform)"
  architecture="$(get_system_architecture)"
  filename="$2"

  url="$GH_REPO/releases/download/v${version}/mage_${version}_${platform}-${architecture}.tar.gz"

  echo "* Downloading $TOOL_NAME release $GH_REPO/releases/tag/v$version"
  echo "* $url"
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
  if [ -f "$filename" ]; then
    echo "* Downloaded $filename"
  else
    fail "Could not download $filename from $url"
  fi
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3/bin"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH/$tool_cmd" "$install_path"
    if [ -f "$install_path/$tool_cmd" ]; then
      echo "* Installed $TOOL_NAME $version to $install_path"
    else
      fail "Could not install $TOOL_NAME $version to $install_path"
    fi
    chmod +x "$install_path/$tool_cmd"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}
