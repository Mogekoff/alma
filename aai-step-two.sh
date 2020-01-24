#!/bin/bash

echo en_US.UTF-8 UTF-8 > /etc/locale.gen
echo ru_RU.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=ru_RU.UTF-8 > /etc/locale.conf
export LANG=ru_RU.UTF-8
rm -rf /etc/localtime
hwclock --systohc --utc
echo usernamecomputer > /etc/hostname
passwd root
useradd -m -g users -G wheel -s /bin/bash username
passwd username
echo "username ALL=(ALL) ALL" >> /etc/sudoers

pacman -S dhcpcd xorg-server xf86-video-intel xorg-xinit i3-wm ttf-freefont ttf-dejavu rxvt-unicode zsh alsa-utils gdb git chromium qtcreator dmenu openssh htop nnn neofetch libreoffice-fresh --noconfirm

echo "exec --no-startup-id setxkbmap -model pc105 -layout us,ru -variant , -option grp:alt_shift_toggle" >> ~/.config/i3/conf

amixer set Master 100% unmute
amixer set PCM 100% unmute


mkdir build
cd build
curl -Lo install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
chmod +x ./install.sh
./install.sh

systemctl enable dhcpcd

grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
reboot
