FROM debian:stretch
LABEL maintainer="Robert Ames (ramses0@yahoo.com)"

# build requires user
ARG localuser
RUN test -n "$localuser"

# build requires local password(s)
ARG vncpassword
RUN test -n "$vncpassword"

# docker run -v /host/directory:/container/directory -other -options image_name command_to_run
# COPY ...src... ..dest...

# https://bugs.launchpad.net/ubuntu/+source/apt/+bug/1332440/comments/4
# (apt-get is slow when ulimit is unlimited or high)
RUN ulimit -n 2000
RUN apt-get update
RUN apt-get install -y sudo

# base linux functionality (mostly never changes!)
RUN apt-get install -y dialog apt-utils
RUN apt-get install -y man openssh-server netcat-openbsd curl

# programming languages / build environment
RUN apt-get install -y ruby perl python golang rustc scala gcc make

# trying fancy VNC stuff
RUN apt-get install -y x11vnc xvfb firefox-esr

# basic development stuff (also mostly never changes!)
RUN apt-get install -y vim git pass jq

# sudoers, users, and permissions
RUN echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN useradd $localuser -m -s /bin/bash
RUN adduser $localuser sudo

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # #  switch to unpriveleged user (with full sudo) # # # #
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# switch to unpriveleged user (but also has passwordless sudo)
USER $localuser
#CMD ["x11vnc", "-forever", "-usepw", "-create"]
CMD [ "/bin/bash", "-c", "cd ~" ]

RUN mkdir -p /home/$localuser/.vnc
RUN x11vnc -storepasswd $vncpassword /home/$localuser/.vnc/passwd
RUN echo '' > ~/.bashrc
RUN echo 'test -f ~/Git/__dotfiles__/bash/profile && source ~/Git/__dotfiles__/bash/profile' >> ~/.bashrc
RUN echo 'test -f ~/Git/__dotfiles__/script/bootstrap && printf "Robert Ames\\nramses0@yahoo.com\\n" | ~/Git/__dotfiles__/script/bootstrap' >> ~/.bashrc
RUN echo 'test -f ~/Git/__dotfiles__/bin/ensure-debian-maintained &&  ~/Git/__dotfiles__/bin/ensure-debian-maintained' >> ~/.bashrc
RUN echo 'test -f ~/Git/__dotfiles__/bash/profile || cat ~/motd' >> ~/.bashrc
EXPOSE 5900

RUN rm -rf ~/Git/__profile__
RUN mkdir -p ~/Git/__profile__
COPY ./motd /home/$localuser/motd

