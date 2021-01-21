#!/usr/bin/env bash
set -Eeuo pipefail

vmname=arch
vbox_net_interface=vboxnet0
mac_address=$(vboxmanage showvminfo --machinereadable "$vmname" | \
	awk -F = '/macaddress2/ {gsub(/"/, "", $2); print $2}')
vboxmanage dhcpserver findlease "--interface=$vbox_net_interface" "--mac-address=$mac_address"
ip_address=$(vboxmanage dhcpserver findlease "--interface=$vbox_net_interface" "--mac-address=$mac_address" | \
	awk -F : '/IP Address/ {gsub(/ /, "", $2); print $2}')

echo "$ip_address"
