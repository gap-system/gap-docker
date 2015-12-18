# Docker container for GAP and packages.

We have a prebuilt Docker image for GAP and packages at https://registry.hub.docker.com/u/gapsystem/gap-docker/.

If you install Docker, you may start the container as follows:

```
$ docker run --rm -i -t gapsystem/gap-docker
```

Note that you may have to run `docker` with `sudo`, particularly if you are on Ubuntu.

After that, you may call `gap` to start a new GAP session:

```
gap@11d9377db2bd:~$ gap
 *********   GAP, Version 4.7.9 of 29-Nov-2015 (free software, GPL)
 *  GAP  *   http://www.gap-system.org
 *********   Architecture: x86_64-unknown-linux-gnu-gcc-default64
 Libs used:  gmp, readline
 Loading the library and packages ...
 Components: trans 1.0, prim 2.1, small* 1.0, id* 1.0
 Packages:   AClib 1.2, Alnuth 3.0.0, AtlasRep 1.5.0, AutPGrp 1.6, 
             Browse 1.8.6, CRISP 1.3.9, Cryst 4.1.12, CrystCat 1.1.6, 
             CTblLib 1.2.2, FactInt 1.5.3, FGA 1.3.0, GAPDoc 1.5.1, IO 4.4.4, 
             IRREDSOL 1.2.4, LAGUNA 3.7.0, Polenta 1.3.2, Polycyclic 2.11, 
             RadiRoot 2.7, ResClasses 3.4.0, Sophus 1.23, SpinSym 1.5, 
             TomLib 1.2.5
 Try '?help' for help. See also  '?copyright' and  '?authors'
gap> 
```
When you will leave GAP, you still will be logged in into container and will need to type `exit` to close it.

Alternatively, you may just type 
```
docker run --rm -i -t gapsystem/gap-docker gap
```
to start GAP immediately (and return to the host filesystem after the end of the GAP session). You may put this command in a shell script and make it a default or optional way to start GAP on your system. GAP command line options may be appended after `gap`, for example `docker run --rm -i -t gapsystem/gap-docker gap -A`. 

However, note that you will not be able to read a file our local directory into GAP just by supplying the filename in the command line. Instead of that, it is necessary to use `-v` option to mount local directory. For example, if the current directory contains the subdirectory `examples` with the file `examples/useful.g`, then with `-v $PWD/examples:/data` will mount `examples` as `/data` on the Docker container. Then to start GAP and read the file `examples/useful.g` into it, one should proceed as follows:

```
docker run -v $PWD/examples:/data -t -i gapsystem/gap-docker gap /data/useful.g
```

Note that the path to `useful.g` is the path in the container, and not in the GAP system.

If you need network access (for example, for packages downloading external data like AtlasRep), call `docker` with `--net="host"` option, e.g.:

```
docker run --rm -i -t --net="host" gapsystem/gap-docker
```

For example, the following command mounts `pkg/scscp/example` directory from the GAP distribution as `/scscp` directory on the container and starts GAP SCSCP server using the configuration file `gap4r7p9/pkg/scscp/example/myserver.g`:

```
docker run --rm -i -t --net="host" -v ~/gap4r7p9/pkg/scscp/example:/scscp gapsystem/gap-docker gap /scscp/myserver.g
```
At the moment, almost all of the packages are in the working order. External software needed by some packages at the moment includes:
* Ubuntu packages libmpfr-dev libmpfi-dev libmpc-dev libfplll-dev (needed by the float package)
* Polymake 2.14 (and dependencies, listed on polymake.org)
* Singular (git version of the day)
* 4ti2 1.6.3
* PARI/GP.

The work in progress is to configure remaining packages with non-standard installation and dependencies on external components: Carat, ITC, Linboxing, ParGAP and XGAP.

