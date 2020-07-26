.PHONY: all debian 

DOCKER_BUILDKIT:=1
export DOCKER_BUILDKIT

BUILDER ?= docker
BUILD_CMD ?= build


GROUP := $(shell id -g)
USER := $(shell id -u)

all:

debian:
	$(BUILDER) $(BUILD_CMD) -t goyotta:debian -f goyotta.Dockerfile  --build-arg USER_ID=$(USER) --build-arg GROUP_ID=$(GROUP) .

debian-buildah:
	BUILDER=buildah BUILD_CMD=build-using-dockerfile make debian
debian-podman:
	BUILDER=podman make debian

run:
	$(BUILDER) run --rm -it -v $(PWD):/work:z goyotta:debian 
