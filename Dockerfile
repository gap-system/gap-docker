FROM gapsystem/gap-docker-base

MAINTAINER The GAP Group <support@gap-system.org>

ENV GAP_VERSION 4.10.2
ENV JUPYTER_KERNEL_VERSION 1.3

# Dependencies (missing in gapsystem/gap-docker-base)
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
    && wget -q https://www.gap-system.org/pub/gap/gap-4.10/tar.gz/gap-${GAP_VERSION}.tar.gz \
    && tar xzf gap-${GAP_VERSION}.tar.gz \
    && rm gap-${GAP_VERSION}.tar.gz \
    && cd gap-${GAP_VERSION} \
    && ./configure \
    && make \
    && cp bin/gap.sh bin/gap \
    && cd pkg \
    && ../bin/BuildPackages.sh \
    && cd JupyterKernel-* \
    && python3 setup.py install --user

RUN jupyter serverextension enable --py jupyterlab --user

ENV PATH /home/gap/inst/gap-${GAP_VERSION}/pkg/JupyterKernel-${JUPYTER_KERNEL_VERSION}/bin:${PATH}
ENV JUPYTER_GAP_EXECUTABLE /home/gap/inst/gap-${GAP_VERSION}/bin/gap.sh

# Set up new user and home directory in environment.
# Note that WORKDIR will not expand environment variables in docker versions < 1.3.1.
# See docker issue 2637: https://github.com/docker/docker/issues/2637
USER gap
ENV HOME /home/gap
ENV GAP_HOME /home/gap/inst/gap-${GAP_VERSION}
ENV PATH ${GAP_HOME}/bin:${PATH}

# Start at $HOME.
WORKDIR /home/gap

# Start from a BASH shell.
CMD ["bash"]
