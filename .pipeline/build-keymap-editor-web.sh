#!/bin/bash
#
# Run npm in a docker container to build keymap-editor-web (Adv369-Pro-KeymapEditor)
#

set -e
shopt -s expand_aliases

alias ls='ls --color=always'
alias grep='grep --color=always'

NAME="keymap-editor-web"
SRC_PATH="Adv360-Pro-KeymapEditor"
SRC_REPO_URL="https://github.com/KinesisCorporation/Adv360-Pro-KeymapEditor/"
REPO_NAME=$(git rev-parse --show-toplevel | xargs basename)
if [[ -z "${REPO_NAME}" ]]; then
    echo "undefined: 'REPO_NAME'"
    exit 1
elif [[ -z "${VERSION}" ]]; then
    VERSION=$(date -I | tr '-' '.')-SNAPSHOT
elif [[ ! -d "./${SRC_PATH}" ]]; then
    git clone //github.com/KinesisCorporation/Adv360-Pro-KeymapEditor/ $(git rev-parse --show-toplevel)/Adv360-Pro-KeymapEditor
fi

# the /home/node dir is explicitly owned by uid 1000, and npm wants to write to $HOME/.npm (some logs)
# best way seems to be to bind mount 'node_modules' from the source dir (npm expects it in its pwd).

CACHE_DIR="$HOME/.cache/npm-docker/builds/${REPO_NAME}/${NAME}/.npm"
NODE_MODULES_DIR="$HOME/.cache/npm-docker/builds/${REPO_NAME}/${NAME}/node_modules"
OUTPUT_DIR=dist/${NAME}

BUILD_UID=$(id -u)
BUILD_GID=$(id -g)

echo "Cleaning up..."
if [[ -d "./${OUTPUT_DIR}" ]]; then
    echo "removing: '${OUTPUT_DIR}'"
    rm -r ./${OUTPUT_DIR}
fi
find ${OUTPUT_DIR} -name "${NAME}_${VERSION}.zip" -print -delete

mkdir -pv $CACHE_DIR $NODE_MODULES_DIR $OUTPUT_DIR

echo
echo "Directories mounted to the npm container to build ${NAME} (working around the container expecting to run as uid=1000"
echo "CACHE_DIR: ${CACHE_DIR}"
echo "NODE_MODULES_DIR: ${NODE_MODULES_DIR}"

echo
echo "Directory mounted to write the build output to:"
echo "OUTPUT_DIR: ${OUTPUT_DIR}"

echo
echo "Running npm container as uid=${BUILD_UID}, gid=${BUILD_GID}"
echo

if [[ -t 1 ]]; then
    # run docker container with -t if we are in a TTY
    DOCKER_OPT_TTY="-t"
fi

# the package.json file on the SRC repo root invokes application/package.json
# the one in the root is for running dev sever
#

(
    # https://github.com/KinesisCorporation/Adv360-Pro-KeymapEditor/blob/master/running-locally.md
    #

    set -e
    set -x
    ls -1 dist/
    docker pull node:latest
    docker run \
        --rm \
        $DOCKER_OPT_TTY \
        -w /${NAME} \
        -e "HOME=/home/node" \
        -v ./${SRC_PATH}:/${NAME} \
        -v ./config:/${NAME}/config \
        -v ./${OUTPUT_DIR}:/${OUTPUT_DIR} \
        -v ${CACHE_DIR}:/home/node/.npm \
        -v ${NODE_MODULES_DIR}:/${REPO_NAME}-server/web-src/node_modules \
        -e FORCE_COLOR=1 \
        -e TERM="xterm256-color" \
        -e NPM_CONFIG_PREFIX=/home/node/.npm \
        -e NODE_PATH=/home/node/.npm/node_modules \
        -e NODE_MODULES=/home/node/.npm/node_modules \
        -e NODE_INSTALL_PATH=/home/node/.npm/node_modules \
        -e OUTPUT_DIR=${OUTPUT_DIR} \
        --user "${BUILD_UID}:${BUILD_GID}" \
        node:latest bash -c "
            set -ex && \
            npm ci && \
            npm install && \
            cd application && \
            npm install
            "

    # npm run build (was last)
    # npm run build  -- --minify=false --outDir=/${OUTPUT_DIR} --emptyOutDir
    # the docs say:
    #  npm install
    #  npm run dev
    # which would presumably start a dev server. lets see how this works first

    ls -lah $OUTPUT_DIR
)

(
    set -e
    pushd $OUTPUT_DIR
    echo
    echo "creating zip file from '${OUTPUT_DIR}'"
    zip -r ../../dist/${NAME}_${VERSION}.zip ./
)

echo
ls -1 dist/
