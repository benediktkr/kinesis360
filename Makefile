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

.PHONY: all clean

all:
	echo "using uid=${USER_UID},gid=${USER_GID} for the build"
	$(DOCKER) build \
		 --pull \
		 --build-arg "USER_UID=${USER_UID}" \
		 --build-arg "USER_GID=${USER_GID}" \
		 --tag zmk \
		 --file Dockerfile .

	$(DOCKER) run \
		--rm \
		--name zmk \
		-e VERSION="${VERSION}" \
		-v $(PWD)/firmware:/usr/local/src/firmware$(SELINUX1) \
		-v $(PWD)/config:/usr/local/src/config:ro$(SELINUX2) \
		zmk

clean:
	rm -vf firmware/*.uf2
	rm -vf firmware/Adv360-firmware_*.tar.gz firmware/*.txt
	$(DOCKER) image rm zmk docker.io/zmkfirmware/zmk-build-arm:stable
