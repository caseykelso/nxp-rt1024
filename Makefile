HASH := $(shell git rev-parse --short=10 HEAD)
OS := $(shell uname)
ARCH := $(shell uname -m)
J=8
BASE.DIR=$(PWD)
ifeq ($(OS), Darwin)
SED=gsed
endif
ifeq ($(OS), Linux)
SED=sed
endif


SCRIPTS.DIR=$(BASE.DIR)/scripts
DOWNLOADS.DIR=$(BASE.DIR)/downloads
UDEV.DIR=$(BASE.DIR)/udev
BUILD.NUMBER.FILE=$(SCRIPTS.DIR)/build-number.txt
BUILD.NUMBER=$(shell cat $(BUILD.NUMBER.FILE))
INSTALLED.HOST.DIR=$(BASE.DIR)/installed.host
INSTALLED.TARGET.DIR=$(BASE.DIR)/installed.target
TOOLCHAIN.NAME=gcc-arm-none-eabi-7-2017-q4-major
TOOLCHAIN.ARCHIVE.LINUX=$(DOWNLOADS.DIR)/$(TOOLCHAIN.NAME)-linux.tar.bz2
TOOLCHAIN.ARCHIVE.OSX=$(DOWNLOADS.DIR)/$(TOOLCHAIN.NAME)-mac.tar.bz2
TOOLCHAIN.DIR=$(BASE.DIR)/$(TOOLCHAIN.NAME)
TOOLCHAIN.URL.LINUX=https://s3.amazonaws.com/buildroot-sources/$(TOOLCHAIN.NAME)-linux.tar.bz2
TOOLCHAIN.URL.OSX=https://s3.amazonaws.com/buildroot-sources/$(TOOLCHAIN.NAME)-mac.tar.bz2
CMAKE.URL=https://s3.amazonaws.com/buildroot-sources/cmake-3.10.2.tar.gz
CMAKE.DIR=$(DOWNLOADS.DIR)/cmake-3.10.2
CMAKE.ARCHIVE=$(DOWNLOADS.DIR)/cmake-3.10.2.tar.gz
CMAKE.BIN=$(INSTALLED.HOST.DIR)/bin/cmake
ASIO.VERSION=1-12-0
ASIO.ARCHIVE=asio-$(ASIO.VERSION).tar.gz
ASIO.URL=https://github.com/chriskohlhoff/asio/archive/$(ASIO.ARCHIVE)
ASIO.DIR=$(DOWNLOADS.DIR)/asio-asio-$(ASIO.VERSION)/asio
FLEX.VERSION=2.6.3
FLEX.ARCHIVE=flex-$(FLEX.VERSION).tar.gz
FLEX.URL=https://github.com/westes/flex/releases/download/v$(FLEX.VERSION)/$(FLEX.ARCHIVE)
FLEX.DIR=$(DOWNLOADS.DIR)/flex-$(FLEX.VERSION)
BISON.VERSION=3.1
BISON.ARCHIVE=bison-$(BISON.VERSION).tar.gz
BISON.URL=http://gnu.mirrors.hoobly.com/bison/$(BISON.ARCHIVE)
BISON.DIR=$(DOWNLOADS.DIR)/bison-$(BISON.VERSION)
GTEST.VERSION=1.8.1
GTEST.ARCHIVE=release-$(GTEST.VERSION).tar.gz
GTEST.URL=https://github.com/google/googletest/archive/$(GTEST.ARCHIVE)
GTEST.DIR=$(DOWNLOADS.DIR)/googletest-release-1.8.1
GTEST.BUILD=$(DOWNLOADS.DIR)/build.googletest
DOCOPT.VERSION=0.6.2
DOCOPT.ARCHIVE=v$(DOCOPT.VERSION).tar.gz
DOCOPT.URL=https://github.com/docopt/docopt.cpp/archive/$(DOCOPT.ARCHIVE)
DOCOPT.BUILD=$(DOWNLOADS.DIR)/build.docopt
DOCOPT.DIR=$(DOWNLOADS.DIR)/docopt.cpp-$(DOCOPT.VERSION)
CMSIS.MAJORVERSION=5
CMSIS.MINORVERSION=3.0
CMSIS.ARCHIVE=$(CMSIS.MAJORVERSION).$(CMSIS.MINORVERSION).tar.gz
CMSIS.URL=https://github.com/ARM-software/CMSIS_5/archive/$(CMSIS.ARCHIVE)
CMSIS.DIR=$(DOWNLOADS.DIR)/CMSIS_$(CMSIS.MAJORVERSION)-$(CMSIS.MAJORVERSION).$(CMSIS.MINORVERSION)
FIRMWARE.DIR=$(BASE.DIR)/firmware
FIRMWARE.VERSION.HEADER=$(FIRMWARE.DIR)/sources/version.h
FIRMWARE.VERSION.TEMPLATE=$(FIRMWARE.DIR)/sources/version.template
FIRMWARE.SLOT1.BUILD=$(BASE.DIR)/build.firmware-slot1
FIRMWARE.SLOT2.BUILD=$(BASE.DIR)/build.firmware-slot2
FIRMWARE.TESTS.DIR=$(BASE.DIR)/tests
FIRMWARE.TESTS.BUILD=$(BASE.DIR)/build.tests
FIRMWARE.TESTS.BIN=$(INSTALLED.HOST.DIR)/bin/firmware_test
STRIP.BIN=$(TOOLCHAIN.DIR)/bin/arm-none-eabi-strip
FIRMWARE.SLOT1.RELEASE.BIN=$(FIRMWARE.SLOT1.BUILD)/Release/firmware-slot1.bin
FIRMWARE.SLOT1.DEBUG.BIN=$(FIRMWARE.SLOT1.BUILD)/Debug/firmware-slot1.bin
FIRMWARE.SLOT1.DEBUG.SREC=$(FIRMWARE.SLOT1.BUILD)/Debug/firmware-slot1.srec
FIRMWARE.SLOT1.DEBUG.SREC.FILLED=$(FIRMWARE.SLOT1.BUILD)/Debug/firmware-slot1.srec.filled
FIRMWARE.SLOT1.RELEASE.ELF=$(FIRMWARE.SLOT1.BUILD)/Release/firmware-slot1.elf
FIRMWARE.SLOT1.DEBUG.ELF=$(FIRMWARE.SLOT1.BUILD)/Debug/firmware-slot1.elf
FIRMWARE.SLOT2.RELEASE.BIN=$(FIRMWARE.SLOT2.BUILD)/Release/firmware-slot2.bin
FIRMWARE.SLOT2.DEBUG.BIN=$(FIRMWARE.SLOT2.BUILD)/Debug/firmware-slot2.bin
FIRMWARE.SLOT2.DEBUG.SREC=$(FIRMWARE.SLOT2.BUILD)/Debug/firmware-slot2.srec
FIRMWARE.SLOT2.DEBUG.SREC.FILLED=$(FIRMWARE.SLOT2.BUILD)/Debug/firmware-slot2.srec.filled
FIRMWARE.SLOT2.RELEASE.ELF=$(FIRMWARE.SLOT2.BUILD)/Release/firmware-slot2.elf
FIRMWARE.SLOT2.DEBUG.ELF=$(FIRMWARE.SLOT2.BUILD)/Debug/firmware-slot2.elf
FIRMWARE.SLOT1.UPDATE=$(SCRIPTS.DIR)/update_slot1.sh
FIRMWARE.SLOT2.UPDATE=$(SCRIPTS.DIR)/update_slot2.sh

