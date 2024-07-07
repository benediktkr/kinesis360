#!/bin/bash
#


if [[ "${1}" == "bash" || "${1}" == "shell" ]]; then
    exec -l /bin/bash
elif [[ -z "${1}" || "${1}" == "package" ]]; then
    /usr/local/bin/package.sh
else
    $@
fi


