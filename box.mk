SH ?= /bin/sh
SCRIPTSD := ../scripts
BOX_NAME != basename `pwd`
BOX_VERSION != cat version.txt
BOX_BASE := base-$(BOX_VERSION).box


.PHONY: default
default: build


.box.build:
	vagrant up
	vagrant provision
	@touch .box.build


.PHONY: build
build: .box.build


.PHONY: clean
clean: stop
	@rm -vf *.box .box.*


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


$(BOX_BASE): .box.build
	@rm -f $(BOX_BASE)
	vagrant up
	vagrant provision --provision-with minimize
	vagrant snapshot save -f prepkg-$(BOX_VERSION)
	vagrant provision --provision-with sshauth
	vagrant package --base jrmsdev-$(BOX_NAME) --output $(BOX_BASE)
	vagrant snapshot restore --no-provision prepkg-$(BOX_VERSION)


.box.upload: $(BOX_BASE)
	$(SH) $(SCRIPTSD)/cloudbox-upload.sh $(BOX_BASE)
	$(SH) $(SCRIPTSD)/cloudbox-release.sh
	@touch .box.upload


.PHONY: pkg
pkg: $(BOX_BASE)


.PHONY: upload
upload: .box.upload


.PHONY: update
update:
	@$(MAKE) newversion import upload


.PHONY: import
import: $(BOX_BASE)
	vagrant box add -c -f --provider virtualbox \
		--name jrmsdev/$(BOX_NAME) \
		$(BOX_BASE)


.PHONY: delbox
delbox: distclean
	$(SH) $(SCRIPTSD)/cloudbox-delbox.sh


.PHONY: reload
reload:
	vagrant reload --provision


.PHONY: start
start:
	vagrant up


.PHONY: stop
stop:
	vagrant halt
