MESSAGES_URL = https://messages.google.com/web/authentication
APP_NAME = "Android Messages"
BIN_DIR = bin

INSTALL = nativefier --name $(APP_NAME) --single-instance -p

clean:
	rm -rf $(BIN_DIR)
	rm -rf Android*Messages-*

mac:
	mkdir -p $(BIN_DIR)
	$(INSTALL) darwin $(MESSAGES_URL)
	mv Android\ Messages-darwin* $(BIN_DIR)/android-messages-darwin
	cd $(BIN_DIR)/android-messages-darwin && zip -r -q ../android-messages-darwin.zip *
	rm -rf $(BIN_DIR)/android-messages-darwin

install-mac: mac
	cd $(BIN_DIR) && mkdir -p install && unzip android-messages-darwin.zip -d install
	sudo rm -rf /Applications/Android\ Messages.app
	sudo mv $(BIN_DIR)/install/Android\ Messages.app /Applications/
	rm -rf $(BIN_DIR)/install

linux:
	mkdir -p $(BIN_DIR)
	$(INSTALL) linux $(MESSAGES_URL)
	mv AndroidMessages-linux-* $(BIN_DIR)/android-messages-linux
	cd $(BIN_DIR)/android-messages-linux && zip -r -q ../android-messages-linux.zip *
	rm -rf $(BIN_DIR)/android-messages-linux

install-linux: linux
	cd $(BIN_DIR) && mkdir -p install && unzip android-messages-linux.zip -d install
	rm -rf /opt/android-messages
	mkdir -p /opt/android-messages
	mv $(BIN_DIR)/install/* /opt/android-messages
	rm -rf $(BIN_DIR)/install
	sudo ln -s /opt/android-messages/AndroidMessages /usr/bin/android-messages
	sudo mkdir -p /usr/share/icons/hicolor/512x512/apps
	sudo cp bin/android-messages-linux/resources/app/icon.png /usr/share/icons/hicolor/512x512/apps/android-messages.png
	sudo cp static/linux.desktop /usr/share/applications/android-messages.desktop

uninstall-linux:
	sudo rm -rf /usr/bin/android-messages
	sudo rm -rf /usr/share/icons/hicolor/512x512/apps/android-messages.png
	sudo rm -rf /usr/share/applications/android-messages.desktop
	rm -rf /opt/android-messages

windows:
	mkdir -p $(BIN_DIR)
	$(INSTALL) windows $(MESSAGES_URL)

build: mac linux windows
