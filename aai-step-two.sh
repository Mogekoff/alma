#!/bin/bash

#ASK FOR INDIVIDUAL USERNAME AND HOSTNAME AND PASSES
read -p "Enter hostname: " hostname
read -p "Enter username: " username
read -p "Enter root password: " rpass
read -p "Enter username password: " upass
export upass

#GENERATING LOCALES
echo en_US.UTF-8 UTF-8 > /etc/locale.gen
echo ru_RU.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen

#SETTING UP LOCALES
echo LANG=ru_RU.UTF-8 > /etc/locale.conf
export LANG=ru_RU.UTF-8
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

#SETTING UP TIME
rm -rf /etc/localtime
hwclock --systohc --utc

#ENTER HOSTNAME
echo $hostname > /etc/hostname

#SETTING UP ROOT PASSWORD
echo -e "$rpass\n$rpass" | passwd root

#ADDING USER "USERNAME" WITH GROUP "WHEEL"
useradd -m -g users -G wheel -s /bin/bash $username

#SETTING UP USER PASSWORD
echo -e "$upass\n$upass" | passwd $username

#ADDING WHEEL GROUP TO SUDOERS
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

#DRIVERS FOR VIDEOCARD
read -p "nvidia(0) or other(1) video card: " video
case $video in
0)
pacman -S nvidia --noconfirm
echo
;;
1)
pacman -S mesa --noconfirm
echo
esac

#SETTING UP WI-FI SETTINGS FOR NOTEBOOKS
read -p "Need wi-fi (y/n): " wifi
pacman -S dhcpcd --noconfirm
if [[ $wifi == y ]]; then
pacman -S dialog netctl wpa_supplicant --noconfirm
systemctl disable dhcpcd
systemctl enable netctl
else
systemctl enable dhcpcd
fi

#ENABLING MULTILIBS REPOSITORIES IN PACMAN
read -p "Need x32 libs (y/n): " multilib
if [[ $multilib == y ]]; then
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy
fi

#VIRTUAL MACHINE DRIVERS
read -p "Is that virtualbox(0), vmware(1) or real pc(any): " vm
case $vm in
0)
pacman -S virtualbox-guest-utils xf86-video-vmware
echo 2;
systemctl enable vboxservice
;;
1)
pacman -S  xf86-input-vmmouse xf86-video-vmware open-vm-tools --noconfirm
systemctl enable vmtoolsd
systemctl enable vmware-vmblock-fuse
echo
esac

#XORG, FONT AND AUDIO PACKAGES
pacman -S xorg-server xorg-xinit ttf-freefont ttf-dejavu alsa-utils --noconfirm

#AUDIO ON
amixer set Master 100% unmute
amixer set PCM 100% unmute

#GRUB INSTALL
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

#CREATE LOAD IMAGE
mkinitcpio -P

#GO TO *STEP THREE*
curl https://git.io/JvYLX --output aai-step-three.sh -sL && chmod +x aai-step-three.sh && sudo -u $username ./aai-step-three.sh

#EXIT FROM ARCH-CHROOT
exit 0
