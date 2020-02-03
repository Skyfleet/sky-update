#!/bin/bash
#make a debian package repo of all created packages and offer to serve it on the LAN
set -x
#signwith=DE08F924EEE93832DABC642CA8DC761B1C0C0CFC
default_debian_codename=(stretch) #e.g. jessie, stretch, buster, sid
startingpoint=$(pwd)
#determine system architecture
mycarch=$(dpkg --print-architecture)
#get debian version codename
which_distribution=$(cat /etc/os-release | grep Debian)


if [ -f  /etc/os-release ]; then
checkremove="VERSION_CODENAME="
if [[ "$(cat /etc/os-release | grep $checkremove)" == $checkremove ]]; then
debian_codename=$(cat /etc/os-release | grep $checkremove)
debian_codename=${debian_codename#"$checkremove"}
else
debian_codename=$default_debian_codename
fi
fi
#need to error if this is empty
if [ -z $debian_codename ]; then
  echo -e "error, can't find debian distribution codename"
  exit
fi

echo -e "making repo for debian $debian_codename $mycarch"
repodirectory=$1
if [ -f *'.deb' ]; then
repodirectory=$(pwd)
else
if [ -z $repodirectory ]; then
repodirectory="built"
fi
fi
if [ ! -d $repodirectory ]; then
echo "Error: can't find built packages dir in which to create a repo"
exit
else
cd $repodirectory
fi
if [ ! -d "conf" ]; then
mkdir conf
fi

echo "creating repo configuration file"
#cd ~/MY_PACKAGE_REPO
echo "Origin: localhost" > conf/distributions
echo "Label: localhost" >> conf/distributions
echo "Codename: $debian_codename" >> conf/distributions
#echo -e "Architectures: $mycarch" >> conf/distributions
echo -e "Architectures: arm64 amd64" >> conf/distributions
echo "Components: main" >> conf/distributions
echo "Description: lorem ipsum dolor sit amet!" >> conf/distributions
if [ ! -z $signwith ]; then
echo "SignWith: $signwith" >> conf/distributions
fi
echo "Creating debian package repo"
reprepro --basedir $(pwd) includedeb $debian_codename *.deb
#share repo on LAN
read -p "Make repo available on local network? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  lan_ip_address="$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')"
  lan_port_serving_repo="8080"
    if [ -f /usr/bin/go ] || [ -f /bin/go ]; then
      echo "run the following on the nodes to configure the local packag repo"
      echo "sudo add-apt-repository 'deb [trusted=yes] http://$lan_ip_address:$lan_port_serving_repo/ stretch main'"
      echo -e "Serving on: http://$lan_ip_address:$lan_port_serving_repo/"
      echo "package main" > go_http_server.go
      echo "" >> go_http_server.go
      echo "import (" >> go_http_server.go
      echo '"flag"' >> go_http_server.go
      echo '"log"' >> go_http_server.go
      echo '"net/http"' >> go_http_server.go
      echo ")" >> go_http_server.go
      echo >> go_http_server.go
      echo "func main() {" >> go_http_server.go
      echo 'port := flag.String("p", "8080", "port to serve on")' >> go_http_server.go
      echo 'directory := flag.String("d", ".", "the directory of static file to host")' >> go_http_server.go
      echo "flag.Parse()" >> go_http_server.go
      echo >> go_http_server.go
      echo 'http.Handle("/", http.FileServer(http.Dir(*directory)))' >> go_http_server.go
      echo >> go_http_server.go
      echo 'log.Printf("Serving %s on HTTP port: %s\n", *directory, *port)' >> go_http_server.go
      echo 'log.Fatal(http.ListenAndServe(":"+*port, nil))' >> go_http_server.go
      echo "}" >> go_http_server.go
      go run go_http_server.go
  else
    if [ -f /usr/bin/python ] || [ -f /bin/python ] & [ ! -f /usr/bin/go ]; then
      echo "run the following on the nodes to configure the local packag repo"
      echo "sudo add-apt-repository 'deb [trusted=yes] $lan_ip_address$lan_port_serving_repo/ stretch main'"
      echo -e "Serving on: $lan_ip_address$lan_port_serving_repo/"
      #adjust the http server command depending on the available resources
      pythonversion=$(python --version)
      pythonversion=${pythonversion#"Python "}
      pythonversion=${pythonversion%.*}
      if (( $(echo "$pythonversion >= 3.0" | bc -l) )); then
        python -m http.server $lan_port_serving_repo
      else
        python -m SimpleHTTPServer $lan_port_serving_repo
      fi
  fi
fi
fi
