# Define the directories
PKG := $(DESTDIR)
BIN_DIR := $(PKG)/usr/local/bin/captain-slack
ETC_DIR := $(PKG)/etc/captain-slack
VAR_DIR := $(PKG)/var/lib/captain-slack
LOG_DIR := $(PKG)/var/log/captain-slack
SHARE_DIR := $(PKG)/usr/share/captain-slack

# Files to copy
SCRIPTS := *.sh
MAIN_INI := cptn-main.ini
EXEC := cptn

# CONF NEW
MAIN_INI_NEW := cptn-main.ini.new

# Default target to build and install everything
all: install

# Create necessary directories
create_dirs:
	@mkdir -p $(BIN_DIR) $(ETC_DIR) $(VAR_DIR)/{mirror-db,system-db} $(LOG_DIR) $(SHARE_DIR)

# Install the files
install: create_dirs
	@cp $(MAIN_INI) $(ETC_DIR)/$(MAIN_INI_NEW)
	@cp $(EXEC) $(BIN_DIR)/
	@chmod +x $(BIN_DIR)/$(EXEC)
	@cp $(SCRIPTS) $(BIN_DIR)/captain-slack/
	@chmod +x $(BIN_DIR)/captain-slack/*.sh

# Clean the directories
clean:
	@echo "Cleaning up"
	@rm -rf $(PKG)

# Phony targets to ensure they're always executed
.PHONY: all create_dirs install clean
