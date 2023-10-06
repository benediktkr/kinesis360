#!/usr/bin/env bash

set -eu
set -x


west build -s zmk/app -d build/left -b adv360_left -- -DZMK_CONFIG="$(pwd)/config"
west build -s zmk/app -d build/right -b adv360_right -- -DZMK_CONFIG="$(pwd)/config"


TARFILE="Adv360-firmware_${VERSION}.tar.gz"

tar czf \
    firmware/${TARFILE} \
    --transform='flags=r;s|build/left/zephyr/zmk.uf2|left.uf2|' \
    --transform='flags=r;s|build/right/zephyr/zmk.uf2|right.uf2|' \
    build/left/zephyr/zmk.uf2 \
    build/right/zephyr/zmk.uf2