ifeq ($(OS), Darwin)
DEVICE=$(ls /dev/tty.usbmodem*)
endif
ifeq ($(OS), Linux)
DEVICE=$(ls /dev/ttyACM*)
endif
FIRMWARE.SLOT1.SHA=$(shell shasum $(FIRMWARE.SLOT1.DEBUG.BIN) | cut -d " " -f1)
FIRMWARE.SLOT2.SHA=$(shell shasum $(FIRMWARE.SLOT2.DEBUG.BIN) | cut -d " " -f1)
FIRMWARE.SLOT1.UPLOAD="\$UPLOAD,START,$(FIRMWARE.SLOT1.DEBUG.BIN.SIZE.HEX),$(FIRMWARE.SLOT1.SHA)\n"
FIRMWARE.SLOT2.UPLOAD="\$UPLOAD,START,$(FIRMWARE.SLOT2.DEBUG.BIN.SIZE.HEX),$(FIRMWARE.SLOT2.SHA)\n"
FIRMWARE.REBOOT="\$REBOOT\n"
FREERTOS.ARCHIVE=freertos-trunk-r2536.tar.gz
FREERTOS.URL=https://s3.amazonaws.com/buildroot-sources/$(FREERTOS.ARCHIVE)
FREERTOS.DIR=$(DOWNLOADS.DIR)/freertos-trunk-r2536/FreeRTOS/Source
FREERTOS.PLUS.DIR=$(DOWNLOADS.DIR)/freertos-trunk-r2536/FreeRTOS-Plus/Source
FATFS.VERSION=R0.13b
FATFS.ARCHIVE=$(FATFS.VERSION).tar.gz
FATFS.URL=https://github.com/abbrev/fatfs/archive/$(FATFS.ARCHIVE)
FATFS.DIR=$(DOWNLOADS.DIR)/fatfs-$(FATFS.VERSION)
CONFIG.DIR=$(FIRMWARE.DIR)/src/config
GENROMFS.URL=http://downloads.sourceforge.net/romfs/genromfs-0.5.2.tar.gz
GENROMFS.DIR=$(DOWNLOADS.DIR)/genromfs-0.5.2
GENROMFS.ARCHIVE=genromfs-0.5.2.tar.gz
CMAKE.TOOLCHAIN.FILE=$(FIRMWARE.DIR)/armgcc.cmake
JLINK.ARCHIVE=JLink_Linux_V634h_x86_64.tgz
JLINK.URL=https://s3.amazonaws.com/ckelso-toolchain/$(JLINK.ARCHIVE)
#JLINK.URL=https://www.segger.com/downloads/jlink/JLink_Linux_V634h_x86_64.tgz
JLINK.DIR=$(DOWNLOADS.DIR)/JLink_Linux_V634h_x86_64
JLINK.FLASH.BIN=$(JLINK.DIR)/JLinkExe
JLINK.GDB.BIN=$(JLINK.DIR)/JLinkGDBServer
JLINK.SHA.FLASH.SCRIPT.DEBUG=$(SCRIPTS.DIR)/flash.sha.jlink.debug
JLINK.FLASH.SLOT1.SCRIPT.DEBUG=$(SCRIPTS.DIR)/flash.slot1.jlink.debug
JLINK.FLASH.SLOT2.SCRIPT.DEBUG=$(SCRIPTS.DIR)/flash.slot2.jlink.debug
JLINK.FLASH.SLOT1.SCRIPT.RELEASE=$(SCRIPTS.DIR)/flash.slot1.jlink.release
JLINK.FLASH.SLOT2.SCRIPT.RELEASE=$(SCRIPTS.DIR)/flash.slot2.jlink.release
JLINK.FLASH.DOWNLOAD.SCRIPT=$(SCRIPTS.DIR)/flash.download
JLINK.RESET.SCRIPT=$(SCRIPTS.DIR)/reset.jlink
JLINK.ERASE.SCRIPT=$(SCRIPTS.DIR)/erase.jlink
JLINK.DOWNLOAD.SCRIPT=$(SCRIPTS.DIR)/download.jlink
JLINK.UPLOAD.SCRIPT=$(SCRIPTS.DIR)/upload.jlink
IOKIT.ARCHIVE=xnu-4570.1.46.tar.gz
IOKIT.URL=https://github.com/apple/darwin-xnu/archive/$(IOKIT.ARCHIVE)
IOKIT.DIR=$(DOWNLOADS.DIR)/darwin-xnu-xnu-4570.1.46
OSX.SDKROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/
BIN.DIR=$(INSTALLED.HOST.DIR)/bin
JLINK.OSX.ARCHIVE=JLink_MacOSX_V634c.pkg
JLINK.OSX.URL=https://s3.amazonaws.com/ckelso-toolchain/$(JLINK.OSX.ARCHIVE)
JLINK.OSX.DIR=$(DOWNLOADS.DIR)/JLink.pkg/Applications/SEGGER/JLink_V634c
JLINK.OSX.FLASH.BIN=$(JLINK.OSX.DIR)/JLinkExe
JLINK.OSX.GDB.BIN=$(JLINK.OSX.DIR)/JLinkGDBServer
SHA.DIR=$(BASE.DIR)/sha/armgcc
SHA.BUILD=$(BASE.DIR)/build.sha
SHA.RELEASE.BIN=$(SHA.BUILD)/Release/sha.bin
SHA.DEBUG.BIN=$(SHA.BUILD)/Debug/sha.bin
SHA.RELEASE.ELF=$(SHA.BUILD)/Release/sha.elf
SHA.DEBUG.ELF=$(SHA.BUILD)/Debug/sha.elf
SRECORD.ARCHIVE=srecord-1.64.tar.gz
SRECORD.URL=https://sourceforge.net/projects/srecord/files/srecord/1.64/$(SRECORD.ARCHIVE)
SRECORD.DIR=$(DOWNLOADS.DIR)/srecord-1.64
SRECORDCAT.BIN=$(INSTALLED.HOST.DIR)/bin/srec_cat

