FROM debian:stretch
LABEL maintainer="Robert Ames (ramses0@yahoo.com)"

# build requires user
ARG localuser
RUN test -n "$localuser"

ARG vncpassword
RUN test -n "$vncpassword"


# docker run -v /host/directory:/container/directory -other -options image_name command_to_run
# COPY ...src... ..dest...

# https://bugs.launchpad.net/ubuntu/+source/apt/+bug/1332440/comments/4
# (apt-get is slow when ulimit is unlimited or high)
RUN ulimit -n 2000
RUN apt-get update

# base linux functionality (mostly never changes!)
RUN apt-get install -y man apt-utils dialog sudo

# pretend it's a real linux machine functionality (mostly never changes!)
RUN apt-get install -y man openssh-server netcat-openbsd

# basic development stuff (also mostly never changes!)
RUN apt-get install -y vim git pass


# sudoers, users, and permissions
RUN echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN useradd $localuser -m -s /bin/bash
RUN adduser $localuser sudo

# trying fancy VNC stuff
RUN apt-get update && apt-get install -y x11vnc xvfb firefox-esr

# switch to unpriveleged user (with full sudo)
USER $localuser
#CMD ["x11vnc", "-forever", "-usepw", "-create"]
CMD [ "/bin/bash", "-c", "cd ~" ]

RUN mkdir -p /home/$localuser/.vnc
RUN x11vnc -storepasswd $vncpassword /home/$localuser/.vnc/passwd
#RUN bash -c 'echo "firefox" >> /.bashrc'
EXPOSE 5900

#RUN mkdir -p ~/Git/profile
#RUN git clone 'https://github.com/ramses0/profile.git' ~/Git/profile

