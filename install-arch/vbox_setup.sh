#!/usr/bin/env bash
set -Eeuo pipefail

# https://wiki.archlinux.org/index.php/Install_Arch_Linux_via_SSH
# on guest instance after boot:
# passwd && systemctl start sshd

device=/dev/sda
hostname=trigger-3-vbox-1

ip_address=$(./get_vm_ip.sh)
ssh-copy-id -i "$HOME/.ssh/id_rsa.pub" "root@$ip_address"
scp -r setup_scripts "root@$ip_address:./"
# Variables are expected to be evaluated before sending to source
# shellcheck disable=SC2029
ssh "root@$ip_address" ./setup_scripts/setup_step_1.sh "$device" "$hostname"
