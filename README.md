llvm8-debian
====

Software Compilation Container Featuring GCC and LLVM

Info
----

Based from debian:sid

This Docker container is intended to capture a general method that developers can work with a similar
tool chain on demand. Featured in this container are the native version of GCC, and a complete LLVM
toolchains. The LLVM tool chain is custom built as part of the instance generation of this container.

```console
docker pull gaknoid/llvm8-debian
```

Building Container
----

Built with limits of: 8 threads, 16G RAM, 1G Swap

```console
docker build --tag llvm8-debian $(pwd)
```

Running Container
----

Interactive use case:

```console
docker run --rm -it llvm8-debian
```

Running a command use case:

```console
docker run --rm -it --user=1000:1000 -v $HOME/work:/work llvm8-debian -c "make -C /work"
```

There is performance degradation when using a hosted volume for the command use case as
the artifacts are produced and stored in the hosted filesystem. Executable artifacts are
produced for the version of the container OS by default.

```console
docker volume create work
docker run --rm -it -v work:/work llvm8-debian -c "chown 1000:1000 /work"
docker run --rm -it --user=1000:1000 -v work:/work llvm8-debian -c "git clone https://... /work/repo"
docker run --rm -it --user=1000:1000 -v work:/work llvm8-debian -c "make -C /work/repo"
```