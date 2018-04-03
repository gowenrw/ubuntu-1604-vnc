####################
# Base Image
####################
FROM ubuntu:16.04

####################
# Image Labels
####################
LABEL maintainer="@alt_bier"
LABEL name="u16vnc"
LABEL description="Ubuntu 16.04 with SSHD and VNC"
LABEL release-date="2018-04-02"
LABEL version="1.1"

####################
# Basic Environment
####################
ENV HOME=/root
WORKDIR $HOME
# PASSWORD FOR SSH AND VNC IS SET HERE
ENV MYPSD=password
# X/VNC Environment Vars
# VNC port:5901 noVNC webport via http://IP:6901/?password=vncpassword
ENV TERM=xterm \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=$MYPASSWD \
    VNC_VIEW_ONLY=false \
    DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
# Set Non-Interactive for image build
ENV DEBIAN_FRONTEND=noninteractive

####################
# Add some scripts
####################
ADD ./bin/*.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/*

####################
# Update Apt Repos
####################
RUN apt-get update -y

####################
# Install Basic Tools
####################
RUN install-tools.sh
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

####################
# Install SSHD
####################
RUN install-sshd.sh

####################
# Install TigerVNC
####################
RUN install-tigervnc.sh

####################
# Install noVNC
####################
RUN install-no_vnc.sh

####################
# Install Xfce
####################
RUN install-xfce.sh
ADD ./bin/xfce/ $HOME/

####################
# Install Browser
####################
RUN install-firefox.sh
# Lots of issues with chrome but if you want to try it uncomment this:
# RUN install-chrome.sh

####################
# Install Cleanup
####################
RUN apt-get clean -y
# We don't want the passwd here after install
ENV MYPSD=redacted
# We don't want Non-Interactive set after install
ENV DEBIAN_FRONTEND=readline

# Expose Ports
EXPOSE 22/tcp $VNC_PORT $NO_VNC_PORT

# Run the startme script which starts SSHD and VNC and checks for other run line commands
ENTRYPOINT ["startme.sh"]
CMD ["--tail-log"]
