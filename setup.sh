#!/usr/bin/env bash
# Bootstrap the local machine from default install

set -Eeuo pipefail

sudo apt install git python3-pip
pip3 install --user ansible
# shellcheck source=/dev/null
. "${HOME}/.profile"

playbook_dir="${HOME}/Documents/wip/personal"
mkdir -p "${playbook_dir}"
cd "${playbook_dir}"
ansible-pull \
	--url https://github.com/basicdays/setup-dev-machine.git \
	--ask-become-pass \
	-i inventory/local.yaml \
	site-yaml
