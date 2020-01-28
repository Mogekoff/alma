#!/bin/bash

(
 echo o;
 
 echo n;
 echo;
 echo;
 echo;
 echo +32M;
 echo y;
 echo w;
) | fdisk /dev/sda

read -p "GiB for swap partition?" swap
if [[ $swap > 0 ]]; then
 (
 echo n;
 echo;
 echo;
 echo;
 echo +"$swap"G;
 echo y;
 echo t;
 echo;
 echo 82;
 echo w;
 ) | fdisk /dev/sda
 mkswap /dev/sda2                               
 swapon /dev/sda2
fi

)  
 echo n;
 echo;
 echo;
 echo;
 echo;
 echo y;
  
 echo w;

) | fdisk /dev/sda
fdisk -l

mkfs.ext4 /dev/sda1                                          
mkfs.ext4 /dev/sda3
mount /dev/sda3 /mnt                            
mkdir /mnt/boot /mnt/var /mnt/home
mount /dev/sda1 /mnt/boot
pacstrap /mnt base base-devel linux linux-firmware
pacstrap /mnt grub-bios
genfstab -p /mnt >> /mnt/etc/fstab 

arch-chroot /mnt sh -c "$(curl -fsSL https://git.io/JvtHM)"
