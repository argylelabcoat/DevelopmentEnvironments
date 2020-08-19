.PHONY: all debian 

DOCKER_BUILDKIT:=1
export DOCKER_BUILDKIT

BUILDER ?= docker
BUILD_CMD ?= build


GID := $(shell id -g)
UID := $(shell id -u)
TZ:= $(shell readlink /etc/localtime )

all:

ubuntu:
	$(BUILDER) $(BUILD_CMD) -t goyotta:ubuntu -f goyotta.Dockerfile  --build-arg USER_ID=$(UID) --build-arg GROUP_ID=$(GID) .

nix:
	$(BUILDER) $(BUILD_CMD) -t mattenv:nix -f nix.Dockerfile  --build-arg USER=$(USER) --build-arg UID=$(UID) --build-arg GID=$(GID) .

run-nix:
	$(BUILDER) run --rm -it --name NixDev --hostname nixdev mattenv:nix

guix-base:
	$(BUILDER) build -f alpine-guix.Dockerfile -t mattdev:guix .

run-guix:
	$(BUILDER) run --rm -it --name GuixDev --hostname guixdev  mattdev:guix

buildah:
	BUILDER=buildah BUILD_CMD=build-using-dockerfile make ubuntu 

podman:
	podman pull docker.io/library/ubuntu:focal
	BUILDER="podman  --cgroup-manager=cgroupfs" make ubuntu

run:
	$(BUILDER) run --rm -it --name DevEnvironment --hostname devenv -v $(PWD):/work:z -e TZ=$(TZ) goyotta:ubuntu /home/user/scripts/run_shell.sh

run-podman:
	BUILDER="podman" make run
