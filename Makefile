# Make Config
# -----------

# Allow prerequisite automatic variables
.SECONDEXPANSION:
# Disable implicit suffix rules
.SUFFIXES:


# Tasks
# -----

lint:
	@ansible-playbook -i inventory/local.yaml --syntax-check local.yml
	@ansible-lint local.yml

run-test:
	@ansible-playbook -i inventory/virtualbox.yaml --ask-become-pass local.yml

run-local:
	@ansible-playbook -i inventory/local.yaml --ask-become-pass local.yml

facts:
	@ansible localhost -m setup
