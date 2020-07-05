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

Recent packaging improvements should have autoconfigured the hypervisor and visor automatically on the same board. Check the ip address of the board you are connected to at port :8000 to view the hypervisor's web interface

### 5) Connecting additional visors to the running hypervisor instance

(as root or use sudo):
```
add-apt-repository 'deb http://<ip-of-first-board>:8079/ sid main'
```

If `add-apt-repository` is not be available; `apt install software-properties-common`
or manually edit your `/etc/apt/sources.list` (as root or use sudo):
```
nano /etc/apt/sources.list
```

Add the following:
```
deb http://<ip-of-first-board>:8079/ sid main
#deb http://<ip-of-first-board>:8079/ sid main
```

Update the database of available packages and install the hypervisorconfig package before installing skywire

```
apt update
apt install hypervisorkey
apt install skywire
```

**Your configuration should be complete at this point.**

View the hypervisor's web interface to make sure everything worked.


### 6) Updating your system and the skywire installation.
(as root)
```
apt update
apt upgrade
```

if you have followed the steps on this page, your operating system and the skywire installation will be updated if any more recent packages are available than your currently installed ones.
