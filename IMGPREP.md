## IMAGE PREPARATION

### Compatible Architectures

The .deb packages are built using the latest version binaries from [the release section of skywire-mainnet](https://github.com/SkycoinProject/skywire-mainnet/releases) which are currently available for amd64, arm64, and arnhf. However, the script to automatically configure the hypervisor key on the visors which exist in [skybian](https://github.com/skycoinproject/skybian) only work as-is for the following subset of architectures:

* arm64
* armhf

If your board **is** a supported architecture:

#### You must preform the following configuration using skyimager prior to writing the image to the microSD card.

### 1) Install or download Skyimager

For the skybian-firstrun script which is provided by the skybian-skywire .deb package (and present in skybian images) to work correctly; the image you are using **must first** be configured using the skyimager.

If you are already using debian (or derivative such as ubuntu) **you can install skyimager-gui from this repository** [using the steps in the readme](/README.md)
(i.e. configure the repository, then `apt update && apt install skyimager-gui`)

If you are using an [arch-based](https://wiki.archlinux.org/index.php/Arch-based_Distros)[distro](endeavouros.com), you can find the skyimager in the [AUR](aur.archlinux.org).

Alternatively, you can find skyimager binaries in the [skybian release section](https://github.com/SkycoinProject/skybian/releases)

### 2) Download Base Image

Download a debian-based server image (not desktop) which is appropriate for your board ([Armbian](https://www.armbian.com/download/), [Raspbian](https://www.raspberrypi.org/downloads/raspbian/), etc). Armbian images are always preferred.

### 3) Process the image with skyimager

Launch skyimager-gui and select the image you want to use from your file system. Enter your router / gateway IP address, and choose the number of visor images to create. Click next to create the images.
Additional documentation can be found in: https://github.com/skycoinproject/skywire-mainnet

### 4) Flash the image to the microSD card

Using your preferred method, write the image to the microSD. It is recommended to expand the root file system on the card after the image has been written. Note: expanding the root file system to fill the microSD is critical for archlinuxARM images to function correctly.

After writing the image, insert the card into the pi and boot it. SSH to the board, and preform the [repository configuration](/README.md) if using a debian-based image.
