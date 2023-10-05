FROM docker.io/zmkfirmware/zmk-build-arm:stable

WORKDIR /app

COPY config/west.yml config/west.yml

RUN set -x && \
    west init -l config && \
    west update && \
    west zephyr-export

COPY bin/ /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []
