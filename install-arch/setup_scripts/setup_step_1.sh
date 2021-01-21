#!/usr/bin/env bash
set -Eeuo pipefail

# Setup Arch install from live boot
device=/dev/sda
MIRROR_COUNTRY=US

echo "Updating clock"
timedatectl set-ntp true


echo "Setting up pacman"
reflector \
	--protocol https \
	--country "$MIRROR_COUNTRY" \
	--save /etc/pacman.d/mirrorlist
pacman -Sy


./partitoning/lvm_partition.sh "$device"


echo "Installing Arch essential packages"
pacstrap /mnt base linux linux-firmware


echo "Creating fstab"
genfstab -L /mnt >> /mnt/etc/fstab


echo "chroot and setup system"
cp -R ./setup_scripts /mnt/root/
arch-chroot /mnt /root/setup_scripts/setup_step_2.sh


echo "Unmounting partitions and rebooting"
umount -R /mnt
reboot
