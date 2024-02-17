#!/bin/bash
sudo su
wget https://mirrors.cat.net/archlinux/iso/latest/archlinux-bootstrap-x86_64.tar.gz
tar -xzf archlinux-bootstrap-x86_64.tar.gz
mount --bind /tmp/root.x86_64 /tmp/root.x86_64
/tmp/root.x86_64/bin/arch-chroot /tmp/root.x86_64/

