#!/bin/bash
#

echo "entrypoint: '$@'"
ls -1

if [[ "${1}" == "bash" || "${1}" == "shell" ]]; then
    exec -l /bin/bash
elif [[ -z "${1}" ]]; then
    echo "entrypoint: 'build.sh'"
    exec /usr/local/bin/build.sh
else
    echo "entrypoint: '$@'"
    exec -l "$@"
fi