srecord: .FORCE
	rm -f $(DOWNLOADS.DIR)/$(SRECORD.ARCHIVE)
	mkdir -p $(DOWNLOADS.DIR)
	cd $(DOWNLOADS.DIR) && wget $(SRECORD.URL) && tar xf $(SRECORD.ARCHIVE)
	cd $(SRECORD.DIR) && ./configure --prefix=$(INSTALLED.HOST.DIR) && make -j$(J) install

ctags: .FORCE
	cd $(BASE.DIR) && ctags -R --exclude=.git --exclude=installed.host --exclude=installed.target --exclude=protocol/tests --exclude=protocol/simulator --exclude=downloads --exclude=documents  --exclude=reference_firmware --exclude=build.* --exclude=$(TOOLCHAIN.NAME) .

jlink.fetch: .FORCE
ifeq ($(OS), Linux)
	mkdir -p $(DOWNLOADS.DIR) && cd $(DOWNLOADS.DIR) && rm -rf $(JLINK.ARCHIVE) && wget -q $(JLINK.URL) && tar xf $(JLINK.ARCHIVE)
endif

ifeq ($(OS), Darwin)
	mkdir -p $(DOWNLOADS.DIR) && cd $(DOWNLOADS.DIR) && rm -rf $(JLINK.OSX.ARCHIVE) && wget -q $(JLINK.OSX.URL) && xar -xf $(JLINK.OSX.ARCHIVE) && cd JLink.pkg && cat Payload | gunzip -dc |cpio -i
