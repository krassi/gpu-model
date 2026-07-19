PREFIX  ?= /usr
DESTDIR ?=
PKGNAME := gpu-model
VERSION := 0.1.0
ARCH    := all

BINDIR := $(DESTDIR)$(PREFIX)/bin
MANDIR := $(DESTDIR)$(PREFIX)/share/man/man1
DOCDIR := $(DESTDIR)$(PREFIX)/share/doc/$(PKGNAME)

.PHONY: all install uninstall deb check clean

all:
	@echo "targets: install, uninstall, deb, check, clean"

check:
	bash -n gpu-model

install:
	install -Dm755 gpu-model $(BINDIR)/gpu-model
	install -Dm644 man/gpu-model.1 $(MANDIR)/gpu-model.1
	install -Dm644 packaging/gpu-model.conf.example $(DOCDIR)/gpu-model.conf.example
	install -Dm644 README.md $(DOCDIR)/README.md

uninstall:
	rm -f $(BINDIR)/gpu-model $(MANDIR)/gpu-model.1
	rm -rf $(DOCDIR)

# Build a .deb using only dpkg-deb (no debhelper required).
deb: check
	rm -rf build/deb
	$(MAKE) install DESTDIR=$(CURDIR)/build/deb PREFIX=/usr
	mkdir -p build/deb/DEBIAN
	sed -e 's/@VERSION@/$(VERSION)/' -e 's/@ARCH@/$(ARCH)/' packaging/control.in > build/deb/DEBIAN/control
	gzip -n9 < man/gpu-model.1 > build/deb/$(PREFIX)/share/man/man1/gpu-model.1.gz
	rm -f build/deb/$(PREFIX)/share/man/man1/gpu-model.1
	chmod 644 build/deb/$(PREFIX)/share/man/man1/gpu-model.1.gz
	dpkg-deb --root-owner-group --build build/deb build/$(PKGNAME)_$(VERSION)_$(ARCH).deb
	@echo "built build/$(PKGNAME)_$(VERSION)_$(ARCH).deb"

clean:
	rm -rf build
