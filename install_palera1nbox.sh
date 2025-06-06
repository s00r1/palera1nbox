#!/bin/bash
# Automated setup script for palera1nbox on NanoPi Neo
# This script installs common dependencies and libraries.
# It does not replace the official tutorial and should be run as root.

set -e

# Update system
sudo apt-get update
sudo apt-get upgrade -y

# Basic dependencies
sudo apt-get install -y i2c-tools git vim armbian-config python3-dev python3-pil \
  python3-smbus python3-pip python3-serial

cat <<'INFO'
---------------------------------------------------------------------
Manual step required:
Run 'sudo armbian-config' and enable analog-codec and i2c0.
Reboot the device and rerun this script afterwards if necessary.
---------------------------------------------------------------------
INFO

# Clone and install NanoHatOLED
if [ ! -d NanoHatOLED ]; then
  git clone https://github.com/friendlyarm/NanoHatOLED.git
fi
cd NanoHatOLED
sudo -H ./install.sh
cd ..

# Python dependencies
sudo pip3 install --upgrade setuptools sh wheel psutil

# palera1n dependencies
sudo apt install -y libc6 libncurses5 libpango-1.0-0 libpangocairo-1.0-0 \
  libpangoft2-1.0-0 libatk1.0-0 libgdk-pixbuf2.0-0 libglib2.0-0 libfontconfig1 \
  libfreetype6 libgtk-3-0 libusb-1.0-0 libplist3 usbmuxd ideviceinstaller \
  python3-imobiledevice libimobiledevice-utils python3-plist ifuse \
  libusbmuxd-tools mplayer usbmuxd libjpeg-dev

sudo apt-get install -y pkg-config libplist-dev libreadline-dev libusb-1.0-0-dev \
  build-essential checkinstall git autoconf automake libtool-bin

# Build and install libplist
if [ ! -d libplist ]; then
  git clone https://github.com/libimobiledevice/libplist.git
fi
cd libplist
./autogen.sh
./configure
make
sudo make install
cd ..

# Build and install libimobiledevice-glue
if [ ! -d libimobiledevice-glue ]; then
  git clone https://github.com/libimobiledevice/libimobiledevice-glue.git
fi
cd libimobiledevice-glue
./autogen.sh
./configure
make
sudo make install
cd ..

# Build and install libirecovery
if [ ! -d libirecovery ]; then
  git clone https://github.com/libimobiledevice/libirecovery.git
fi
cd libirecovery
./autogen.sh
./configure
make
sudo make install
cd ..

sudo apt install -y irecovery

# Additional Python libs
pip3 install luma.oled
pip3 uninstall -y pillow

cat <<'INFO'
---------------------------------------------------------------------
Download the release archive and copy the Python files to
/root/NanoHatOLED/BakeBit/Software/Python/
After copying, run the following commands:
  chmod +x /root/NanoHatOLED/BakeBit/Software/Python/palera1n
  chmod +x /root/NanoHatOLED/BakeBit/Software/Python/checkra1n
  chmod +x /usr/bin/irecovery
Then reboot the device.
---------------------------------------------------------------------
INFO

