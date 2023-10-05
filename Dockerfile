FROM docker.io/zmkfirmware/zmk-build-arm:stable
MAINTAINER Ben <pkg@sudo.is>

ENV TZ=UTC
ENV TERM=xterm-256color

ARG USER_UID=1337
ARG USER_GID=1337

RUN set -xe && \
    groupadd -g ${USER_GID} user && \
    useradd -u ${USER_UID} -g ${USER_GID} -d /usr/local/src --system user && \
    chown -R user:user /usr/local/src

WORKDIR /usr/local/src
USER user

COPY --chown=user:user  config/west.yml /usr/local/src/config/west.yml

RUN set -x && \
    west init -l config && \
    west update && \
    west zephyr-export && \
    echo python3 -m pip install --user -r zephyr/scripts/requirements.txt

COPY bin/entrypoint.sh /usr/local/bin/
COPY bin/build.sh /usr/local/bin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []
