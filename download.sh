#!/bin/sh
curl -L https://github.com/ethanmw/arch-setup/archive/master.zip --output scripts.zip
bsdtar zxf scripts.zip
cd arch_installer-master
chmod +x *.sh
./install.sh
