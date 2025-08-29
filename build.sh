#!/bin/bash

export CFLAGS="-Os -fomit-frame-pointer -pipe"
export LINUX_LDFLAGS="-static -Wl,--as-needed -Wl,-Map,linker.map"
export DARWIN_LDFLAGS="-Wl,-map,linker.map"
export WIN32_LDFLAGS="-Wl,--as-needed -Wl,-Map,linker.map"
export NGINX_MODULES="kjdev/nginx-auth-jwt kjdev/nginx-keyval vision5/ngx_devel_kit openresty/echo-nginx-module openresty/headers-more-nginx-module openresty/set-misc-nginx-module"
  # The same as above, but for Windows.
  # - kjdev/nginx-auth-jwt, kjdev/nginx-keyval: a bit complicated to build (TODO)
export NGINX_MODULES_WIN32="vision5/ngx_devel_kit openresty/echo-nginx-module openresty/headers-more-nginx-module openresty/set-misc-nginx-module" # Don't update binaries with unchanged sources.
export SKIP_SAME_SOURCES="true"

apt-get update -qq && apt install -qq -y libedit-dev libncurses-dev libssl-dev libpcre2-dev libzstd-dev

cd /build
ls -lRt
./scripts/build-nginx