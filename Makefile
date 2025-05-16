DOCKER := $(shell { command -v podman || command -v docker; })
#DOCKER := $(shell { command -v docker; })
VERSION := $(shell bin/version.py)
ifeq ($(shell uname),Darwin)
USER_UID := 1000
USER_GID := 1000
SELINUX1 :=
SELINUX2 :=
else
USER_UID := $(shell id -u)
USER_GID := $(shell id -g)
SELINUX1 := :z
SELINUX2 := ,z
endif

.PHONY: all firmware clean_firmware clean_image clean

firmware:
	@echo "Using uid=${USER_UID},gid=${USER_GID} and building with DOCKER=${DOCKER}"
	$(DOCKER) buildx build \
		 --pull \
		 --progress plain \
		 --target export \
		 --output dist/ \
		 --build-arg "VERSION=${VERSION}" \
		 --build-arg "USER_UID=${USER_UID}" \
		 --build-arg "USER_GID=${USER_GID}" \
		 -t zmk:latest .
	@echo
	@echo "Successful build: Adv360-firmware_${VERSION}"

all: firmware

clean_firmware:
	rm -vf build/left/*.uf2 build/right/*.uf2
	rm -vf dist/firmware/Adv360-firmware_*.tar.gz dist/firmware/*.txt
	rm -vf dist/firmware/Adv360-firmware_*/*.uf2
	rmdir -v dist/firmware/Adv360-firmware_*

clean_image:
	$(DOCKER) image rm docker.io/zmkfirmware/zmk-build-arm:stable || true

clean: clean_firmware clean_image

docker-userids:
	@echo "UID: ${USER_UID}"
	@echo "GID: ${USER_GID}"