endif

flash.download: .FORCE
ifeq ($(OS), Linux)
	$(JLINK.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.FLASH.DOWNLOAD.SCRIPT)
endif

ifeq ($(OS), Darwin)
	$(JLINK.OSX.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.FLASH.DOWNLOAD.SCRIPT)
endif

update.slot1.debug: .FORCE
	bash $(FIRMWARE.SLOT1.UPDATE)

update.slot2.debug: .FORCE
	bash $(FIRMWARE.SLOT2.UPDATE)

flash.slot1.debug: .FORCE
ifeq ($(OS), Linux)
	$(JLINK.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.FLASH.SLOT1.SCRIPT.DEBUG)
endif

ifeq ($(OS), Darwin)
	$(JLINK.OSX.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.FLASH.SLOT1.SCRIPT.DEBUG)
endif

flash.slot1.release: .FORCE
ifeq ($(OS), Linux)
	$(JLINK.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.FLASH.SLOT1.SCRIPT.RELEASE)
endif

ifeq ($(OS), Darwin)
	$(JLINK.OSX.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.FLASH.SLOT1.SCRIPT.RELEASE)
endif

flash.slot2.debug: .FORCE
ifeq ($(OS), Linux)
	$(JLINK.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.FLASH.SLOT2.SCRIPT.DEBUG)
