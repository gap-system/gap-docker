# Docker container for GAP and packages.

We have a prebuilt Docker image for GAP and packages at https://registry.hub.docker.com/u/gapsystem/gap-docker/.

If you install Docker, you may run GAP from this container interactively as follows:

```
$ docker run --rm -i -t gapsystem/gap-docker
gap@e7a0b6e05771:~$ gap
 *********   GAP, Version 4.7.7 of 13-Feb-2015 (free software, GPL)
 *  GAP  *   http://www.gap-system.org
 *********   Architecture: x86_64-unknown-linux-gnu-gcc-default64
 Libs used:  gmp, readline
 Loading the library and packages ...
 Components: trans 1.0, prim 2.1, small* 1.0, id* 1.0
 Packages:   AClib 1.2, Alnuth 3.0.0, AtlasRep 1.5.0, AutPGrp 1.6, 
             Browse 1.8.6, CRISP 1.3.8, Cryst 4.1.12, CrystCat 1.1.6, 
             CTblLib 1.2.2, FactInt 1.5.3, FGA 1.2.0, GAPDoc 1.5.1, IO 4.4.4, 
             IRREDSOL 1.2.4, LAGUNA 3.7.0, Polenta 1.3.2, Polycyclic 2.11, 
             RadiRoot 2.7, ResClasses 3.4.0, Sophus 1.23, SpinSym 1.5, 
             TomLib 1.2.5
 Try '?help' for help. See also  '?copyright' and  '?authors'
gap> 
```

Note that you may have to run `docker` with `sudo`, particularly if you are on Ubuntu.

At the moment, most of the packages are in the working order. The work
in progress is to configure several remaining packages with non-standard
installation and dependencies on external components.

 
