#!/bin/bash

#BOOT PART 500MB
clear
(
 echo o;
 echo n;
 echo;
 echo;
 echo;
 echo +500M;
 echo w;
) | fdisk /dev/sda

#SWAP PART
clear
read -p "GiB for swap partition: " swap
if [[ $swap > 0 ]]
then
 (
 echo n;
 echo;
 echo;
 echo;
 echo +"$swap"G;
 echo t;
 echo;
 echo 82;
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
clear
fdisk -l 
sleep 10 

#FORMAT
mkfs.ext4 /dev/sda1                                          
mkfs.ext4 /dev/sda3

#MOUNT DISKS AND MAKE DEFAULT DIRS
mount /dev/sda3 /mnt                            
mkdir /mnt/boot /mnt/var /mnt/home
mount /dev/sda1 /mnt/boot

#BASE INSTALL
pacstrap /mnt base base-devel linux linux-firmware
pacstrap /mnt grub-bios

#GENFSTAB
genfstab -p /mnt >> /mnt/etc/fstab 

#LOG-IN TO ARCH-CHROOT AND GO TO *STEP TWO*
arch-chroot /mnt sh -c "$(curl -fsSL https://git.io/JvtHM)"

#UNMOUNT DICKS
umount /mnt/boot
umount /mnt

#FINISHING
clear
echo "Installation successful! Welcome to Arch Linux World!!!"
sleep 5
reboot
