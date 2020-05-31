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

### 4.1) Manual Skywire configuration

At the point you have completed step 4, skywire is installed.

The remainder of the steps on this page cover __autoconfiguration__ which is sometimes prone to errors.

If you have used skyimager, the configuration files should be present at /etc/skywire-visor.json or /etc/skywire-hypervisor.json depending on the image.

Check which configuration files are present:
```
ls /etc/*.json
```

If present, enable and start the systemd service:

```
systemctl start skywire-visor
```

or
```
systemctl start skywire-hypervisor
```

If the configuration files are not present, you must first generate them:
```
skywire-cli visor gen-config -ro /etc/skywire-visor.json
```

And / Or
```
skywire-hypervisor gen-config -ro /etc/skywire-hypervisor.json
```

Be sure to copy the hypervisor public key to the appropriate place in the skywire-visor.json as stated in the readme for skywire-mainnet.

To view the public key for the hypervisor:
```
cat /etc/skywire-hypervisor.json | grep "public_key" | awk '{print substr($2,2,66)}'
```

To parse the hypervisor key from /etc/skywire-hypervisor.json to /etc/skywire-visor.json (for running a hypervisor and a visor together)
```
hvisorkey=$(cat /etc/skywire-hypervisor.json | grep "public_key" | awk '{print substr($2,2,66)}') && sed -i 's/"hypervisors".*/"hypervisors": [{"public_key": "'"${hvisorkey}"'"}],/' /etc/skywire-visor.json
```

### 5) Install skybian-skywire for autoconfiguration scripts:

If you have completed step 4.1 **PLEASE DO NOT CONTINUE WITH THESE STEPS**

```
apt install skybian-skywire
```

**DIVERGENCE POINT!**
**READ VERY CAREFULLY**

### 6) Autoconfigure Skywire (images prepared with skyimager)

If you **have** configured your image with skyimager and followed every step on this page, you may run the following from the terminal __on each board__:
```
skybian-firstrun
```

Your configuration should be complete at this point. View the hyperviisor's web interface to make sure everything worked.

### 6) Configure Skywire (alternative method for images NOT prepared with skyimager)

If you **have not** configured your image with skyimager, run the following-

First, on the hypervisor:
```
skywire
```

Then, enable and start the systemd services
```
systemctl enable skywire-hypervisor.service
systemctl start skywire-hypervisor.service
systemctl enable skywire-visor.service
systemctl start skywire-visor.service
```

Next, on the visors:
```
remote-deb-repo
```
You will be asked to input the hypervisor's ip address.

After the script has finished, continue with the following commands:
```
apt update
apt install hypervisorkey
skywire
```

Then, enable and start the systemd service:
```
systemctl enable skywire-visor.service
systemctl start skywire-visor.service
```

Your configuration should be complete at this point. View the hypervisor's web interface to make sure everything worked.
