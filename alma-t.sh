#!/bin/bash

#CHECK THE SCRIPT IS NOT BEING RUN BY ROOT
clear; if [[ "$(id -u)" == "0" ]]; then echo "This script must not be run as root"; exit 1; fi 

#ASKINK FOR EXECUTE THIS SCRIPT
clear; read -p "Do you want to execute step three (not necessary) (Y/n)?: " choice
if [[ $choice == n ]]; then exit 2; else clear; fi

#SETTINGS
soft="i3 rxvt-unicode picom conky dmenu zsh nano nnn feh moc mpv htop openssh neofetch surf lynx wget code qtcreator gdb libreoffice-fresh chromium tor xf86-input-synaptics xawtv"
aurpacks="ly stk11xx-svn"
gitlink="https://github.com/Mogekoff/.files.git"
eservices="ly"
dservices="getty@tty2"

#INSTALLING CONFIGS
sudo pacman -S git --noconfirm && clear
rm -rf ./*
read -p "Install [D]efault configs or [y]ours: " choice
if [[ $choice == y || $choice == Y ]]; then
clear && read -p "Enter your GitHub repository's link: " gitlink
fi
git clone $gitlink . && clear

#INSTALLING SOFTWARE
read -p "Install [R]ecommended soft or [y]ours: " choice
if [[ $choice == y || $choice == Y ]]; then
read -p "Enter your soft separating by space: " soft
fi
sudo pacman -S $soft --noconfirm && clear

#INSTALLING AUR PACKAGES
read -p "Install [R]ecommended AUR packages or [y]ours: " choice
if [[ choice == y ]]; then
read -p "Enter AUR packages that you need separating by space: " aurpacks
fi
mkdir build
cd build
for pack in ${aurpacks[@]}; do
  git clone https://aur.archlinux.org/${pack}.git
  cd $pack
  makepkg -sri --noconfirm
  cd ..
  clear
done
rm -rf ~/build/* && clear && cd

#ENABLING/DISABLING SYSTEMD SERVICES
read -p "Enable [R]ecommended services or [y]ours: " choice
if [[ $choice == y || $choice == Y ]]; then
read -p "Enter services that you want to ENABLE separating by space: " eservices && clear
read -p "Enter services that you want to DISABLE separating by space: " dservices && clear
fi
for service in ${eservices[@]}; do
  sudo systemctl enable $service
done
for service in ${dservices[@]}; do
  sudo systemctl disable $service
done

clear && exit 0
