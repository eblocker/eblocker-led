LED_HOME = $(DESTDIR)/opt/eblocker-led
INITD = $(DESTDIR)/etc/init.d
LOGROTATED = $(DESTDIR)/etc/logrotate.d

build:
	bundle package --all

install:
	mkdir -p $(INITD)
	cp etc/init.d/eblocker-led $(INITD)
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
