#!/usr/bin/env bash
set -Eeuo pipefail
device=$1

vg_name=vgprimary

efi_dev=${device}1
lvm_dev=${device}2
root_dev=/dev/$vg_name/root
swap_dev=/dev/$vg_name/swap

echo "Setting up partitions on $device"
parted --script "$device" \
	mklabel gpt \
	mkpart '"efi"' fat32 0% 512MiB \
	set 1 esp on \
	mkpart '"lvm"' 512 100% \
	set 2 lvm on

# lvm vgdisplay -> "Total PE" is total extents available for logical volumes

pacman -S --noconfirm jq

echo "Setting up lvm"
lvm pvcreate "$lvm_dev"
lvm vgcreate "$vg_name" "$lvm_dev"
# Assumption! Physical Extent size is 4MiB
vg_extent_size=4
vg_extent_count=$(lvm vgs "$vg_name" -o vg_extent_count --reportformat json | jq -r '.report[0].vg[0].vg_extent_count')
swap_size=980
swap_extent_count=$((swap_size / vg_extent_size))
# root size is remainder of volume group
root_extent_count=$((vg_extent_count - swap_extent_count))
lvm lvcreate -l "$root_extent_count" -n root "$vg_name"
lvm lvcreate -l "$swap_extent_count" -n swap "$vg_name"

echo "Formatting disk"
mkfs.fat -F32 -n efi "$efi_dev"
mkfs.ext4 -L root "$root_dev"
mkswap -L swap "$swap_dev"

echo "Mounting FS"
mount "$root_dev" /mnt
mkdir /mnt/efi
mount "$efi_dev" /mnt/efi
mkdir /mnt/boot
swapon "$swap_dev"
