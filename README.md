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

The remainder of the steps on this page cover __autoconfiguration__ which is sometimes prone to errors. Skip to **step 5** for autoconfiguration as it is done in skybian.

If you have used skyimager, the configuration files should be present at /etc/skywire-visor.json or /etc/skywire-hypervisor.json depending on the image.



### 4.1) Manual Skywire configuration

Check which configuration files are present:
```
ls /etc/*.json
```

### 4.2)

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

### 4.3)


When the configuration file or files are present, enable and start the systemd service:

```
systemctl enable skywire-visor
systemctl start skywire-visor
```
and/or
```
systemctl enable skywire-hypervisor
systemctl start skywire-hypervisor
```

### 5) Install skybian-skywire for autoconfiguration scripts:

If you have completed step 4.1 through 4.3 **PLEASE DO NOT CONTINUE WITH THESE STEPS**

```
apt install skybian-skywire
```

**DIVERGENCE POINT!**
**READ VERY CAREFULLY**

There are 2 sets of scripts in this package

If you **have** configured your image with skyimager, **use step 5.1**

If you **have not** configured your image with skyimager, **use step 5.2**


### 5.1) Autoconfigure Skywire (images prepared with skyimager)

you may run the following from the terminal __on each board__:
```
skybian-firstrun
```

**Your configuration should be complete at this point.**

View the hyperviisor's web interface to make sure everything worked.

### 5.2) Configure Skywire (alternative method for images NOT prepared with skyimager)

__disclaimer: not fully tested__


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

**Your configuration should be complete at this point.**

View the hypervisor's web interface to make sure everything worked.


### 6) Updating your system and the skywire installation.
(as root)
```
apt update
apt upgrade
```

if you have followed the steps on this page, your operating system and the skywire installation will be updated if any more recent packages are available than your currently installed ones.

### 7) Build a newer package from source

[Note, the following is the subject of a PR](https://github.com/SkycoinProject/skywire-mainnet/pull/366)

Install these dependancies first:
```
sudo apt install golang wget
```

or, as root
```
apt install sudo golang wget
```

### 7.1)
Clone the skywire-mainnet github repo
```
git clone https://github.com/skycoinproject/skywire-mainnet
cd skywire-mainnet
```
(Optionally, switch the branch you're on at this point if you want.)

### 7.2)
replace the Makefile with one from Skyfleet which includes a package directive
```
rm Makefile
wget https://github.com/Skyfleet/skywire-mainnet/raw/develop/Makefile
```

### 7.3)
fetch the systemd services from SkycoinProject/Skybian (recommend use the develop branch)
```
cd static
wget https://raw.githubusercontent.com/SkycoinProject/skybian/develop/static/skywire-visor.service
wget https://github.com/SkycoinProject/skybian/blob/develop/static/skywire-hypervisor.service
cd ..
```

### 7.4)
In the following commands, please use the correct architecture for your system.
To determine this, you can use the output of the command `dpkg --print-architecture`

For rpi3 use `armhf`:
```
make package-armhf
sudo dpkg -i *armhf.deb
```

for orange pi prime or pine64 (most 64 bit ARM boards / OSes), use `arm64`
```
make package-arm64
sudo dpkg -i *arm64.deb
```

for a desktop or server, use `amd64`
```
make package-amd64
sudo dpkg -i *amd64.deb
```

You may need to use the `--force-overwrite` flag if you try to install over Skybian's skywire installation.


After you make the package you can serve it on the LAN to your other boards. Refer to [this script](/create-deb-repo.sh) or a more current version in [this repository](http://github.com/skyfleet/readonly-cache-deb) for how to do that.
