#!/usr/bin/env bash

set -eu

# Because '-u' is set, bash will throw an error if '$VERSION' is undefined
# So we set an empty string as the default value with '-', since -z test
# if the length of the resulting string is zero
if [[ -z "${VERSION-}" ]]; then
    /usr/local/bin/version.py
    export VERSION="$(/usr/local/bin/version.py)"
    echo "Environment variable VERSION unset, SNAPSHOT build"
    echo "Set VERSION='${VERSION}'"
fi

set -x

/usr/local/bin/version.py --version-macro > $(pwd)/config/version.dtsi
cat $(pwd)/config/version.dtsi

west build -s zmk/app -d build/left -b adv360_left -- -DZMK_CONFIG="$(pwd)/config"
west build -s zmk/app -d build/right -b adv360_right -- -DZMK_CONFIG="$(pwd)/config"


TARFILE="Adv360-firmware_${VERSION}.tar.gz"
# The 'west build' commands will build the files 'build/left/zephy.uf2'
# and 'build/right/zephyr.uf2'.
#
# In the .tar.gz file we have renamed these files to 'left.uf2' and 'right.uf2'.

mkdir -p dist/firmware
tar czf \
    dist/firmware/${TARFILE} \
    --transform='flags=r;s|build/left/zephyr/zmk.uf2|left.uf2|' \
    --transform='flags=r;s|build/right/zephyr/zmk.uf2|right.uf2|' \
    build/left/zephyr/zmk.uf2 \
    build/right/zephyr/zmk.uf2


sha256sum dist/firmware/${TARFILE} > dist/firmware/${TARFILE}.sha256.txt
