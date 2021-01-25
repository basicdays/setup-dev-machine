#!/usr/bin/env bash
set -Eeuo pipefail
# Setup Arch install from live boot

device=$1
hostname=$2
MIRROR_COUNTRY=US

echo_section() {
	echo -e "\n# $1\n"
}


echo_section "Updating clock"
timedatectl set-ntp true


echo_section "Setting up pacman"
reflector \
	--protocol https \
	--country "$MIRROR_COUNTRY" \
	--save /etc/pacman.d/mirrorlist
pacman -Sy


./setup_scripts/partitioning/lvm_partition.sh "$device"


echo_section "Installing Arch essential packages"
pacstrap /mnt base linux linux-firmware mkinitcpio


echo_section "Creating fstab"
genfstab -L /mnt >> /mnt/etc/fstab


echo_section "chroot and setup system"
cp -R ./setup_scripts /mnt/root/
arch-chroot /mnt /root/setup_scripts/setup_step_2.sh "$hostname"
