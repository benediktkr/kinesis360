DOCKER := $(shell { command -v podman || command -v docker; })
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
	$(DOCKER) build --tag zmk --file Dockerfile .
	$(DOCKER) run --rm -it --name zmk \
		-v $(PWD)/firmware:/app/firmware$(SELINUX1) \
		-v $(PWD)/config:/app/config:ro$(SELINUX2) \
		zmk

clean:
	rm -f firmware/*.uf2
	rm -f firmware/Adv360-firmware_*.tar.gz firmware/Adv360-checksums_*.txt
	$(DOCKER) image rm zmk docker.io/zmkfirmware/zmk-build-arm:stable
