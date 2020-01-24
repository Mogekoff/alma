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
 echo;
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

arch-chroot /mnt sh -c "$(curl -fsSL https://git.io/JvtHM)"
