#!/bin/bash

#CHECK THE SCRIPT IS NOT BEING RUN BY ROOT
if [ "$(id -u)" == "0" ]; then
   echo "This script must not be run as root"
   exit 1
fi 

#MINIMAL ARCHER LIST
minimal="i3 rxvt-unicode compton conky dmenu zsh nano nnn feh moc mpv htop git openssh neofetch surf lynx"

#PACKAGES FOR PROGRAMMERS
prog="code qtcreator gdb"

#OFFICE PACKAGES
office="libreoffice-fresh"

#GUI BROWSERS
browsers="chromium firefox"

#SOME UTILS
utils="xf86-input-synaptics"


sudo pacman -S $minimal --noconfirm
sudo pacman -S $prog --noconfirm
sudo pacman -S $office --noconfirm
sudo pacman -S $browsers --noconfirm
sudo pacman -S $utils --noconfirm


#CREATING BUILD DIR
mkdir build
cd build

#JS CLI BROWSER
git clone https://aur.archlinux.org/browsh.git
cd browsh
makepkg -sri
cd ..

#NCURSES DISPLAY MANAGER
git clone https://aur.archlinux.org/ly-git.git
cd ly-git
makepkg -sri
cd ..

#OH-MY-ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

#CHANGING DEFAULT SHELL FOR ROOT AND USER
chsh -s /bin/zsh
sudo chsh root -s /bin/zsh

#SETTING UP "TERMINALPARTY" THEME FOR ZSH
echo "export ZSH=""$USER"/.oh-my.zsh" >  ~/.zshrc
echo "ZSH_THEME="terminalparty"" >> ~/.zshrc

#CLEARING BUILD DIR
rm -r build/*

#LAST REBOOT
reboot
