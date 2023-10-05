#!/usr/bin/env bash

set -eu

# Adv360 Kconfig files
cat build/left/zephyr/.config | grep -v "^#" | grep -v "^$"
cat build/right/zephyr/.config | grep -v "^#" | grep -v "^$"

# West Build
west build -s zmk/app -d build/left -b adv360_left -- -DZMK_CONFIG="${pwd}/config"
west build -s zmk/app -d build/right -b adv360_right -- -DZMK_CONFIG="${pwd}/config"


# Rename zmk.uf2
if [[ -z "${VERSION}" ]];
    FW_VERSION="$(date -I)-SNAPSHOT"
else
    FW_VERSION=$VERSION
fi

sha256sum build/left/zephyr/zmk.uf2 build/right/zephyr/zmk.uf2 | sed 's, .*/, ,' > build/checksums.txt

tar --transform "s|build/left/zephyr/zmk.uf2|left.uf2|" \
    --transform "s|build/right/zephyr/zmk.uf2|right.uf2|" \
    --transform "s|build/checksums.txt|checksums.txt|" \
    czvf \
    firmware/Adv360-firmware_${VERSION}.tar.gz \
        build/checksums.txt \
        build/left/zephyr/zmk.uf2 \
        build/right/zephyr/zmk.uf2

cat build/checksums.txt > firmware/Adv360-checksums_${VERSION}.txt
sha256sum firmware/Adv360-firmware_${VERSION}.tar.gz | sed 's, .*/, ,' > firmware/Adv360-checksums_${VERSION}.txt




