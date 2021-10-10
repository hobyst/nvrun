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
    # Retrieve current NVIDIA Prime profile
    current_prime_profile=$(prime-select query)

    # Check current prime-select profile
    if [[ "$current_prime_profile" != "on-demand" ]]; then  # Check if a wrong PRIME profile is being used and notify if so
        echo
        echo "Current NVIDIA Prime profile is $current_prime_profile."
        
        # Turn the underscored profile name into something more fancy
        case $current_prime_profile in
            intel)  current_prime_profile_friendly_name="Intel integrated";;
            nvidia) current_prime_profile_friendly_name="NVIDIA dedicated";;
        esac

        echo "NVIDIA GPU offloading settings will be ignored by the driver and the $current_prime_profile_friendly_name GPU will be used."
        echo
    fi

    # Notify offload to the NVIDIA GPU to the script shell environment
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __VK_LAYER_NV_optimus=NVIDIA_only
    export __GLX_VENDOR_LIBRARY_NAME=nvidia

    # Run given command
    $command
fi
