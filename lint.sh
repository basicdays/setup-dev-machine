#!/usr/bin/env sh
ansible-lint site.yaml
ansible-playbook --syntax-check site.yaml
