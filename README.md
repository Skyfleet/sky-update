[Sky-update](https://github.com/skyfleet/sky-update) will create [Skycoin](https://github.com/SkycoinProject) repo packages for debian / armbian / raspbian.

(For your convenience, the repository hosted here also contains a recent built skywire package)

Configure this repository in your apt sources:
```
sudo add-apt-repository 'deb http://skyfleet.github.io/sky-update stretch main'
curl -L http://skyfleet.github.io/sky-update/KEY.asc | sudo apt-key add -
sudo apt-get update
```

Install skywire:
```

sudo apt install skywire
```
