FROM gapsystem/gap-container

MAINTAINER The GAP Group <support@gap-system.org>

RUN sudo apt-get update -qq \
    && cd /home/gap/inst/gap4r7/pkg \
    && sudo rm -rf \
    && sudo su - gap \
    && sudo wget -q http://www.gap-system.org/pub/gap/gap4pkgs/packages-v4.7.7.tar.gz \
    && sudo tar xzf packages-v4.7.7.tar.gz \
    && sudo rm packages-v4.7.7.tar.gz \
    && sudo wget https://raw.githubusercontent.com/gap-system/gap-docker/master/InstPackages.sh \
    && sudo chmod u+x InstPackages.sh \
    && sudo ./InstPackages.sh

# Set up new user and home directory in environment.
# Note that WORKDIR will not expand environment variables in docker versions < 1.3.1.
# See docker issue 2637: https://github.com/docker/docker/issues/2637
USER gap
ENV HOME /home/gap
ENV GAP_HOME /home/gap/inst/gap4r7
ENV PATH ${GAP_HOME}/bin:${PATH}

# Start at $HOME.
WORKDIR /home/gap

# Start from a BASH shell.
CMD ["bash"]
