#!/bin/sh
# -p line: test vnc local internal
# https://unix.stackexchange.com/questions/55913/whats-the-easiest-way-to-find-an-unused-local-port
RANDOM_PORT=$( python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()' )
echo VNC_PORT=$RANDOM_PORT
EXTRA=$1
docker \
	run \
	-v $HOME/Git:/home/$USER/Git \
	-v $HOME:/home/$USER/host \
	-v $HOME/.ssh/:/home/$USER/.ssh \
	-v $HOME/.bash_history:/home/$USER/.bash_history \
	-p 127.0.0.1:$VNC_PORT:5900 \
	-i \
	-t \
	-w /home/$USER/ \
	rames-devenv${EXTRA}:latest bash