endif

ifeq ($(OS), Darwin)
	$(JLINK.OSX.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.FLASH.SLOT2.SCRIPT.DEBUG)
endif

flash.slot2.release: .FORCE
ifeq ($(OS), Linux)
	$(JLINK.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.FLASH.SLOT2.SCRIPT.RELEASE)
endif

ifeq ($(OS), Darwin)
	$(JLINK.OSX.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.FLASH.SLOT2.SCRIPT.RELEASE)
endif


reset: .FORCE
ifeq ($(OS), Linux)
	$(JLINK.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.RESET.SCRIPT)
endif

ifeq ($(OS), Darwin)
	$(JLINK.OSX.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.RESET.SCRIPT)
endif

erase: .FORCE
ifeq ($(OS), Linux)
	$(JLINK.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.ERASE.SCRIPT)
endif

ifeq ($(OS), Darwin)
	$(JLINK.OSX.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.ERASE.SCRIPT)
endif

download: .FORCE
ifeq ($(OS), Linux)
	$(JLINK.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.DOWNLOAD.SCRIPT)
endif

ifeq ($(OS), Darwin)
	$(JLINK.OSX.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.DOWNLOAD.SCRIPT)
endif

upload: .FORCE
ifeq ($(OS), Linux)
	$(JLINK.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.UPLOAD.SCRIPT)
endif

ifeq ($(OS), Darwin)
	$(JLINK.OSX.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.UPLOAD.SCRIPT)
endif




