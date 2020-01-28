#!/bin/bash
read -p "Enter machine name: " machine
read -p "Enter username: " username

echo en_US.UTF-8 UTF-8 > /etc/locale.gen
echo ru_RU.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen

echo LANG=ru_RU.UTF-8 > /etc/locale.conf
export LANG=ru_RU.UTF-8
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

rm -rf /etc/localtime
hwclock --systohc --utc

echo $machine > /etc/hostname

echo "Enter root password"
passwd root

useradd -m -g users -G wheel -s /bin/bash $username

echo "Enter username password"
passwd $username

echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

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

read -p "Need wi-fi (y/n): " wifi
pacman -S dhcpcd --noconfirm
if [[ $wifi == y ]]
then
pacman -S dialog netctl wpa_supplicant --noconfirm
systemctl disable dhcpcd
systemctl enable netctl
else
systemctl enable dhcpcd
fi

read -p "Need x32 libs (y/n): " multilib
if [[ $multilib == y ]]
then
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy
fi

read -p "Is that virtualbox(0), vmware(1) or real pc(any): " vm
case $vm in
0)
pacman -S virtualbox-guest-utils xf86-video-vmware --noconfirm
systemctl enable vboxservice
;;
1)
pacman -S  xf86-input-vmmouse xf86-video-vmware open-vm-tools --noconfirm
systemctl enable vmtoolsd
systemctl enable vmware-vmblock-fuse
echo
esac

pacman -S xorg-server xorg-xinit ttf-freefont ttf-dejavu alsa-utils --noconfirm

amixer set Master 100% unmute
amixer set PCM 100% unmute

grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
reboot
