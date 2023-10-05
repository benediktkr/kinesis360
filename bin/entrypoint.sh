#!/bin/bash
#

if [[ -z "${VERSION}" ]]; then
    export VERSION="$(date -I)-SNAPSHOT"
fi

if [[ "${1}" == "bash" || "${1}" == "shell" ]]; then
    exec -l /bin/bash
elif [[ -z "${1}" || "${1}" == "build" ]]; then
    /usr/local/bin/build.sh
else
    $@
fi


