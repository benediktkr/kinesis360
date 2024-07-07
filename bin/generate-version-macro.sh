#!/usr/bin/env bash

set -e

zmk_kp() {
    local kp=""
    for ((i = 0; i < ${#1}; i++)); do
        # As upper case
        local char=$(echo ${1:$i:1} | tr '[a-z]' '[A-Z]')

        # As ZMK &kp key behavior
        if [[ "${char}" =~ "[0-9]" ]]; then
            kp+="<&kp N${char}>, "
        elif [[ "${char}" == "." ]]; then
            kp+="<&kp DOT>, "
        else
            kp+="<&kp ${char}>, "
        fi
    done
    echo "$kp <&kp RET>"
}

KP_VERSION=$(zmk_kp "Version: ${VERSION}")
if [[ -n "${GIT_COMMIT}" ]]; then
    KP_GIT_COMMIT=$(zmk_kp "Commit: ${GIT_COMMIT:0:7}")
fi
if [[ -n "${GIT_BRANCH}" ]]; then
    KP_GIT_BRANCH=$(zmk_kp "Branch: ${GIT_BRANCH}")
fi
KP_VERSION_MACRO="${KP_VERSION} ${KP_GIT_COMMIT} ${KP_GIT_BRANCH}"

cat >$(pwd)/config/version.dtsi <<EOF
#define VERSION_MACRO
macro_ver: macro_ver {
  compatible = "zmk,behavior-macro";
  label = "macro_ver";
  #binding-cells = <0>;
  bindings = ${KP_VERSION} ${KP_GIT_COMMIT} ${KP_GIT_BRANCH};
};
EOF

