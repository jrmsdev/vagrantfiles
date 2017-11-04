SH ?= /bin/sh
BOXES != ls */Makefile | xargs dirname


.PHONY: default
default:
	@echo "boxes: $(BOXES)"


.PHONY: clean
clean:
	@for box in $(BOXES); do echo "BOX: $$box"; $(MAKE) -C $$box clean; done


.PHONY: distclean
distclean:
	@for box in $(BOXES); do echo "BOX: $$box"; $(MAKE) -C $$box distclean; done


.PHONY: build
build:
	@for box in $(BOXES); do echo "BOX: $$box"; $(MAKE) -C $$box build; done


.PHONY: pkg
pkg:
	@for box in $(BOXES); do echo "BOX: $$box"; $(MAKE) -C $$box pkg; done


.PHONY: upload
upload:
	@for box in $(BOXES); do echo "BOX: $$box"; $(MAKE) -C $$box upload; done


.PHONY: update
update:
	@for box in $(BOXES); do echo "BOX: $$box"; $(MAKE) -C $$box update; done
