To install sky-update:
```
add-apt-repository 'deb http://skyfleet.github.io/sky-update stretch main
curl -L http://skyfleet.github.io/sky-update/KEY.asc | sudo apt-key add -
apt-get update
apt-get install skyupdate
```

To use sky-update:

```
skyupdate skywire
```

Then, configure nodes with the created local package repository
