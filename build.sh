#!/bin/bash

set -e

TZ=Europe/London
HOME_SPACE="$(cd `dirname $0`;pwd)/"

mkdir -p "${HOME_SPACE}/source"
mkdir -p "${HOME_SPACE}/install"

SOURCE_DIR="${HOME_SPACE}/source"
INSTALL_DIR="${HOME_SPACE}/install"

apt-get install -y curl ca-certificates wget libssl-dev autoconf make cmake xz-utils flex bison pkg-config

export CFLAGS="-Os -fomit-frame-pointer -pipe"
export LDFLAGS="-static -Wl,--as-needed -Wl,-Map,linker.map"
export NGINX_MODULES="kjdev/nginx-auth-jwt kjdev/nginx-keyval vision5/ngx_devel_kit openresty/echo-nginx-module openresty/headers-more-nginx-module openresty/set-misc-nginx-module"
  # The same as above, but for Windows.
  # - kjdev/nginx-auth-jwt, kjdev/nginx-keyval: a bit complicated to build (TODO)
export NGINX_MODULES_WIN32="vision5/ngx_devel_kit openresty/echo-nginx-module openresty/headers-more-nginx-module openresty/set-misc-nginx-module" # Don't update binaries with unchanged sources.
export SKIP_SAME_SOURCES="true"

apt-get update -qq && apt install -qq -y libedit-dev libncurses-dev libssl-dev libpcre2-dev libzstd-dev libz-dev libjansson-dev file

cd "${HOME_SPACE}"
echo "check openssl info"
pkg-config --modversion openssl
pkg-config --cflags openssl
pkg-config --libs openssl
find / -name "libssl*"

"${HOME_SPACE}/scripts/build-nginx"
mkdir -p "${INSTALL_DIR}/bin/"
ls -lRt "${HOME_SPACE}"
cp ./objs/nginx "${INSTALL_DIR}/bin/nginx-linux-$(uname -m)"