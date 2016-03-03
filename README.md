# Docker container for GAP and packages

We have a prebuilt Docker image for GAP and packages at https://registry.hub.docker.com/u/gapsystem/gap-docker/.

If you have installed Docker, first you need to download the GAP container using
```
docker pull gapsystem/gap-docker
```
(the same command is needed if you need to pull the new GAP container to get a
new GAP release). After that, you can start the GAP container by typing the
following in a terminal:
```
docker run --rm -i -t gapsystem/gap-docker
```
Note that you may have to run `docker` with `sudo`, particularly if you are on Ubuntu.

Once the GAP container is started, you can call `gap` inside it to start a new GAP session:
```
gap@11d9377db2bd:~$ gap
 *********   GAP 4.8.2, 20-Feb-2016, build of 2016-03-01 01:08:48 (UTC)
 *  GAP  *   http://www.gap-system.org
 *********   Architecture: x86_64-pc-linux-gnu-gcc-default64
 Libs used:  gmp, readline
 Loading the library and packages ...
 Components: trans 1.0, prim 2.1, small* 1.0, id* 1.0
 Packages:   AClib 1.2, Alnuth 3.0.0, AtlasRep 1.5.0, AutPGrp 1.6, 
             Browse 1.8.6, CRISP 1.4.1, Cryst 4.1.12, CrystCat 1.1.6, 
             CTblLib 1.2.2, FactInt 1.5.3, FGA 1.3.0, GAPDoc 1.5.1, IO 4.4.5, 
             IRREDSOL 1.2.4, LAGUNA 3.7.0, Polenta 1.3.5, Polycyclic 2.11, 
             RadiRoot 2.7, ResClasses 4.1.2, Sophus 1.23, SpinSym 1.5, 
             TomLib 1.2.5
 Try '?help' for help. See also  '?copyright' and  '?authors'
gap> 
```
When you leave GAP, you will still be logged in to the container and will need to type `exit` to close it.

Alternatively, you can just type
```
docker run --rm -i -t gapsystem/gap-docker gap
```
to start GAP immediately (and return to the host filesystem after the end of the GAP session). You can put this command in a shell script and make it a default or optional way to start GAP on your system. GAP command line options can be appended after `gap`, for example `docker run --rm -i -t gapsystem/gap-docker gap -A`. 

However, note that you will not be able to read a file from your local directory into GAP just by supplying the filename in the command line. Instead, this requires using the option `-v` to mount a local directory. For example, if the current directory contains the subdirectory `examples` with the file `examples/useful.g`, then the option `-v $PWD/examples:/data` will mount `examples` as `/data` on the Docker container. That is, to start GAP and read the file `examples/useful.g` into it, type:
```
docker run -v $PWD/examples:/data -t -i gapsystem/gap-docker gap /data/useful.g
```
Note that the path to `useful.g` is the path in the container, and not in the GAP system.

If you need network access (for example, for packages downloading external data like AtlasRep), call `docker` with the option `--net="host"`, e.g.:
```
docker run --rm -i -t --net="host" gapsystem/gap-docker
```

Combining these options, the following command mounts the directory `pkg/scscp/example` from the GAP distribution as a directory `/scscp` on the container and starts the GAP SCSCP server using the configuration file `gap4rXpY/pkg/scscp/example/myserver.g`:
```
docker run --rm -i -t --net="host" -v ~/gap4rXpY/pkg/scscp/example:/scscp gapsystem/gap-docker gap /scscp/myserver.g
```

At the moment, almost all packages are in working order. External software needed by some packages at the moment includes:
* Ubuntu packages libmpfr-dev libmpfi-dev libmpc-dev libfplll-dev (needed by the float package)
* Polymake 2.14 (and dependencies, listed on polymake.org)
* Singular (git version of the day)
* 4ti2 1.6.3
* PARI/GP.

Work is in progress to configure the remaining packages that have non-standard installation procedures or dependencies on external components: Carat, ITC, Linboxing, ParGAP and XGAP.
