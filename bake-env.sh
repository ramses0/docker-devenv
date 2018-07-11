#!/bin/sh
cat Dockerfile.template2 | sed 's/^#IFDEF_BAKE//g' > Dockerfile
docker \
	build \
	--build-arg localuser=$USER \
	--build-arg vncpassword=$USER \
	--build-arg dotfilesrepourl='https://github.com/ramses0/dotfiles.git' \
	--build-arg sourcebashrc=1 \
	--no-cache \
	--tag rames-devenv-baked:latest \
	.
