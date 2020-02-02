#!/bin/bash

#WELCOME TEXT
clear && curl -fsSL https://pastebin.com/raw/GDiucm3B && sleep 5 && clear

#BOOT PART
read -p "Use [g]pt or [M]br: " mbrgpt && clear

if [[ $mbrgpt == g ]]; then
(
 echo g;
 echo n;
 echo;
 echo;
 echo +500M;
 echo y;
 echo t;
 echo 1;
 echo w;
) | fdisk /dev/sda
mkfs.fat -F32 /dev/sda1
else
(
 echo o;
 echo n;
 echo;
 echo;
 echo;
 echo +500M;
 echo y;
 echo w;
) | fdisk /dev/sda
mkfs.ext4 /dev/sda1 
fi

#SWAP PART
clear && read -p "GiB for swap partition (type '0' if not needed): " swap
if [[ $swap > 0 ]]; then
 (
 echo n;
 echo;
 echo;
 if [[ $mbrgpt != g ]]; then echo; fi
 echo +${swap}G;
 echo y;
 echo t;
 echo;
 if [[ $mbrgpt != g ]]; then echo 82; else echo 19; fi
 echo w;
 ) | fdisk /dev/sda
 mkswap /dev/sda2                               
 swapon /dev/sda2
fi

#ROOT PART
(  
 echo n;
 echo;
 echo;
 echo;
 echo;
 echo y;
 echo w;
) | fdisk /dev/sda

#DISPLAY PARTITIONS
clear && fdisk -l && sleep 10 

#FORMAT AND MOUNT
if [[ $swap > 0 ]]; then                                         
mkfs.ext4 /dev/sda3
mount /dev/sda3 /mnt
else
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
fi
mkdir /mnt/boot /mnt/var /mnt/home
if [[ $mbrgpt == g ]]; then
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
else
mount /dev/sda1 /mnt/boot
fi

#BASE INSTALL
pacstrap /mnt base base-devel linux linux-firmware grub-bios
if [[ $mbrgpt == g ]]; then pacstrap /mnt efibootmgr; fi

#GENFSTAB
genfstab -p /mnt >> /mnt/etc/fstab 

#LOG-IN TO ARCH-CHROOT AND GO TO *STEP TWO*
arch-chroot /mnt sh -c "$(curl -fsSL https://git.io/Jv3sR)"

#UNMOUNT DICKS
if [[ $mbrgpt == g ]]; then
umount /mnt/boot/efi
else
umount /mnt/boot
fi
umount /mnt

#FINISHING
clear && echo "Installation successful! Welcome to Arch Linux World!!!" && sleep 5 && clear
curl -fsSL https://pastebin.com/raw/WAjWbpbk && sleep 0.05 && clear
reboot
