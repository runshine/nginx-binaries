#!/bin/bash

apt-get update -qq && apt install -qq -y libedit-dev libncurses-dev libssl-dev libpcre2-dev libzstd-dev

cd /build
ls -lRt
./master/scripts/build-nginx