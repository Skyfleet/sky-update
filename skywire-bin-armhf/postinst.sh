#!/usr/bin/bash
#https://aur.archlinux.org/cgit/aur.git/tree/skywire.install?h=skywire-git
systemctl disable --now skywire-hypervisor.service
systemctl disable --now skywire-visor.service
#generate the config
skywire-cli visor gen-config -ro /etc/skywire-visor.json
#check if the hypervisorconfig package is installed
if [[ $(apt list --installed | grep hypervisorconfig) == *"hypervisorconfig"* ]]; then
  hvisorkey=$(cat /usr/lib/skycoin/skywire/hypervisor.txt)
  echo "Setting hypervisor key to $hvisorkey"
  echo "Starting visor"
  systemctl enable --now skywire-visor.service
else
  #configure hypervisor
  skywire-hypervisor gen-config -ro /etc/skywire-hypervisor.json
  hvisorkey=$(cat /etc/skywire-hypervisor.json | grep "public_key" | awk '{print substr($2,2,66)}')
  echo "Setting hypervisor key to $hvisorkey"
  #setting key and cert in hypervisor config file
  sed -i 's+"enable_tls": false,+"enable_tls": true,+g' /etc/skywire-hypervisor.json
	sed -i 's+"tls_cert_file": "",+"tls_cert_file": "/etc/skywire-hypervisor/cert.pem",+g' /etc/skywire-hypervisor.json
  sed -i 's+"tls_key_file": ""+"tls_key_file": "/etc/skywire-hypervisor/key.pem"+g' /etc/skywire-hypervisor.json
  echo "Starting hypervisor on 127.0.0.1:8000"
  systemctl enable --now skywire-hypervisor.service
  #add the hypervisor key to the visor's config
  sed -i 's/"hypervisors".*/"hypervisors": [{"public_key": "'"${hvisorkey}"'"}],/' /etc/skywire-visor.json
  echo "Starting visor"
  systemctl enable --now skywire-visor.service
fi
