#!/bin/bash

set -e

TZ=Europe/London
HOME_SPACE="$(cd `dirname $0`;pwd)/"

mkdir -p "${HOME_SPACE}/source"
mkdir -p "${HOME_SPACE}/build"
mkdir -p "${HOME_SPACE}/install"

SOURCE_DIR="${HOME_SPACE}/source"
BUILD_DIR="${HOME_SPACE}/build"
INSTALL_DIR="${HOME_SPACE}/install"

export CFLAGS="-Os -fomit-frame-pointer -pipe"
export LINUX_LDFLAGS="-static -Wl,--as-needed -Wl,-Map,linker.map"
export DARWIN_LDFLAGS="-Wl,-map,linker.map"
export WIN32_LDFLAGS="-Wl,--as-needed -Wl,-Map,linker.map"
export NGINX_MODULES="kjdev/nginx-auth-jwt kjdev/nginx-keyval vision5/ngx_devel_kit openresty/echo-nginx-module openresty/headers-more-nginx-module openresty/set-misc-nginx-module"
  # The same as above, but for Windows.
  # - kjdev/nginx-auth-jwt, kjdev/nginx-keyval: a bit complicated to build (TODO)
export NGINX_MODULES_WIN32="vision5/ngx_devel_kit openresty/echo-nginx-module openresty/headers-more-nginx-module openresty/set-misc-nginx-module" # Don't update binaries with unchanged sources.
export SKIP_SAME_SOURCES="true"

apt-get update -qq && apt install -qq -y libedit-dev libncurses-dev libssl-dev libpcre2-dev libzstd-dev libz-dev libjansson-dev file

cd /build
ls -lRt
./scripts/build-nginx
mkdir -p "${INSTALL_DIR}/bin/"
ls -lRt /build
cp ./objs/nginx "${INSTALL_DIR}/bin/nginx-linux-$(uname -m)"