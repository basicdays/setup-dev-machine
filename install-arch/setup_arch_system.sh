#!/usr/bin/env bash
set -Eeuo pipefail

# https://wiki.archlinux.org/index.php/Install_Arch_Linux_via_SSH
# on guest instance after boot:
# passwd && systemctl start sshd

ip_address=$(./get_vm_ip.sh)
ssh-copy-id -i "$HOME/.ssh/id_rsa.pub" "root@$ip_address"
scp -r setup_scripts "root@$ip_address:./"
ssh "root@$ip_address" ./scripts/setup_step_1.sh
