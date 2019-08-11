messagesURL = https://messages.google.com/web/authentication
appName = "Android Messages"
binDir = bin

clean:
	rm -rf $(binDir)

mac:
	mkdir -p $(binDir)
	nativefier --name $(appName) --single-instance $(messagesURL)
	mv Android\ Messages-darwin* $(binDir)/android-messages-darwin
	cd $(binDir)/android-messages-darwin && zip -r -q ../android-messages-macos.zip *
	rm -rf $(binDir)/android-messages-darwin

install-mac: mac
	cd $(binDir) && mkdir -p install && unzip android-messages-macos.zip -d install
	sudo rm -rf /Applications/Android\ Messages.app
	sudo mv $(binDir)/install/Android\ Messages.app /Applications/
	rm -rf $(binDir)/install

linux:
	mkdir -p $(binDir)
	nativefier --name $(appName) --single-instance -p linux $(messagesURL)
	mv android-messages-linux-* $(binDir)/android-messages-linux
	cd $(binDir)/android-messages-linux && zip -r -q ../android-messages-linux.zip *
	rm -rf $(binDir)/android-messages-linux

windows:
	mkdir -p $(binDir)
	nativefier --name $(appName) --single-instance -p windows $(messagesURL)

build: mac linux windows
