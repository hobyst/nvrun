#! /bin/bash

# Retrieve command
command=$1

if [[ ("$command" == "") || ("$command" == "--help") || ("$command" == "-h") ]]; then   # Print help
    echo "nvrun - Application runner for NVIDIA GPUs on a dual-GPU system config"
    echo
    echo "USAGE:"
    echo
    echo "    nvrun [options] [command]"
    echo "        Run desired command with NVIDIA GPU on-demand offloading."
    echo
    echo "OPTIONS:"
    echo
    echo "    --help"
    echo "    -h"
    echo "        Show this help text."
    echo
else    # Run command
    # Notify offload to the NVIDIA GPU to the script shell environment
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __VK_LAYER_NV_optimus=NVIDIA_only
    export __GLX_VENDOR_LIBRARY_NAME=nvidia

    # Run given command
    $command
fi
