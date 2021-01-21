#!/usr/bin/env bash
set -Eeuo pipefail

# Setup Arch install from live boot
device=/dev/sda
efi_partition=${device}1
swap_partition=${device}2
root_partition=${device}3
MIRROR_COUNTRY=US


echo "Updating clock"
timedatectl set-ntp true


echo "Setting up partitions on $device"
parted --script $device \
	mklabel gpt \
	mkpart '"EFI System Partition"' fat32 0% 512MiB \
	set 1 esp on \
	mkpart '"Swap Partition"' linux-swap 512MiB 1024MiB \
	mkpart '"Root_Partition"' ext4 1024MiB 100%

mkfs.fat -F32 $efi_partition
mkswap $swap_partition
mkfs.ext4 $root_partition

mount $root_partition /mnt
mkdir /mnt/efi
mount $efi_partition /mnt/efi
swapon $swap_partition


echo "Installing Arch essential packages"
reflector \
	--protocol https \
	--country $MIRROR_COUNTRY \
	--save /etc/pacman.d/mirrorlist
pacstrap /mnt base linux linux-firmware


echo "Creating fstab"
genfstab -U /mnt >> /mnt/etc/fstab


echo "chroot and setup system"
cp -R ./setup_scripts /mnt/root/
arch-chroot /mnt /root/setup_scripts/setup_step_2.sh


echo "Unmounting partitions and rebooting"
umount -R /mnt
reboot
