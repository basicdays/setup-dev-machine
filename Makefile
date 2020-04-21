# Make Config
# -----------

# Allow prerequisite automatic variables
.SECONDEXPANSION:
# Disable implicit suffix rules
.SUFFIXES:


# Tasks
# -----

lint:
	@ansible-playbook -i inventory/local.yaml --syntax-check site.yaml
	@ansible-lint site.yaml

run-test:
	@ansible-playbook -i inventory/virtualbox.yaml --ask-become-pass site.yaml

run-local:
	@ansible-playbook -i inventory/local.yaml --ask-become-pass site.yaml

facts:
	@ansible localhost -m setup
