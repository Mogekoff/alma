#!/bin/bash
(
 echo o;
 
 echo n;
 echo;
 echo;
 echo;
 echo +300M;
 echo y;

 echo n;
 echo;
 echo;
 echo;
 echo +2G;
 echo y;
 echo t;
 echo 82;
 
  
 echo n;
 echo;
 echo;
 echo;
 echo;
 echo y;
  
 echo w;

) | fdisk /dev/sda

mkfs.ext4 /dev/sda1                             
mkswap /dev/sda2                               
swapon /dev/sda2                                
mkfs.ext4 /dev/sda3
mount /dev/sda3 /mnt                            
mkdir /mnt/boot /mnt/var /mnt/home
mount /dev/sda1 /mnt/boot
pacstrap /mnt base base-devel linux linux-firmware
pacstrap /mnt grub-bios
genfstab -p /mnt >> /mnt/etc/fstab 
arch-chroot /mnt /bin/bash

echo en_US_UTF-8 UTF-8 > /etc/locale.gen
echo ru_RU_UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=ru_RU.UTF-8 > /etc/locale.conf
export LANG=ru_RU.UTF-8
rm -rf /etc/localtime
hwclock --systohc --utc
echo usernamecomputer > /etc/hostname
passwd root
useradd -m -g users -G wheel -s /bin/bash username
passwd username
echo username ALL=(ALL) ALL >> /etc/sudoers

pacman -S dhcpcd xorg xorg-xinit i3-wm ttf-freefont ttf-dejavu rxvt-unicode zsh alsa-tuils gdb git chromium qtcreator dmenu openssh htop nnn neofetch --noconfirm

echo "exec --no-startup-id setxkbmap -model pc105 -layout us,ru -variant , -option grp:alt_shift_toggle" >> ~/.config/i3/conf

amixer set Master 100% unmute
amixer set PCM 100% unmute
chsh -S /bin/zsh

mkdir build
cd build
git clone https://aur.archlinux.org/ly-git.git
cd ly-git
makepkg -sri
cd ..
curl -Lo install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
./install.sh

systemctl enable dhcpcd
systemctl enable ly
systemctl disable getty@tty2

grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
exit
exit
umount /mnt/boot
umount /mnt
reboot
