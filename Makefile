# Default flag behavior
ONLY_SCRIPTS := $(ONLY_SCRIPTS)

# Directories
SRC_DIR := src
PKG_BIN_DIR := $(DESTDIR)/usr/local/bin
PKG_SBIN_DIR := $(DESTDIR)/usr/local/sbin
PKG_ETC_DIR := $(DESTDIR)/etc
PKG_DESKTOP_DIR := $(DESTDIR)/usr/share/applications
PKG_ICON_DIR := $(DESTDIR)/usr/share/icons
PKG_MAN_DIR := $(DESTDIR)/usr/man
PKG_DOC_DIR := $(DESTDIR)/usr/doc/$(PRGNAM)-$(VERSION)

# Check for qmake6, fall back to qmake if not found
QMAKE := $(shell which qmake6 2>/dev/null || echo qmake)
$(info Using qmake: $(QMAKE))

# Default target: build the project and install everything
ifeq ($(ONLY_SCRIPTS),YES)
  install: install_scripts install_env install_desktop install_icons install_man install_docs
else
  all: build install
endif

# Build the project using qmake and make (from src/)
build:
	@for d in $(SRC_DIR)/*/; do \
		cd $$d && \
		$(QMAKE) && \
		make && \
		cd -; \
	done

install_binaries:
	@mkdir -p $(PKG_SBIN_DIR) $(PKG_BIN_DIR)
	@for d in $(SRC_DIR)/*/; do \
		cd $$d; \
		if [ -f "$(PRGNAM)" ]; then \
			cp "$(PRGNAM)" "$(PKG_SBIN_DIR)/"; \
		fi; \
		if [ -f "$(PRGNAM2)" ]; then \
			cp "$(PRGNAM2)" "$(PKG_SBIN_DIR)/"; \
		fi; \
		if [ -f "$(PRGNAM3)" ]; then \
			cp "$(PRGNAM3)" "$(PKG_SBIN_DIR)/"; \
		fi; \
		cd -; \
	done

# Install scripts (from scripts/)
install_scripts:
	@mkdir -p $(PKG_BIN_DIR)
	@for i in scripts/*; do \
		if [ -f $$i ]; then \
			cp $$i $(PKG_BIN_DIR)/; \
		fi; \
	done
	@chmod +x $(PKG_BIN_DIR)/*

# Install environment files (from ENV/)
install_env:
	@mkdir -p $(PKG_ETC_DIR)
	@cp -R ENV/* $(PKK_ETC_DIR)/

# Install desktop files (from desktops/)
install_desktop:
	@mkdir -p $(PKG_DESKTOP_DIR)
	@for desktop in desktops/*; do \
		if [ -f $$desktop ] && [[ $$desktop == *.desktop ]]; then \
			cp $$desktop $(PKG_DESKTOP_DIR)/; \
		fi; \
	done

# Install icons (hicolor and application-specific)
install_icons:
	# Install hicolor icons
	@mkdir -p $(DESTDIR)/usr/share/icons/hicolor
	@cp -R icons/hicolor $(DESTDIR)/usr/share/icons/

	# Install application-specific icons
	@mkdir -p $(DESTDIR)/usr/share/icons
	@cp -R icons/Slackware-Commander $(DESTDIR)/usr/share/icons/
	@cp -R icons/logos $(DESTDIR)/usr/share/icons/

# Install man pages and compress them (from .1 files)
install_man:
	@mkdir -p $(PKG_MAN_DIR)
	@cp -R man1 $(PKG_MAN_DIR)/
	@find $(PKG_MAN_DIR) -type f -exec gzip -9 {} \;
	@for i in $(shell find $(PKG_MAN_DIR) -type l); do \
		ln -s $$(readlink $$i).gz $$i.gz; \
		rm $$i; \
	done

# Install documentation (from docs/)
install_docs:
	@mkdir -p $(PKG_DOC_DIR)
	@cp docs/* $(PKG_DOC_DIR)/

# Install everything: binaries, scripts, environment, desktop, icons, man pages, and docs
install: install_binaries install_scripts install_env install_desktop install_icons install_man install_docs

# Phony targets to ensure they're always executed
.PHONY: all build install install_binaries install_scripts install_env install_desktop install_icons install_man install_docs
