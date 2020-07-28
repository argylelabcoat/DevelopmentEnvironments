.PHONY: all debian 

DOCKER_BUILDKIT:=1
export DOCKER_BUILDKIT

BUILDER ?= docker
BUILD_CMD ?= build


GROUP := $(shell id -g)
USER := $(shell id -u)

all:

ubuntu:
	$(BUILDER) $(BUILD_CMD) -t goyotta:ubuntu -f goyotta.Dockerfile  --build-arg USER_ID=$(USER) --build-arg GROUP_ID=$(GROUP) .

buildah:
	BUILDER=buildah BUILD_CMD=build-using-dockerfile make ubuntu 
podman:
	BUILDER=podman make ubuntu

run:
	$(BUILDER) run --rm -it --name DevEnvironment --hostname devenv -v $(PWD):/work:z goyotta:ubuntu
