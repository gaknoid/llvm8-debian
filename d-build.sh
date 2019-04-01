#!/usr/bin/env bash
version="0.1"
docker build \
    --label "version=$version" --label "build-date=$(date +%Y-%m-%d)" \
    --tag llvm8-debian:$version --tag llvm8-debian:latest $(pwd)