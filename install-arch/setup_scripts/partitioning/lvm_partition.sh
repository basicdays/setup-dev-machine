#!/usr/bin/env bash
set -Eeuo pipefail
device=$1

efi_size=512
efi_partition=1
efi_label=efi
lvm_partition=2
lvm_label=lvm
root_label=root
swap_size=980
swap_label=swap
vg_name=vgprimary

if [[ "$device" == *"nvme"* ]]; then
	# e.g. nvme0n1
	efi_dev=${device}p${efi_partition}
	lvm_dev=${device}p${lvm_partition}
else
	# e.g. sda
	efi_dev=${device}${efi_partition}
	lvm_dev=${device}${lvm_partition}
fi
root_dev=/dev/$vg_name/$root_label
swap_dev=/dev/$vg_name/$swap_label

echo_section() {
	echo -e "\n# $1\n"
}


echo_section "Setting up partitions on $device"
parted -s "$device" mklabel gpt
parted -s "$device" mkpart "\"$efi_label\"" fat32 0% "${efi_size}MiB" set "$efi_partition" esp on
parted -s "$device" mkpart "\"$lvm_label\"" "${efi_size}MiB" 100% set "$lvm_partition" lvm on


echo_section "Setting up lvm"
lvm pvcreate "$lvm_dev"
lvm vgcreate "$vg_name" "$lvm_dev"
# usually 4 (i.e. each extent size is 4mb)
# example: `  4.00m` => `4`
vg_extent_size=$(lvm vgs "$vg_name" -o vg_extent_size --noheadings | awk 'match($0, /[[:digit:]]+/, data) {print data[0]}')
# example: `  4200` => `4200`
vg_extent_count=$(lvm vgs "$vg_name" -o vg_extent_count --noheadings | sed 's/^[[:space:]]*|[[:space:]]*$//g')
swap_extent_count=$((swap_size / vg_extent_size))
# root size is remainder of volume group
root_extent_count=$((vg_extent_count - swap_extent_count))
lvm lvcreate -l "$root_extent_count" -n "$root_label" "$vg_name"
# ensures swap space is at end of drive to make resizing root easier
lvm lvcreate -l "$swap_extent_count" -n "$swap_label" "$vg_name"


echo_section "Formatting Disk"
mkfs.fat -F32 -n "$efi_label" "$efi_dev"
mkfs.ext4 -L "$root_label" "$root_dev"
mkswap -L "$swap_label" "$swap_dev"


echo_section "Mounting FS"
mount "$root_dev" /mnt
mkdir /mnt/efi
mount "$efi_dev" /mnt/efi
swapon "$swap_dev"
