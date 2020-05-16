[Sky-update](https://github.com/skyfleet/sky-update) will create [Skywire](https://github.com/SkycoinProject/skywire-mainnet) packages for debian / armbian / raspbian.

**Current binary releases support amd64 arm64 and armhf**

__Please make sure you have followed closely the instructions in [Image Preparation](/IMGPREP.md) before continuing__

## Using This Package Repository

### 1) Add this repository to your apt sources

(as root or use sudo):
```
add-apt-repository 'deb http://skyfleet.github.io/sky-update sid main'
```

On RPi, `add-apt-repository` may not be available, so you must manually edit your `/etc/apt/sources.list` (as root or use sudo):
```
nano /etc/apt/sources.list
```

Add the following:
```
deb http://skyfleet.github.io/sky-update stretch main
# deb-src http://skyfleet.github.io/sky-update stretch main
```

### 2) Add the repository signing key
```
curl -L http://skyfleet.github.io/sky-update/KEY.asc | apt-key add -
```

### 3) Resync the package database:
```
apt update
```

### 4) Install skywire (as root or use sudo):
```
apt install skywire
```

### 5) Run Skywire
enable and start the systemd service
```
systemctl enable skywire-startup
systemctl start skywire-startup
```

You can also manually start skywire to make sure everything is working correctly:
```
skywire-startup
```
