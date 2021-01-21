#!/usr/bin/env bash
set -Eeuo pipefail
device=$1

efi_dev=${device}1
swap_dev=${device}2
root_dev=${device}3

echo "Setting up partitions on $device"
parted --script "$device" \
	mklabel gpt \
	mkpart '"efi"' fat32 0% 512MiB \
	set 1 esp on \
	mkpart '"swap"' linux-swap 512MiB 1024MiB \
	mkpart '"root"' ext4 1024MiB 100%

echo "Formatting disk"
mkfs.fat -F32 -n efi "$efi_dev"
mkswap -L swap "$swap_dev"
mkfs.ext4 -L root "$root_dev"

echo "Mounting FS"
mount "$root_dev" /mnt
mkdir /mnt/efi
mount "$efi_dev" /mnt/efi
swapon "$swap_dev"
