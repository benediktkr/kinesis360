DOCKER := $(shell { command -v podman || command -v docker; })
USER_UID := $(shell id -u)
USER_GID := $(shell id -g)
detected_OS := $(shell uname)  # Classify UNIX OS
ifeq ($(strip $(detected_OS)),Darwin) #We only care if it's OS X
SELINUX1 :=
SELINUX2 :=
else
SELINUX1 := :z
SELINUX2 := ,z
endif

.PHONY: all firmware clean_firmware clean_image clean

firmware:
	echo "Using uid=${USER_UID},gid=${USER_GID} and building with DOCKER=${DOCKER}"
	$(DOCKER) build \
		 --pull \
		 --progress plain \
		 --target export \
		 --output dist/ \
		 --build-arg "VERSION=${VERSION}" \
		 --build-arg "USER_UID=${USER_UID}" \
		 --build-arg "USER_GID=${USER_GID}" \
		 -t zmk:latest .

all: firmware

clean_firmware:
	rm -vf build/left/*.uf2 build/right/*.uf2
	rm -vf dist/firmware/Adv360-firmware_*.tar.gz dist/firmware/*.txt

clean_image:
	$(DOCKER) image rm docker.io/zmkfirmware/zmk-build-arm:stable || true

clean: clean_firmware clean_image
