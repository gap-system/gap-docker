# Docker container for the full installation of the latest GAP release

DockerHub entry: https://registry.hub.docker.com/u/gapsystem/gap-docker/

We maintain a Docker container for the full installation of the latest GAP 
release, aiming at having as much GAP packages as possible in the working 
order. It is usually updated shortly after the release announcement (so
slight delays are possible).

If you have installed Docker, first you need to download the container using

    docker pull gapsystem/gap-docker

(the same command is needed if you need to update the GAP container to get a
new GAP release). After that, you can start it as follows:

    docker run --rm -i -t gapsystem/gap-docker

Note that you may have to run `docker` with `sudo`, particularly if you are 
on Ubuntu.

Once the GAP container is started, you can call `gap` inside it to start a 
new GAP session:

```
gap@11d9377db2bd:~$ gap
 *********   GAP 4.9.1 of 05-May-2018
 *  GAP  *   https://www.gap-system.org
 *********   Architecture: x86_64-pc-linux-gnu-default64
 Configuration:  gmp 6.1.2, readline
 Loading the library and packages ...
 Packages:   AClib 1.3, Alnuth 3.1.0, AtlasRep 1.5.1, AutPGrp 1.9, 
             Browse 1.8.7, Carat 2.2.2, CRISP 1.4.4, Cryst 4.1.17, 
             CrystCat 1.1.8, CTblLib 1.2.2, FactInt 1.6.2, FGA 1.4.0, 
             GAPDoc 1.6.1, IO 4.5.1, IRREDSOL 1.4, LAGUNA 3.9.0, 
             Polenta 1.3.8, Polycyclic 2.13.1, PrimGrp 3.3.1, RadiRoot 2.8, 
             ResClasses 4.7.1, SmallGrp 1.3, Sophus 1.24, SpinSym 1.5, 
             TomLib 1.2.6, TransGrp 2.0.2, utils 0.54
 Try '??help' for help. See also '?copyright', '?cite' and '?authors'
gap> 
```

When you leave GAP, you will still be logged in to the container and will 
need to type `exit` to close it.

Alternatively, you can just type

    docker run --rm -i -t gapsystem/gap-docker gap

to start GAP immediately (and return to the host filesystem after the end of
the GAP session). You can put this command in a shell script and make it a
default or optional way to start GAP on your system. GAP command line options
can be appended after `gap`, for example 

    docker run --rm -i -t gapsystem/gap-docker gap -A

However, note that you will not be able to read a file from your local
directory into GAP just by supplying the filename in the command line. 
Instead, this requires using the option `-v` to mount a local directory.
For example, if the current directory contains the subdirectory `examples`
with the file `examples/useful.g`, then the option `-v $PWD/examples:/data`
will mount `examples` as `/data` on the Docker container. That is, to start
GAP and read the file `examples/useful.g` into it, type:

    docker run -v $PWD/examples:/data -t -i gapsystem/gap-docker gap /data/useful.g

Note that the path to `useful.g` is the path in the container, and not in the GAP system.

If you need network access (for example, for packages downloading external
data like AtlasRep), call `docker` with the option `--net="host"`, e.g.:

    docker run --rm -i -t --net="host" gapsystem/gap-docker

Combining these options, the following command mounts the directory
`pkg/scscp/example` from the GAP distribution as a directory `/scscp`
on the container and starts the GAP SCSCP server using the configuration
file `gap-4.X.Y/pkg/scscp/example/myserver.g`:

    docker run --rm -i -t --net="host" -v ~/gap-4.X.Y/pkg/scscp/example:/scscp gapsystem/gap-docker gap /scscp/myserver.g

At the moment, almost all packages are in working order. The only packages
which are not usable in this container are:
* PolymakeInterface
* ITC
* linboxing
* XGAP

External software needed by some packages at the moment includes some Ubuntu
packages and libraries, and also 4ti2, polymake, Singular and PARI/GP. You can
check their exact list in the `Dockerfile` for the "base" container which is
build from `gap-system/gap-container` (which only provides the core GAP system)
by adding additional dependencies, used by some packages in GAP. This "base"
container is maintained at https://github.com/gap-system/gap-docker-base.
