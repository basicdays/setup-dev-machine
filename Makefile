# Make Config
# -----------

# Allow prerequisite automatic variables
.SECONDEXPANSION:
# Disable implicit suffix rules
.SUFFIXES:


# Tasks
# -----

lint:
	@ansible-playbook -i inventories/local --syntax-check site.yml
	@ansible-lint site.yml

run-test:
	@ansible-playbook -i inventories/virtualbox --ask-become-pass site.yml

run-local:
	@ansible-playbook -i inventories/local --ask-become-pass site.yml

facts:
	@ansible localhost -m setup
