[Sky-update](https://github.com/skyfleet/sky-update) will create [Skycoin](https://github.com/SkycoinProject) repo packages for debian / armbian / raspbian.

Configure this repository in your apt sources (as root or use sudo):
```
add-apt-repository 'deb http://skyfleet.github.io/sky-update stretch main'
curl -L http://skyfleet.github.io/sky-update/KEY.asc | apt-key add -
apt-get update
```

On RPi, `add-apt-repository` may not be available.
You must Manually edit your `/etc/apt/sources.list` (as root or use sudo):
```
nano /etc/apt/sources.list
```

Add the following:
```
deb http://skyfleet.github.io/sky-update stretch main
# deb-src http://skyfleet.github.io/sky-update stretch main
```

Resync the package database:
```
apt update
```

Install skywire (as root or use sudo):
```
apt install skywire
```

Once installed, refer to the [skywire debian package configuration](NOTE.md) for configuration steps.
