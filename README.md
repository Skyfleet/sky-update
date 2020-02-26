[Sky-update](https://github.com/skyfleet/sky-update) will create [Skycoin](https://github.com/SkycoinProject) repo packages for debian / armbian / raspbian.

(For your convenience, the repository hosted here also contains a recent built skywire package)

Configure this repository in your apt sources:
```
sudo add-apt-repository 'deb http://skyfleet.github.io/sky-update stretch main'
curl -L http://skyfleet.github.io/sky-update/KEY.asc | sudo apt-key add -
sudo apt-get update
```

Install either skyupdate or skywire:
```
sudo apt install skyupdate
#or
sudo apt install skywire
```

## Using Sky-update

Create and install a [SkycoinProject repo package](https://aur.archlinux.org/packages/?O=0&K=skycoin):

```
skyupdate skywire
```
The package will be created and installed.
(Optionally, you will be prompted to configure additional nodes with a local repository containing the created package)

## Using Skywire

Enable and start the manager systemd service:
```
sudo systemctl start skywire-manager
sudo systemctl enable skywire-manager
```

Set the manager IP for a node:
```
sudo skywire-node-setup
```
(You will be prompted to enter the manager IP. Optionally, you can provide the manager IP as an argument at the end of the above command)

Enable and start the node systemd service (not on the manager):
```
sudo systemctl start skywire-node
sudo systemctl enable skywire-node
```

Set skywire to run as the current (non-root) user
```
skywire-setuser
```

Use the keys from Skybian's skywire installaton:
```
cp -r /usr/local/skywire/go/bin/.skywire $HOME
```