gdb.server: .FORCE
ifeq ($(OS), Linux)
	$(JLINK.GDB.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1
endif

ifeq ($(OS), Darwin)
	$(JLINK.OSX.GDB.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1
endif

gdb.slot1: .FORCE
	bash $(SCRIPTS.DIR)/gdb-slot1.sh

gdb.slot2: .FORCE
	bash $(SCRIPTS.DIR)/gdb-slot2.sh


#firmware.release: firmware.clean
#	mkdir $(FIRMWARE.BUILD)
#	cd $(FIRMWARE.BUILD) &&  export PATH=$(PATH):$(INSTALLED.HOST.DIR)/bin  export ARMGCC_DIR=$(TOOLCHAIN.DIR) && $(CMAKE.BIN) -DCMSIS.DIR=$(CMSIS.DIR) -DFREERTOS.DIR=$(FREERTOS.DIR) -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=$(CMAKE.TOOLCHAIN.FILE) $(FIRMWARE.DIR) && make -j4 && $(TOOLCHAIN.DIR)/bin/arm-none-eabi-objcopy -O binary $(FIRMWARE.RELEASE.ELF) $(FIRMWARE.RELEASE.BIN)
#	$(STRIP.BIN)  $(FIRMWARE.RELEASE.ELF)

flash.sha.debug: .FORCE
ifeq ($(OS), Linux)
	$(JLINK.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.SHA.FLASH.SCRIPT.DEBUG)
endif

ifeq ($(OS), Darwin)
	$(JLINK.OSX.FLASH.BIN) -device LPC54628J512 -if SWD -speed 4000 -autoconnect 1 -CommanderScript $(JLINK.FLASH.SCRIPT.DEBUG)
endif

sha.convert: .FORCE
	cd $(SHA.BUILD) && $(TOOLCHAIN.DIR)/bin/arm-none-eabi-objcopy -O binary $(SHA.DEBUG.ELF) $(SHA.DEBUG.BIN)


sha.debug: sha.clean
	mkdir -p $(SHA.BUILD)
	cd $(SHA.BUILD) &&  export PATH=$(PATH):$(INSTALLED.HOST.DIR)/bin  export ARMGCC_DIR=$(TOOLCHAIN.DIR) && $(CMAKE.BIN) -DCMSIS.DIR=$(CMSIS.DIR) -DFREERTOS.DIR=$(FREERTOS.DIR)  -DINCLUDE_uxTaskGetStackHighWaterMark=1 -DCMAKE_BUILD_TYPE=Debug  -DCMAKE_INSTALL_PREFIX=$(INSTALLED.TARGET.DIR) -DFATFS_SOURCE_DIR=$(FATFS.DIR)/source -DCMAKE_TOOLCHAIN_FILE=$(SHA.DIR)/../armgcc.cmake $(SHA.DIR) && make -j4 && $(TOOLCHAIN.DIR)/bin/arm-none-eabi-objcopy -O binary $(SHA.DEBUG.ELF) $(SHA.DEBUG.BIN)

sha.clean: .FORCE
	rm -rf $(SHA.BUILD)

flex.clean: .FORCE
	rm -rf $(DOWNLOADS.DIR)/$(FLEX.ARCHIVE)
	rm -rf $(FLEX.DIR)

flex: flex.clean
ifeq ($(OS), Linux)
	mkdir -p $(DOWNLOADS.DIR) && cd $(DOWNLOADS.DIR) && wget -q $(FLEX.URL) && tar xf $(DOWNLOADS.DIR)/$(FLEX.ARCHIVE)
	cd $(FLEX.DIR) && ./autogen.sh && ./configure --prefix=$(INSTALLED.HOST.DIR) &&  PATH=$(PATH):$(INSTALLED.HOST.DIR)/bin make -j$(J) && make install
endif
ifeq ($(OS), Darwin)
	mkdir -p $(DOWNLOADS.DIR) && cd $(DOWNLOADS.DIR) && wget -q $(FLEX.URL) && tar xf $(DOWNLOADS.DIR)/$(FLEX.ARCHIVE)
	cd $(FLEX.DIR) && ./autogen.sh && ./configure --prefix=$(INSTALLED.HOST.DIR) &&  make -j$(J) && make install
endif

bison: .FORCE
	rm -rf $(DOWNLOADS.DIR)/$(BISON.ARCHIVE)
	rm -rf $(BISON.DIR)
	mkdir -p $(DOWNLOADS.DIR) && cd $(DOWNLOADS.DIR) && wget -q $(BISON.URL) && tar xf $(DOWNLOADS.DIR)/$(BISON.ARCHIVE)
	cd $(BISON.DIR) && ./configure --prefix=$(INSTALLED.HOST.DIR) && make -j$(J) && make install

asio: .FORCE
	rm -rf $(DOWNLOADS.DIR)/$(ASIO.ARCHIVE)
	rm -rf $(ASIO.DIR)
	mkdir -p $(DOWNLOADS.DIR) && cd $(DOWNLOADS.DIR) && wget -q $(ASIO.URL) && tar xf $(DOWNLOADS.DIR)/$(ASIO.ARCHIVE)
	rm -rf $(INSTALLED.HOST.DIR)/include/asio
	mkdir -p $(INSTALLED.HOST.DIR)/include/asio && cd $(INSTALLED.HOST.DIR)/include/asio && cp -rp $(ASIO.DIR)/include/* .

lpcscript: .FORCE
	/usr/local/lpcscrypt/bin/lpcscrypt program $(BASE.DIR)/firmware.elf 0 -e noisy


submodule: .FORCE
	git submodule init
	git submodule update


bootstrap: toolchain cmake.fetch.prebuilt bison asio flex gtest docopt freertos fatfs genromfs cmsis jlink.fetch protocol.target.build protocol.host.build

toolchain: .FORCE
ifeq ($(OS), Linux)
	mkdir -p $(DOWNLOADS.DIR) && cd $(DOWNLOADS.DIR) && wget -q $(TOOLCHAIN.URL.LINUX)
	tar xf $(TOOLCHAIN.ARCHIVE.LINUX)
endif

ifeq ($(OS), Darwin)
	mkdir -p $(DOWNLOADS.DIR) && cd $(DOWNLOADS.DIR) && wget -q $(TOOLCHAIN.URL.OSX)
	tar xf $(TOOLCHAIN.ARCHIVE.OSX)
endif
toolchain.clean: .FORCE
	rm -rf $(TOOLCHAIN.ARCHIVE.LINUX)
	rm -rf $(TOOLCHAIN.ARCHIVE.OSX)
	rm -rf $(TOOLCHAIN.DIR)

firmware.slot1.clean: .FORCE
	rm -rf $(FIRMWARE.SLOT1.BUILD)

firmware.slot2.clean: .FORCE
	rm -rf $(FIRMWARE.SLOT2.BUILD)

freertos.clean: .FORCE
	rm -rf $(DOWNLOADS.DIR)/$(FREERTOS.ARCHIVE)
	rm -rf $(FREERTOS.DIR)

freertos.fetch: .FORCE
	cd $(DOWNLOADS.DIR) && wget -q $(FREERTOS.URL) && tar xf $(FREERTOS.ARCHIVE)

freertos: freertos.clean freertos.fetch

iokit.clean: .FORCE
	rm -rf $(DOWNLOADS.DIR)/$(IOKIT.ARCHIVE)
	rm -rf $(IOKIT.DIR)

iokit.fetch: .FORCE
	cd $(DOWNLOADS.DIR) && wget -q $(IOKIT.URL) && tar xf $(IOKIT.ARCHIVE)

iokit: iokit.clean iokit.fetch
	cd $(IOKIT.DIR) && make SDKROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/
	cp -r $(IOKIT.DIR)/iokit/IOKit/*.h $(INSTALLED.HOST.DIR)/include
	mkdir -p $(INSTALLED.HOST.DIR)/include/kern
	cp -r $(IOKIT.DIR)/osfmk/kern/*.h $(INSTALLED.HOST.DIR)/include/kern

fatfs: fatfs.clean fatfs.fetch

fatfs.clean: .FORCE
	rm -rf $(DOWNLOADS.DIR)/$(FATFS.ARCHIVE)
	rm -rf $(FATFS.DIR)

fatfs.fetch: .FORCE
	cd $(DOWNLOADS.DIR) && wget -q $(FATFS.URL) && tar xf $(FATFS.ARCHIVE)

genromfs.clean: .FORCE
	rm -rf $(DOWNLOADS.DIR)/$(GENROMFS.ARCHIVE)
	rm -rf $(GENROMFS.DIR)

genromfs.fetch: .FORCE
	cd $(DOWNLOADS.DIR) && wget -q $(GENROMFS.URL) && tar xf $(GENROMFS.ARCHIVE)

genromfs: genromfs.clean genromfs.fetch
	cd $(GENROMFS.DIR) &&  make -j4
	mv $(GENROMFS.DIR)/genromfs $(INSTALLED.HOST.DIR)/bin

gtest.fetch: .FORCE
	cd $(DOWNLOADS.DIR) && wget -q $(GTEST.URL) && tar xf $(GTEST.ARCHIVE)

gtest: gtest.fetch
	rm -rf $(GTEST.BUILD)
	mkdir -p $(GTEST.BUILD) && cd $(GTEST.BUILD) && $(CMAKE.BIN) -DCMAKE_INSTALL_PREFIX=$(INSTALLED.HOST.DIR) $(GTEST.DIR) && make -j$(J) install

gtest.clean: .FORCE
	rm -rf $(GTEST.BUILD)
	rm -rf $(DOWNLOADS.DIR)/$(GTEST.ARCHIVE)

docopt.fetch: .FORCE
	cd $(DOWNLOADS.DIR) && wget -q $(DOCOPT.URL) && tar xf $(DOCOPT.ARCHIVE)

docopt: docopt.fetch
	rm -rf $(DOCOPT.BUILD)
	mkdir -p $(DOCOPT.BUILD) && cd $(DOCOPT.BUILD) && $(CMAKE.BIN) -DCMAKE_INSTALL_PREFIX=$(INSTALLED.HOST.DIR) $(DOCOPT.DIR) && make -j$(J) install

docopt.clean: .FORCE
	rm -rf $(DOWNLOADS.DIR)/$(DOCOPT.ARCHIVE)
	rm -rf $(DOCOPT.DIR)

cmake.fetch: .FORCE
	cd $(DOWNLOADS.DIR) && wget -q $(CMAKE.URL) && tar xf $(CMAKE.ARCHIVE)

cmake: cmake.fetch
	cd $(CMAKE.DIR) && ./configure --prefix=$(INSTALLED.HOST.DIR) --no-system-zlib && make -j$(J) && make install

cmake.clean: .FORCE
	rm -rf $(CMAKE.DIR)

cmake.fetch.prebuilt: .FORCE
ifeq ($(OS), Darwin)
	mkdir -p $(DOWNLOADS.DIR)
	mkdir -p $(INSTALLED.HOST.DIR)
	cd $(DOWNLOADS.DIR) && wget $(CMAKE.PREBUILT.OSX.URL)
	cd $(INSTALLED.HOST.DIR) && tar xf $(DOWNLOADS.DIR)/$(CMAKE.PREBUILT.OSX.ARCHIVE)
endif

ifeq ($(OS), Linux)
	mkdir -p $(DOWNLOADS.DIR)
	mkdir -p $(INSTALLED.HOST.DIR)
	cd $(DOWNLOADS.DIR) && wget $(CMAKE.PREBUILT.LINUX.URL)
	cd $(INSTALLED.HOST.DIR) && tar xf $(DOWNLOADS.DIR)/$(CMAKE.PREBUILT.LINUX.ARCHIVE)
endif

cmsis.fetch: .FORCE
	cd $(DOWNLOADS.DIR) && wget -q $(CMSIS.URL) && tar xf $(CMSIS.ARCHIVE)

cmsis: cmsis.fetch

cmsis.clean: .FORCE
	rm -rf $(CMSIS.DIR)

package.clean: .FORCE
	rm -rf $(PACKAGE.DIR)


package.debug: package.clean
	mkdir -p $(PACKAGE.DIR)
	cp $(FIRMWARE.SLOT1.DEBUG.BIN) $(PACKAGE.DIR)/firmware-slot1-debug-master-$(HASH).bin
	cp $(FIRMWARE.SLOT1.DEBUG.ELF) $(PACKAGE.DIR)/firmware-slot1-debug-master-$(HASH).elf
	cp $(FIRMWARE.SLOT2.DEBUG.BIN) $(PACKAGE.DIR)/firmware-slot2-debug-master-$(HASH).bin
	cp $(FIRMWARE.SLOT2.DEBUG.ELF) $(PACKAGE.DIR)/firmware-slot2-debug-master-$(HASH).elf
ifeq ($(OS), Linux)
	cd $(PACKAGE.DIR) && tar czvf firmware-debug-master-$(HASH).tar.gz * && md5sum firmware-debug-master-$(HASH).tar.gz > firmware-debug-master-$(HASH).tar.gz.md5
endif
ifeq ($(OS), Darwin)
	cd $(PACKAGE.DIR) && tar czvf firmware-debug-master-$(HASH).tar.gz * && md5 firmware-debug-master-$(HASH).tar.gz > firmware-debug-master-$(HASH).tar.gz.md5
endif
	rm -f $(PACKAGE.DIR)/*.bin
	rm -f $(PACKAGE.DIR)/*.elf

clean: toolchain.clean firmware.slot1.clean firmware.slot2.clean cmake.clean cmsis.clean protocol.clean gtest.clean docopt.clean flex.clean  package.clean
	rm -rf $(INSTALLED.HOST.DIR)
	rm -rf $(INSTALLED.TARGET.DIR)
	rm -rf $(DOWNLOADS.DIR)

build.number.increment.textfile: .FORCE
	if ! test -f $(BUILD.NUMBER.FILE); then echo 0 > $(BUILD.NUMBER.FILE); fi
	echo $$(($$(cat $(BUILD.NUMBER.FILE)) + 1)) > $(BUILD.NUMBER.FILE)
	

build.number.increment: build.number.increment.textfile
	cp $(FIRMWARE.VERSION.TEMPLATE) $(FIRMWARE.VERSION.HEADER)
	$(SED) -i 's/SOFTWAREVERSIONTOKEN/$(BUILD.NUMBER)/g' $(FIRMWARE.VERSION.HEADER)

build.all.firmware: protocol.target.build build.number.increment firmware18.slot1.debug firmware18.slot2.debug

ci: submodule bootstrap #firmware.slot1.debug firmware.slot2.debug package.debug

s: sha.debug flash.sha.debug

.FORCE:


