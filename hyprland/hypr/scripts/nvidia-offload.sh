#!/bin/bash
# Run a command on the NVIDIA dGPU via PRIME render offload, e.g. as a Steam
# launch option: ~/.config/hypr/scripts/nvidia-offload.sh %command%

export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only
exec "$@"
