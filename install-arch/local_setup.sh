#!/usr/bin/env bash
set -Eeuo pipefail

device=/dev/nvme0n1
hostname=trigger-3

./setup_scripts/setup_step_1.sh "$device" "$hostname" | tee ~/install.log
mv ~/install.log /mnt/root/install.log

echo "Unmounting partitions and rebooting"
umount -R /mnt
reboot
