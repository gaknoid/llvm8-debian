#!/usr/bin/env bash
docker run -it --rm --user=$(id -u):$(id -g) -v $HOME/repo:/repo llvm8-debian $@