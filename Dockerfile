# Dockerfile
# Copyright 2019 Michael Mitchell

# Software Compilation Container Featuring GCC and LLVM
# https://github.com/gaknoid/llvm8-debian.git

# Building Container
# docker build --tag llvm8-debian $(pwd)
#
# Running Container, Interactive
# docker run --rm -it llvm8-debian
#
# Running Container, Make Process
# docker volume create work
# docker run --rm -it -v work:/work llvm8-debian -c "chown 1000:1000 /work"
# docker run --rm -it --user=1000:1000 -v work:/work llvm8-debian -c "git clone https://... /work/repo"
# docker run --rm -it --user=1000:1000 -v work:/work llvm8-debian -c "make -C /work/repo"

FROM debian:sid

LABEL \
    maintainer="Michael Mitchell <mmitchel@gaknoid.com>" \
    description="Software Compilation Container Featuring GCC and LLVM" \
    version="0.0" build-date="0000-00-00"

# LLVM Repository

ARG LLVM_VERS=llvmorg-8.0.0
ARG LLVM_REPO=https://github.com/llvm/llvm-project.git

# Base Development Environment

RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update -y -qq \
    && apt-get install -y -qq --no-install-recommends \
    autoconf automake bash bc bison bzip2 ca-certificates ccache \
    cmake cpio curl dpkg file flex g++ gcc gettext git make rsync \
    sudo swig texinfo unzip vim wget zip \
    libedit-dev libelf-dev \
    libtool-bin libncurses5-dev python python-dev zlib1g-dev \
    dpkg-dev libc-dev ninja-build \
    && rm -rf /var/lib/apt/lists/*

# Obtain LLVM Repository at Specific Version
# Compile Bootstrap w/ gcc, Compile w/ clang

RUN set -x \
    && mkdir -p /work && cd /work && llvm_dir=$(pwd) \
    && git clone --single-branch --branch $LLVM_VERS $LLVM_REPO \
    && mkdir -p $llvm_dir/build && cd $llvm_dir/build \
    && cmake -G Ninja -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ \
    -DLLVM_TARGETS_TO_BUILD=all \
    -DLLVM_ENABLE_PROJECTS=all \
    -DLLVM_BUILD_DOCS=OFF \
    -DLLVM_ENABLE_TERMINFO=OFF \
    $llvm_dir/llvm-project/llvm \
    && ninja && ninja install/strip \
    && cd $llvm_dir && rm -fr $llvm_dir/build \
    && mkdir -p $llvm_dir/build && cd $llvm_dir/build \
    && cmake -G Ninja -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
    -DLLVM_TARGETS_TO_BUILD=all \
    -DLLVM_ENABLE_PROJECTS=all \
    -DLLVM_BUILD_DOCS=OFF \
    -DLLVM_ENABLE_TERMINFO=OFF \
    $llvm_dir/llvm-project/llvm \
    && ninja && ninja install/strip \
    && cd $llvm_dir && rm -fr $llvm_dir/build \
    && cd / && rm -fr /work

# Default Execution

ENTRYPOINT ["/bin/bash"]

# EOF