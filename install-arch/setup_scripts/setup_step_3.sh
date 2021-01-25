#!/usr/bin/env bash
set -Eeuo pipefail

# system utils
pacman -Syu --needed --noconfirm \
	base-devel \
	vim \
	which \
	man-db \
	man-pages \
	texinfo \
	tmux

pacman -Syu --needed --noconfirm cups cups-pdf
systemctl enable cups
systemctl start cups

# video drivers
pacman -Syu --needed --noconfirm mesa vulkan-intel

# pacman -Syu --needed --noconfirm virtualbox-guest-utils
# systemctl enable vboxservice
# systemctl start vboxservice

# xorg
pacman -Syu --needed --noconfirm \
	xorg-server \
	xorg-docs

pacman -Syu --needed --noconfirm \
	ttf-liberation \
	ttf-dejavu \
	noto-fonts \
	noto-fonts-cjk \
	noto-fonts-emoji \
	ttf-roboto \
	phonon-qt5-vlc \
	sddm \
	plasma-meta

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

pacman -Syu --needed --noconfirm firefox chromium pepper-flash

systemctl enable sddm
systemctl start sddm
