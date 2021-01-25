#!/usr/bin/env bash
set -Eeuo pipefail

USER_NAME=basicdays

install_aur() {
	name=$1
	path=$HOME/opt/aur/$name
	git clone "https://aur.archlinux.org/$name.git " "$path"
	(cd "$path" && makepkg -si)
}

# system utils
pacman -Syu --needed --noconfirm \
	base-devel \
	vim \
	which \
	man-db \
	man-pages \
	texinfo \
	wget \
	tmux

# programming languages
pacman -Syu --needed --noconfirm \
	nodejs \
	python \
	python-pip

# video drivers
# https://wiki.archlinux.org/index.php/Hardware_video_acceleration
# https://wiki.archlinux.org/index.php/Intel_graphics
pacman -Syu --needed --noconfirm mesa vulkan-intel

# vbox drivers
# https://wiki.archlinux.org/index.php/VirtualBox/Install_Arch_Linux_as_a_guest
# pacman -Syu --needed --noconfirm virtualbox-guest-utils
# systemctl enable vboxservice.service

# bluetooth
# https://wiki.archlinux.org/index.php/Bluetooth
pacman -Syu --needed --noconfirm \
	bluez \
	bluez-utils \
	pulseaudio-bluetooth
sed -i -r 's/^#?AutoEnable=.*/AutoEnable=true/' /etc/bluetooth/main.conf
systemctl enable bluetooth.service

# printers
pacman -Syu --needed --noconfirm cups cups-pdf
systemctl enable cups.service

# xorg
pacman -Syu --needed --noconfirm \
	xorg-server \
	xorg-docs

# fonts
pacman -Syu --needed --noconfirm \
	ttf-liberation \
	ttf-dejavu \
	noto-fonts \
	noto-fonts-cjk \
	noto-fonts-emoji \
	ttf-roboto \
	ttf-fira-code

# plasma
pacman -Syu --needed --noconfirm \
	phonon-qt5-vlc \
	sddm \
	plasma-meta \
	libdbusmenu-glib
systemctl enable sddm.service

# plasma apps
sudo pacman -Syu --needed --noconfirm \
	akregator \
	ark \
	audiocd-kio \
	dolphin \
	ffmpegthumbs \
	filelight \
	gwenview \
	k3b \
	kaddressbook \
	kamera \
	kamoso \
	kate \
	kcalc \
	kdeconnect \
	kdegraphics-thumbnailers\
	kdenetwork-filesharing \
	kdepim-addons \
	kdf \
	kdialog \
	keditbookmarks \
	kgpg \
	khelpcenter \
	kio-extras \
	kmail \
	kmail-account-wizard \
	konsole \
	kontact \
	konversation \
	korganizer \
	krdc \
	ksystemlog \
	ktorrent \
	kwalletmanager \
	okular \
	partitionmanager \
	pim-data-exporter \
	pim-sieve-editor \
	print-manager \
	signon-kwallet-extension \
	spectacle \
	sweeper \
	vlc \
	yakuake

# browsers
pacman -Syu --needed --noconfirm firefox chromium pepper-flash

# todo: might not even need snap?
# apparmor
# https://wiki.archlinux.org/index.php/AppArmor
systemctl enable apparmor.service
# todo: need to check if this works correctly

# snap
# https://wiki.archlinux.org/index.php/Snap
install_aur snapd
systemctl enable snapd.apparmor.service
systemctl enable snapd.socket

# virtualbox
# https://wiki.archlinux.org/index.php/VirtualBox
pacman -Syu --needed --noconfirm virtualbox virtualbox-host-modules-arch virtualbox-guest-iso
install_aur virtualbox-ext-oracle
usermod -a -G vboxusers "$USER_NAME"

# VSCode
# https://wiki.archlinux.org/index.php/Visual_Studio_Code
install_aur visual-studio-code-bin

# Spotify
# https://wiki.archlinux.org/index.php/spotify
install_aur spotify

# Discord
# https://wiki.archlinux.org/index.php/Discord
pacman -Syu --needed --noconfirm discord

# Telegram
# https://wiki.archlinux.org/index.php/Telegram
pacman -Syu --needed --noconfirm telegram-desktop

# Slack
# https://aur.archlinux.org/packages/slack-desktop/
install_aur slack-desktop

# todo: https://wiki.archlinux.org/index.php/SSH_keys#SSH_agents
