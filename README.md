# nvrun

`nvrun` is a simple bash script for Linux users using a NVIDIA Optimus systems and other dual GPU system configs compatible with NVIDIA PRIME profiles that eases the process of running applications compatible with 3D hardware acceleration using the dedicated NVIDIA GPU on their systems when the NVIDIA PRIME profile is set to NVIDIA On-Demand (also known as offloading mode).

## Why?

Even though the NVIDIA driver allows the NVIDIA GPU to be used entirely by the OS, this setting is only a software switch that doesn't work on a low level basis and doesn't prevent the use of the Intel GPU either. In some case scenarios, this config may even cause graphical glitches and only systems equipped with a mux switch are actually able to completely bypass the Intel GPU. In order to avoid such graphical glitches, using the Intel GPU as the main system renderer is needed by either using the Intel profile, which blocks the use of the NVIDIA GPU completely, or the NVIDIA On-Demand profile.

PRIME profile | Description
--- | ---
NVIDIA (Performance Mode) | Utilize dedicated NVIDIA GPU as main renderer. Forces the NVIDIA GPU to always stay on.
NVIDIA On-Demand | Uses integrated GPU as main renderer and only turns on the dedicated GPU when an application requests it. It's the Linux equivalent of the Windows implementation of NVIDIA Optimus, although you need to explicitly enable the offloading on the running environment and very old X Server versions aren't compatible with it.
Intel (Power Saving Mode) | Completely disables the dedicated GPU and only utilizes the integrated one.

Normally, to offload the rendering of a 3D hardware-accelerated application to the NVIDIA GPU when the offloading mode is enabled the user needs to set several environment variables:

```bash
export __NV_PRIME_RENDER_OFFLOAD=1          # Enable NVIDIA offloading mode on the current shell environment
export __VK_LAYER_NV_optimus=NVIDIA_only    # Enable offloading for Vulkan-based applications
export __GLX_VENDOR_LIBRARY_NAME=nvidia     # Enable offloading for OpenGL-based applications
```

For example to run something like Blender a user would need to run either this:

```bash
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
blender
```

or this:

```bash
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia blender
```

Writing all of this by hand each time you want to offload rendering to the NVIDIA GPU is tedious, copy-pasting the commands each time doesn't help that much and setting the variables on `~/.bashrc` breaks the whole approach of being able to choose which apps are offloaded. There are other shell scripts like `nvidia-optimus-offload-glx` and `nvidia-optimus-offload-vulkan` but their names are equally long and tedious to write an you also have to know which rendering API the 3D application uses to actually make it work. On top of that, all of this is useless if any other of the three PRIME profiles is set instead of the NVIDIA On-Demand.

However with `nvrun` everything would just be a matter of running this:

```bash
nvrun blender
```

`nvrun` sets the three variables and runs the given command next to its call (first positional argument) making it agnostic to the rendering API and warns the user if the offloading settings are going to be ignored by the driver due to a different NVIDIA PRIME profile configuration than NVIDIA On-Demand is being used.

## Installing the script

### Requirements

- **A properly set up NVIDIA driver**: This is the most important part, as an improper driver installation and setup will render the script useless. No Bumblebee, Nouveau or any other weird things handling the NVIDIA GPU. Just the official proprietary NVIDIA driver.

  If the driver is properly set up, the `NVIDIA X Server Settings` application should be available in your desktop environment's application menu with the PRIME profiles section actually functional and showing the three different profiles available. If this isn't true then the driver installation is broken.

  The NVIDIA On-Demand PRIME profile needs to be chosen as well for `nvrun` to make any sense at all. You can use `nvrun` no matter what PRIME profile is selected, but using any other profile than NVIDIA On-Demand will make the NVIDIA driver completely ignore any offloading request. To set it you can either open the `NVIDIA X Server Settings` application then `PRIME Profiles > NVIDIA On-Demand` or run:

  ```bash
  sudo prime-select on-demand
  ```

  Then restart your PC to apply the changes.

- Git

### Procedure

1. Choose a folder where you want the script to be installed on and open a terminal instance there. The script will be cloned inside a subfolder of this folder you choose: `your_folder/nvrun/nvrun.sh`

1. Clone the repository:

   ```bash
   git clone https://github.com/hobyst/nvrun
   ```

2. Create a copy of the script detectable by any bash instance you run using your user
   by creating a hard symbolic link to the script in `~/.local/bin`. The change name from
   `nvrun.sh` to `nvrun` when creating the symbolic link is in purpose.

   ```bash
   cd nvrun
   ln ./nvrun.sh ~/.local/bin/nvrun
   ```

3. Enable `nvrun` as a runnable bash script:

   ```bash
   chmod +x ~/.local/bin/nvrun
   ```

4. Log out of your user by completely closing your user session and then log back in. This will make `~/.bashrc` include `~/.local/bin` in your user PATH. You can then check if this `nvrun` is available to run by running:
   
   ```bash
   nvrun
   ```

   Expected output:

   ```
   nvrun - Application runner for NVIDIA GPUs on a dual-GPU system config

   USAGE:

       nvrun [options] [command]
           Run desired command with NVIDIA GPU on-demand offloading.

   OPTIONS:

       --help
       -h
           Show this help text.
   ```

## Updating the script

To update the script, just go to the folder where the `nvrun.sh` file is stored along with this file and run a Git pull.

```bash
git pull
```

Thanks to the symbolic link, the update should reflect its changes instantly without any further actions.
