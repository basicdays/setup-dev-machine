#!/usr/bin/env bash
set -Eeuo pipefail

if ! command -v ansible &> /dev/null; then
	if command -v apt-get &> /dev/null; then
		sudo apt-get install -y git python3-pip
		pip3 install --user ansible
	elif command -v pacman &> /dev/null; then
		pacman -Sy --needed --noconfirm ansible git
		ansible-galaxy collection install community.general
		ansible-galaxy install kewlfft.aur
	fi
fi

ansible-pull \
	--accept-host-key \
	--url https://github.com/basicdays/setup-dev-machine.git \
	--ask-become-pass \
	-i inventory/local.yaml
