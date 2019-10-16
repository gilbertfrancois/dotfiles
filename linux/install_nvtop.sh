#!/bin/bash

sudo apt install -y cmake libncurses5-dev libncursesw5-dev git

cd /tmp
git clone https://github.com/Syllo/nvtop.git
mkdir -p nvtop/build && cd nvtop/build

# If it errors with "Could NOT find NVML (missing: NVML_INCLUDE_DIRS)"
# try the following command instead, otherwise skip to the build with make.
cmake .. -DNVML_RETRIEVE_HEADER_ONLINE=True

make
sudo make install

