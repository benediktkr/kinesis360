#!/usr/bin/env bash

set -eu

# Because '-u' is set, bash will throw an error if '$VERSION' is undefined
# So we set an empty string as the default value with '-', since -z test
# if the length of the resulting string is zero
if [[ -z "${VERSION-}" ]]; then
    export VERSION="$(/usr/local/bin/version.py)"
    echo "Environment variable VERSION unset"
fi

echo "Version: '${VERSION}'"

set -x

/usr/local/bin/version.py --version-macro > $(pwd)/config/version.dtsi
cat $(pwd)/config/version.dtsi

# Using '-p' forces 'west build' to make the build directory "pristine" before
# re-running cmake to generate a build system.
# This option is used the the upstream build script using docker, but not in the
# GitHub pipeline.
west build -s zmk/app -d build/left -b adv360_left -- -DZMK_CONFIG="$(pwd)/config"
west build -s zmk/app -d build/right -b adv360_right -- -DZMK_CONFIG="$(pwd)/config"

BUILD_NAME="Adv360-firmware_${VERSION}"
# The 'west build' commands will build the files:
#  - 'build/left/zephyr/zmk.uf2'
#  - 'build/right/zephyr/zmk.uf2'
#
# In the .tar.gz file we have renamed these files to 'left.uf2' and 'right.uf2'.

mkdir -p dist/firmware
tar czf \
    dist/firmware/${BUILD_NAME}.tar.gz \
    --transform='flags=r;s|build/left/zephyr/zmk.uf2|left.uf2|' \
    --transform='flags=r;s|build/right/zephyr/zmk.uf2|right.uf2|' \
    build/left/zephyr/zmk.uf2 \
    build/right/zephyr/zmk.uf2

mkdir -p dist/firmware/${BUILD_NAME}
cp build/left/zephyr/zmk.uf2  dist/firmware/${BUILD_NAME}/left.uf2
cp build/right/zephyr/zmk.uf2 dist/firmware/${BUILD_NAME}/right.uf2

(
    cd dist/firmware
    md5sum ${BUILD_NAME}/left.uf2 ${BUILD_NAME}/right.uf2
    md5sum ${BUILD_NAME}.tar.gz
) > dist/firmware/${BUILD_NAME}.txt
