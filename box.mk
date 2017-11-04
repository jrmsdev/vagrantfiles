SH ?= /bin/sh
SCRIPTSD := ../scripts
BOX_NAME != basename `pwd`
BOX_VERSION != cat version.txt


.PHONY: default
default: build


.box.build:
	vagrant up --provision
	@touch .box.build


.PHONY: build
build: .box.build


.PHONY: clean
clean:
	vagrant halt
	@rm -vf base.box .box.*


.PHONY: distclean
distclean: clean
	vagrant destroy
	@rm -vrf .vagrant


.PHONY: newbox
newbox:
	$(SH) $(SCRIPTSD)/cloudbox-newbox.sh
	$(SH) $(SCRIPTSD)/cloudbox-newversion.sh
	$(SH) $(SCRIPTSD)/cloudbox-newprovider.sh


.PHONY: newversion
newversion:
	date '+%Y.%m.%d' >version.txt
	$(SH) $(SCRIPTSD)/cloudbox-newversion.sh
	$(SH) $(SCRIPTSD)/cloudbox-newprovider.sh


base.box: .box.build
	@rm -f base.box
	vagrant provision --provision-with minimize,sshauth
	vagrant package --base jrmsdev-$(BOX_NAME) --output base.box


.box.upload: base.box
	$(SH) $(SCRIPTSD)/cloudbox-upload.sh
	$(SH) $(SCRIPTSD)/cloudbox-release.sh
	@touch .box.upload


.PHONY: pkg
pkg: base.box


.PHONY: upload
upload: .box.upload


.PHONY: update
update:
	@$(MAKE) newversion import upload


.PHONY: import
import: base.box
	vagrant box add -c -f --provider virtualbox \
		--name jrmsdev/$(BOX_NAME) \
		base.box


.PHONY: delbox
delbox:
	$(SH) $(SCRIPTSD)/cloudbox-delbox.sh


.PHONY: reload
reload:
	vagrant reload --provision
