## NOTES ON THE SKYWIRE DEBIAN PACKAGE
updated 4-12-2020

Skywire debian package additional required configuration steps:

Create visor or hypervisor .json config file at the path and name which they are found in Skybian
```
skywire-hypervisor gen-config -ro /etc/skywire-hypervisor.json
```

and / or
```
skywire-cli visor gen-config -ro /etc/skywire-visor.json

```

Refer to the [skywire-mainnet readme](https://github.com/SkycoinProject/skywire-mainnet#configure-skywire-visor) for setting the hypervisor key and IP address in the `/etc/skywire-visor.json` visor configuration file.

## ADDITIONAL NOTES

The systemd service is called `skywire-startup.service`

The systemd service calls the script at `/usr/bin/skywire-startup`

I recommend manually running `skywire-startup` before enabling or starting the systemd service.

**The script may fail to launch skywire** because it seeks a configuration which was written as raw data by the skyimager to /dev/mmcblk0

This script can be edited to work. Please either ask for assistance with this in the [skywire telegram](https://t.me/skywire)
or avoid using the systemd services, and manually launch either visor or hypervisor with the following commands:

Manually launch skywire-hypervisor
```
skywire-hypervisor -c /etc/skywire-hypervisor.json
```

__NOTE:__ when manually launching the visor, the apps directory **must appear** as a subdirectory of the current one.
This can be achieved with the following:
```
ln -s /usr/bin/apps $(pwd)
```

Manually launch skywire-visor
```
skywire-visor /etc/skywire-visor.json
```

## RUN WITH NOHUP

Launch skywire-hypervisor with nohup
```
nohup skywire-hypervisor -c /etc/skywire-hypervisor.json > /dev/null 2>&1 &
```

Launch skywire-visor with nohup
```
nohup skywire-visor /etc/skywire-visor.json > /dev/null 2>&1 &
```
