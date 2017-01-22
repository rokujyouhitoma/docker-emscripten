FROM ubuntu:16.04

MAINTAINER Ike Tohru "ike.tohru@gmail.com"

RUN apt-get install -y python2.7 nodejs
RUN apt-get install -y build-essential cmake git-core default-jre

RUN ln -s /usr/bin/python2.7 /usr/bin/python

# Checkout emscripten repository
RUN cd /root/ && \
git clone https://github.com/kripken/emscripten.git

RUN mkdir /root/myfastcomp && \
cd /root/myfastcomp && \
git clone https://github.com/kripken/emscripten-fastcomp

RUN cd /root/myfastcomp/emscripten-fastcomp && \
git clone https://github.com/kripken/emscripten-fastcomp-clang tools/clang

# Build emscripten
RUN cd /root/myfastcomp/emscripten-fastcomp && \
mkdir build && \
cd build && \
cmake .. -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86;JSBackend" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DCLANG_INCLUDE_EXAMPLES=OFF -DCLANG_INCLUDE_TESTS=OFF && \
make -j1

# Set Environment variables.
ENV LLVM /root/myfastcomp/emscripten-fastcomp/build/bin

ENV HOME /root

WORKDIR /root

CMD ["bash"]
