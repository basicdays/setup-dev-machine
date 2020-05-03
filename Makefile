# Make Config
# -----------

# Allow prerequisite automatic variables
.SECONDEXPANSION:
# Disable implicit suffix rules
.SUFFIXES:


# Tasks
# -----

lint:
	@ansible-playbook -i inventory/local.yaml --syntax-check local.yaml
	@ansible-lint local.yaml

run-test:
	@ansible-playbook -i inventory/virtualbox.yaml --ask-become-pass local.yaml

run-local:
	@ansible-playbook -i inventory/local.yaml --ask-become-pass local.yaml

facts:
	@ansible localhost -m setup
