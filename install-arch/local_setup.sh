#!/usr/bin/env bash
set -Eeuo pipefail

device=/dev/nvme0n1

./setup_scripts/setup_step_1.sh "$device" | tee ~/install.log
mv ~/install.log /mnt/root/install.log

echo "Unmounting partitions and rebooting"
umount -R /mnt
reboot
