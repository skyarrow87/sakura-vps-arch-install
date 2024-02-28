#!/bin/bash

sudo su
cd /tmp
wget https://mirrors.cat.net/archlinux/iso/latest/archlinux-bootstrap-x86_64.tar.gz
tar -xzf archlinux-bootstrap-x86_64.tar.gz
wget -P /tmp/root.x86_64/root/ https://raw.githubusercontent.com/soramikan/sakura-vps-arch-install/main/chroot.sh
mount --bind /tmp/root.x86_64 /tmp/root.x86_64
/tmp/root.x86_64/bin/arch-chroot /tmp/root.x86_64/ /bin/zsh /tmp/root.x86_64/chroot.sh