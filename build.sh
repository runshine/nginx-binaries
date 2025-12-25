#!/bin/bash

set -ex

TZ=Europe/London
HOME_SPACE="$(cd `dirname $0`;pwd)/"

mkdir -p "${HOME_SPACE}/source"
mkdir -p "${HOME_SPACE}/install"

SOURCE_DIR="${HOME_SPACE}/source";export SOURCE_DIR
INSTALL_DIR="${HOME_SPACE}/install"

apt-get install -y curl ca-certificates wget libssl-dev autoconf make cmake xz-utils flex bison pkg-config openssl jq

export CFLAGS="-Os -fomit-frame-pointer -pipe"
export LDFLAGS="-static -lzstd -latomic -Wl,--as-needed -Wl,-Map,linker.map"
export NGINX_MODULES="kjdev/nginx-auth-jwt kjdev/nginx-keyval vision5/ngx_devel_kit openresty/echo-nginx-module openresty/headers-more-nginx-module openresty/set-misc-nginx-module"
  # The same as above, but for Windows.
  # - kjdev/nginx-auth-jwt, kjdev/nginx-keyval: a bit complicated to build (TODO)
export NGINX_MODULES_WIN32="vision5/ngx_devel_kit openresty/echo-nginx-module openresty/headers-more-nginx-module openresty/set-misc-nginx-module" # Don't update binaries with unchanged sources.
export SKIP_SAME_SOURCES="true"

apt-get update -qq && apt install -qq -y libedit-dev libncurses-dev libssl-dev libpcre2-dev libzstd-dev libz-dev libjansson-dev file

cd "${HOME_SPACE}"

[ ! -d "nginx-auth-jwt-0.9.0" ] && ${HOME_SPACE}/scripts/fetch-sources -d . nginx/nginx@release-1.28.x
[ ! -d "njs-0.9.1" ] && ${HOME_SPACE}/scripts/fetch-sources nginx/njs@0.x.x $NGINX_MODULES

cd "${SOURCE_DIR}"
wget -O "${SOURCE_DIR}/openssl-3.5.2.tar.gz"  https://github.com/openssl/openssl/releases/download/openssl-3.5.2/openssl-3.5.2.tar.gz
tar -xf openssl-3.5.2.tar.gz && cd openssl-3.5.2 
# # ./Configure --prefix=/usr/local/openssl-3.5.2 --openssldir=/usr/local/openssl-3.5.2
# # make && make install

cd "${HOME_SPACE}"
find / -name "ngx_setproctitle.c" -exec bash -c "sed -i 's/nginx: /ng_web: /g' {}"
"${HOME_SPACE}/scripts/build-nginx"
mkdir -p "${INSTALL_DIR}/bin/"
ls -lRt "${HOME_SPACE}"
cp ./objs/nginx "${INSTALL_DIR}/bin/nginx-linux-$(uname -m)"
