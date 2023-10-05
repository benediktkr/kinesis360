#!/usr/bin/env bash

set -eu
set -x


west build -s zmk/app -d build/left -b adv360_left -- -DZMK_CONFIG="$(pwd)/config"
west build -s zmk/app -d build/right -b adv360_right -- -DZMK_CONFIG="$(pwd)/config"

tarball="Adv360-firmware_${VERSION}.tar.gz"

echo tar \
    --transform='flags=r;s|build/left/zephyr/zmk.uf2|left.uf2|' \
    --transform='flags=r;s|build/right/zephyr/zmk.uf2|right.uf2|' \
    -czvf \
    firmware/${tarball}\
    build/left/zephyr/zmk.uf2 \
    build/right/zephyr/zmk.uf2

cp build/left/zephyr/zmk.uf2 firmware/left_${VERSION}.uf2
cp build/right/zephyr/zmk.uf2 firmware/right_${VERSION}.uf2
tar -C firmware/Adv360-firmware_${VERSION}.tar.gz left_${VERSION}.uf2 right_${VERSION}.uf2

