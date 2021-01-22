#!/usr/bin/env bash
set -Eeuo pipefail

# 1) autoconf
# 2) automake
# 3) binutils
# 4) bison
# 5) fakeroot
# 6) file
# 7) findutils
# 8) flex
# 9) gawk
# 10) gcc
# 11) gettext
# 12) grep
# 13) groff
# 14) gzip
# 15) libtool
# 16) m4
# 17) make
# 18) pacman
# 19) patch
# 20) pkgconf
# 21) sed
# 22) sudo
# 23) texinfo
# 24) which

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
# xorg-fonts-100dpi \
pacman -Syu --needed --noconfirm \
	xorg-server \
	xorg-docs

# gnu-free-fonts \
# cronie \
pacman -Syu --needed --noconfirm \
	ttf-droid \
	ttf-dejavu \
	ttf-liberation \
	phonon-qt5-gstreamer \
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
