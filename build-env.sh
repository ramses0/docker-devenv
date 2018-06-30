#!/bin/sh
docker \
	build \
	--build-arg localuser=$USER \
	--build-arg vncpassword=$USER \
	-t rames-devenv:latest .
