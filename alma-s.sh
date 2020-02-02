#!/bin/bash

#ASK FOR INDIVIDUAL USERNAME AND HOSTNAME AND PASSES
clear && read -p "Enter hostname: " hostname
read -p "Enter username: " username && clear

#ENTER HOSTNAME
echo $hostname > /etc/hostname

#SETTING UP ROOT PASSWORD
echo -e "Enter root password.\n"
passwd root && clear

#ADDING USER "USERNAME" WITH GROUP "WHEEL"
useradd -m -g users -G wheel -s /bin/bash $username

#SETTING UP USER PASSWORD
echo -e "Enter $username password.\n"
passwd $username && clear

#ADDING WHEEL GROUP TO SUDOERS AND USER NOPASSWD FOR THIRD STEP
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
cp /etc/sudoers /etc/sudoers.tmp
echo "$username ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

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
ln -svf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime
hwclock --systohc --utc

#DRIVERS FOR VIDEOCARD
clear && read -p "[n]vidia or [a]md or [i]ntel video card: " video
case $video in
n)
pacman -S nvidia --noconfirm
echo
;;
a)
pacman -S mesa xf86-video-ati xf86-video-amdgpu vulkan-radeon libva-mesa-driver mesa-vdpau --noconfirm
echo
;;
i)
pacman -S mesa  vulkan-intel xf86-video-intel --noconfirm
echo
esac

#SETTING UP WI-FI SETTINGS FOR NOTEBOOKS
clear && read -p "Need wi-fi (y/n): " wifi
pacman -S dhcpcd --noconfirm
if [[ $wifi == y ]]; then
pacman -S dialog netctl wpa_supplicant --noconfirm
systemctl disable dhcpcd
systemctl enable netctl
else
systemctl enable dhcpcd
fi

#ENABLING MULTILIBS REPOSITORIES IN PACMAN
clear
read -p "Need x32 libs (y/n): " multilib
if [[ $multilib == y ]]; then
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy
fi

#VIRTUAL MACHINE DRIVERS
clear && read -p "Is that [v]irtualbox, [vm]ware or real computer (ANY): " vm
case $vm in
v)
pacman -S virtualbox-guest-utils xf86-video-vmware
echo 2;
systemctl enable vboxservice
;;
vm)
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
curl https://git.io/Jv3s0 --output alma-t.sh -sL && chmod +x alma-t.sh && sudo -u $username ./alma-t.sh && rm -f ./alma-t.sh

#DELETE USER NOPASSWD
rm -f /etc/sudoers
mv /etc/sudoers.tmp /etc/sudoers

#EXIT FROM ARCH-CHROOT
exit 0
