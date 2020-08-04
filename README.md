[Sky-update](https://github.com/skyfleet/sky-update) will create [Skywire](https://github.com/SkycoinProject/skywire-mainnet) packages for debian / armbian / raspbian.

**Current binary releases support amd64 arm64 and armhf**

__Please make sure you have followed closely the instructions in [Image Preparation](/IMGPREP.md) before continuing__
Note: an autoconfiguration method is now available which does not require images whch were processed with skyimager.
Please refer to [this note](/NOTE.md) for details regarding this.


**ALL COMMANDS SHOULD BE RUN AS ROOT OR WITH SUDO**

## Using This Package Repository

### 1) Add this repository to your apt sources

(as root or use sudo):
```
add-apt-repository 'deb http://skyfleet.github.io/sky-update sid main'
```

If `add-apt-repository` is not be available; `apt install software-properties-common`
or manually edit your `/etc/apt/sources.list` (as root or use sudo):
```
nano /etc/apt/sources.list
```

Add the following:
```
deb http://skyfleet.github.io/sky-update sid main
# deb-src http://skyfleet.github.io/sky-update sid main
```

### 2) Add the repository signing key

(as root or use sudo)
```
curl -L http://skyfleet.github.io/sky-update/KEY.asc | apt-key add -
```
with sudo this would be:
```
curl -L http://skyfleet.github.io/sky-update/KEY.asc | sudo apt-key add -
```

### 3) Resync the package database:
```
apt update
```

### 4) Install skywire (as root or use sudo):
```
apt install skywire
```

At the point you have completed step 4, skywire is installed.

However, you must still create and configure the skywire-hypervisor and skywire-visor .json files

These files **must** be at the following paths for the included skywire-visor and skywire-hypervisor systemd services to work.
```
/etc/skywire-hypervisor.json
/etc/skywire-visor.json
```

Please follow the documentation [in the readme of skywire-mainnet](https://github.com/skycoinproject/skywire-mainnet)
or ask in [the skywire telegram channel](https://t.me/skywire)

When you have completed the configuration, start the hypervisor and/or visor systemd service, then view the hypervisor's web interface to make sure everything worked.

Step 5 has been removed pending revisions

### 6) Updating your system and the skywire installation.
(as root)
```
apt update
apt upgrade
```

if you have followed the steps on this page, your operating system and the skywire installation will be updated if any more recent packages are available than your currently installed ones.
