#!/usr/bin/env bash
set -Eeuo pipefail

systemctl enable NetworkManager.service
systemctl start NetworkManager.service
systemctl enable sshd.service
systemctl start sshd.service

useradd -m basicdays
usermod -aG adm,wheel basicdays

# edit /etc/xdg/reflector/reflector.conf
systemctl enable reflector.timer
systemctl start reflector.service

# visudo
# - uncomment line: %wheel ALL=(ALL) ALL

# sed
# file: /etc/pacman.conf
# uncomment:
# [multilib]
# Include = /etc/pacman.d/mirrorlist
pacman -Syy

# passwd
