#!/usr/bin/env bash
set -Eeuo pipefail

# Setup Arch install from live boot

DEVICE=/dev/sda
MIRROR_COUNTRY=US
TIME_ZONE=America/Chicago
LOCALE=en_US.UTF-8
HOST_NAME=trigger-3-vbox-1

if lscpu | grep -q -i "AMD"; then
	CPU_MICROCODE=amd-ucode
elif lscpu | grep -q -i "Intel"; then
	CPU_MICROCODE=intel-ucode
fi

# device=/dev/sda
# efi_partition=1
# boot_partition=2
# lvm_partition=3

# parted --script "$device" \
# 	mklabel gpt \
# 	mkpart "EFI System Partition" fat32 0% 512MiB \
# 	set 1 esp on \
# 	mkpart "Boot Partition" ext4 512MiB 1024MiB \
# 	mkpart "LVM Partition" 1024MiB 100%

# mkfs.fat -F32 "${device}${efi_partition}"
# mkfs.ext4 "${device}${boot_partition}"

echo "Updating clock"
timedatectl set-ntp true


echo "Setting up partitions on $DEVICE"
parted --script $DEVICE \
	mklabel gpt \
	mkpart "EFI System Partition" fat32 0% 512MiB \
	set 1 esp on \
	mkpart "Swap Partition" linux-swap 512MiB 1024MiB \
	mkpart "Root Partition" ext4 1024MiB 100%

mkfs.fat -F32 ${DEVICE}1
mkswap ${DEVICE}2
mkfs.ext4 ${DEVICE}3

mount ${DEVICE}3 /mnt
mkdir /mnt/efi
mount ${DEVICE}1 /mnt/efi
swapon ${DEVICE}2


echo "Installing Arch essential packages"
reflector \
	--protocol https \
	--country $MIRROR_COUNTRY \
	--save /etc/pacman.d/mirrorlist

pacstrap /mnt \
	base linux linux-firmware \
	grub efibootmgr $CPU_MICROCODE os-prober \
	networkmanager


echo "Creating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt


echo "Setting timezone to $TIME_ZONE"
ln -sf "/usr/share/zoneinfo/$TIME_ZONE" /etc/localtime
hwclock --systohc


echo "Setting locale to $LOCALE"
sed -i "/^#$LOCALE/s/^#//g" /etc/locale.gen
locale-gen
echo "LANG=$LOCALE" > /etc/locale.conf


echo "Setting hostname to $HOST_NAME"
echo "$HOST_NAME" > /etc/hostname
cat <<END > /etc/hosts
127.0.0.1 localhost
::1       localhost
127.0.1.1 $HOST_NAME.localdomain $HOST_NAME
END


echo "Set root password"
passwd


echo "Installing grub"
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig --output /boot/grub/grub.cfg


echo "Unmounting partitions and rebooting"
# exit chroot
exit
umount -R /mnt
reboot
