LED_HOME = $(DESTDIR)/opt/eblocker-led
LOGROTATED = $(DESTDIR)/etc/logrotate.d
SYSTEMD = $(DESTDIR)/lib/systemd/system

build:
	bundle package --all

install:
	mkdir -p $(SYSTEMD)
	cp etc/systemd/eblocker-led.service $(SYSTEMD)
	mkdir -p $(LOGROTATED)
	cp etc/logrotate.d/eblocker-led $(LOGROTATED)
	mkdir -p $(LED_HOME)
	cp -r .bundle $(LED_HOME)
	cp -r bin  $(LED_HOME)
	cp eblocker-led.gemspec $(LED_HOME)
	cp Gemfile $(LED_HOME)
	cp Gemfile.lock $(LED_HOME)
	cp -r lib $(LED_HOME)
	mkdir -p $(LED_HOME)/log
	cp -r README.md $(LED_HOME)
	mkdir -p $(LED_HOME)/run
	cp -r vendor $(LED_HOME)

package:
	dpkg-buildpackage -us -uc
