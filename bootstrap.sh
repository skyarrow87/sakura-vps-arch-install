#!/bin/zsh

read "HN?Hostname: "
read "IP4?IPv4 Address: "
read "IP6?IPv6 Address: "
read "GW4?Gateway IPv4: "
read "GW6?Gateway IPv6: "

# システム情報収集
timedatectl set-ntp true
loadkeys jp106
timedatectl status
ip a
lsblk

# パーティションの作成
echo "/dev/vda を初期化してもよろしいですか？(y/N): "; read -q && echo "パーティションを初期化します" || exit
wipefs -a /dev/vda
echo "EFIシステムパーティションを作成します"
sgdisk --new 1::+200MB /dev/vda
sgdisk --typecode 1:ef00 /dev/vda
sgdisk --change-name 1:"EFI system partition" /dev/vda
echo "swapパーティションを作成します"
sgdisk --new 2::+4GB /dev/vda
sgdisk --typecode 2:8200 /dev/vda
echo "rootパーティションを作成します"
sgdisk --new 3:: /dev/vda
sgdisk --typecode 3:8304 /dev/vda
sgdisk --change-name 3:"ArchLinux" /dev/vda
sgdisk --print /dev/vda

# パーティションのフォーマット
echo "EFIシステムパーティションを初期化します"
mkfs.fat -F 32 /dev/vda1
echo "swapパーティションを初期化します"
mkswap /dev/vda2
echo "rootパーティションを初期化します"
mkfs.ext4 /dev/vda3

# ファイルシステムのマウント
echo "ファイルシステムをマウントします"
mount /dev/vda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /vnt/boot
echo "スワップを有効にします"
swapon /dev/sda2
lsblk

# パッケージのインストール
pacman-key --init && pacman-key --populate archlinux

echo Y | pacman -Sy

pacstrap -K /mnt base base-devel linux-hardened linux-hardened-headers linux-firmware zsh tree vim vi man-db man-pages texinfo arch-install-scripts linux-api-headers w3m lynx wget curl gdisk parted sudo python git go openssh kexec-tools grub

# ネットワーク設定
echo "ホストネームを $HN に設定します"
echo $HN > /mnt/etc/hostname

# fastabの生成
echo "fastabを生成します"
genfstab -U /mnt >> /mnt/etc/fstab

# chroot
wget -P /mnt/tmp/ https://raw.githubusercontent.com/soramikan/sakura-vps-arch-install/main/chroot.sh
chmod +x /mnt/tmp/chroot.sh
arch-chroot /mnt /tmp/chroot.sh