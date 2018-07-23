FROM gapsystem/gap-docker-base

MAINTAINER The GAP Group <support@gap-system.org>

# Prerequirements
RUN    sudo apt-get update -qq \
    && sudo apt-get -qq install -y \
                                   # for ANUPQ package to build in 32-bit mode
                                   gcc-multilib \
                                   # for ZeroMQ package
                                   libzmq3-dev

RUN    cd /home/gap/inst/gap-4.9.1/pkg \
    && rm -rf \
    && wget -q http://www.gap-system.org/pub/gap/gap4pkgs/packages-v4.9.2.tar.gz \
    && tar xzf packages-v4.9.2.tar.gz \
    && rm packages-v4.9.2.tar.gz \
    && cd .. \
    && chmod -R a+r pkg \
    && find pkg -exec touch -r "INSTALL.md" {} \; \
    && cd pkg \
    && ../bin/BuildPackages.sh

# Set up new user and home directory in environment.
# Note that WORKDIR will not expand environment variables in docker versions < 1.3.1.
# See docker issue 2637: https://github.com/docker/docker/issues/2637
USER gap
ENV HOME /home/gap
ENV GAP_HOME /home/gap/inst/gap-4.9.1
ENV PATH ${GAP_HOME}/bin:${PATH}

# Start at $HOME.
WORKDIR /home/gap

# Start from a BASH shell.
CMD ["bash"]
