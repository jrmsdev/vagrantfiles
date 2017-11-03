SH ?= /bin/sh
SCRIPTSD != realpath ../scripts


.PHONY: default
default: .box.up


.PHONY: clean
clean:
	@vagrant halt
	@vagrant destroy
	@rm -vf package.box .box.*


.PHONY: build
build: package.box


.box.up:
	@vagrant up
	@touch .box.up


package.box: .box.up
	@rm -vf package.box
	@vagrant package


.PHONY: init
init:
	$(SH) $(SCRIPTSD)/cloudbox-newbox.sh
	$(SH) $(SCRIPTSD)/cloudbox-newversion.sh
	$(SH) $(SCRIPTSD)/cloudbox-newprovider.sh


.PHONY: upload
upload: build
	$(SH) $(SCRIPTSD)/cloudbox-upload.sh
	$(SH) $(SCRIPTSD)/cloudbox-release.sh


.PHONY: update
update: build
	$(SH) $(SCRIPTSD)/cloudbox-newversion.sh
	$(SH) $(SCRIPTSD)/cloudbox-newprovider.sh
	$(SH) $(SCRIPTSD)/cloudbox-upload.sh
	$(SH) $(SCRIPTSD)/cloudbox-release.sh
