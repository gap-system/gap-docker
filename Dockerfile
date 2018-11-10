FROM gapsystem/gap-docker-base

MAINTAINER The GAP Group <support@gap-system.org>

# Prerequirements
RUN    sudo apt-get update -qq \
    && sudo apt-get -qq install -y \
                                   # for ANUPQ package to build in 32-bit mode
                                   gcc-multilib \
                                   # for ZeroMQ package
                                   libzmq3-dev \
                                   # for curlInterface
                                   libcurl4-openssl-dev \
                                   # for Jupyter
                                   python3-pip

RUN sudo pip3 install notebook jupyterlab_launcher jupyterlab traitlets ipython vdom

RUN    cd /home/gap/inst/ \
    && rm -rf gap-*\
    && wget -q https://www.gap-system.org/pub/gap/gap-4.10/tar.gz/gap-4.10.0.tar.gz \
    && tar xzf gap-4.10.0.tar.gz \
    && rm gap-4.10.0.tar.gz \
    && cd gap-4.10.0 \
    && ./configure \
    && make \
    && cp bin/gap.sh bin/gap \
    && cd pkg \
    && ../bin/BuildPackages.sh \
    && cd JupyterKernel-* \
    && python3 setup.py install --user

RUN jupyter serverextension enable --py jupyterlab --user

ENV PATH /home/gap/inst/gap-4.10.0/pkg/JupyterKernel-1.0/bin:${PATH}
ENV JUPYTER_GAP_EXECUTABLE /home/gap/inst/gap-4.10.0/bin/gap.sh

# Set up new user and home directory in environment.
# Note that WORKDIR will not expand environment variables in docker versions < 1.3.1.
# See docker issue 2637: https://github.com/docker/docker/issues/2637
USER gap
ENV HOME /home/gap
ENV GAP_HOME /home/gap/inst/gap-4.10.0
ENV PATH ${GAP_HOME}/bin:${PATH}

# Start at $HOME.
WORKDIR /home/gap

# Start from a BASH shell.
CMD ["bash"]
