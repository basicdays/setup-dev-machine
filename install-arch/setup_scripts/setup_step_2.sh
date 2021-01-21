#!/usr/bin/env bash
set -Eeuo pipefail

TIME_ZONE=America/Chicago
LOCALE=en_US.UTF-8
HOST_NAME=trigger-3-vbox-1
USER_NAME=basicdays


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


echo "Installing packages and enabling services"
if lscpu | grep -q -i "AMD"; then
	CPU_MICROCODE=amd-ucode
elif lscpu | grep -q -i "Intel"; then
	CPU_MICROCODE=intel-ucode
fi
pacman -Syu --noconfirm \
	$CPU_MICROCODE \
	grub \
	breeze-grub \
	efibootmgr \
	os-prober \
	networkmanager \
	openssh \
	sudo \
	zsh
systemctl enable NetworkManager.service
systemctl enable sshd.service


echo "Installing grub"
sed -i -e '/GRUB_THEME=/ s/=.*/="/usr/share/grub/themes/breeze/theme.txt"/' /etc/default/grub
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig --output /boot/grub/grub.cfg


echo "Setup sudo"
echo "%wheel ALL=(ALL) ALL" | EDITOR="tee" visudo /etc/sudoers.d/10-wheel


echo "Set root password"
passwd


echo "Create user $USER_NAME"
useradd --create-home --groups adm,wheel --shell /usr/bin/zsh $USER_NAME
passwd $USER_NAME
