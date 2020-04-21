#!/bin/bash
# THIS SCRIPT ASSUMES YOU HAVE AN INTERNET CONNECTION ALREADY AVAILABLE

OPT="--color always -q --noprogressbar --noconfirm --logfile pacman-$0.log"
mirrorfile="mirrorlist.temp"

function cleanup    #CLEANUP FILES
{
    echo "- Cleanup"
    \rm *.temp &>/dev/null
}

sed -e 's/#Color/Color/' /etc/pacman.conf > pacman.temp  #ENABLE COLOR IN PACMAN
cp pacman.temp /etc/pacman.conf &> /dev/null

cleanup
umount -R /mnt &> /dev/null

echo "--[MIRROR CONFIGURATION]--"

echo "- Downloading new mirrors"
curl -s "https://www.archlinux.org/mirrorlist/?country=all&protocol=https&use_mirror_status=on" -o $mirrorfile

echo "- Sorting mirrors"
cat $mirrorfile | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 > $mirrorfile

echo "- Saving mirrorlist"
cp $mirrorfile /etc/pacman.d/mirrorlist

echo "- Updating package lists"
pacman -Syy $OPT 1>/dev/null

./select-disk.sh
cleanup
