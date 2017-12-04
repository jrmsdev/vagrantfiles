SH ?= /bin/sh
SCRIPTSD := ../scripts
BOX_NAME != basename `pwd`
BOX_VERSION != cat version.txt
BOX_BASE := base-$(BOX_VERSION).box


.PHONY: default
default: help


.PHONY: help
help:
	@echo 'TARGETS'
	@echo '  help       - show this help message (default)'
	@echo '  clean      - clean build files'
	@echo '  distclean  - clean and vagrant destroy'
	@echo '  build      - vagrant up and provision'
	@echo '  pkg        - vagrant base box package'
	@echo '  start      - vm start'
	@echo '  stop       - vm stop'
	@echo '  reload     - vm reload'
	@echo '  newbox     - cloud new box'
	@echo '  newversion - cloud new box version'
	@echo '  delbox     - cloud delete box'
	@echo '  upload     - could upload vagrant base box'
	@echo '  import     - build and import vagrant base box'
	@echo '  update     - newversion, import and upload box'


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
