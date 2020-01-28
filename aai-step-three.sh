#!/bin/bash

#CHECK THE SCRIPT IS NOT BEING RUN BY ROOT

if [ "$(id -u)" == "0" ]; then
   echo "This script must not be run as root"
   exit 1
fi 

#MINIMAL ARCHER LIST
minimal="i3 rxvt-unicode picom conky dmenu zsh nano nnn feh moc mpv htop git openssh neofetch surf lynx wget"

#PACKAGES FOR PROGRAMMERS
prog="code qtcreator gdb"

#OFFICE PACKAGES
office="libreoffice-fresh"

#GUI BROWSERS
browsers="chromium firefox"

#SOME UTILS
utils="xf86-input-synaptics"

#INSTALLING PACKAGES

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
makepkg -sri --noconfirm
cd ..

#NCURSES DISPLAY MANAGER

git clone https://aur.archlinux.org/ly-git.git
cd ly-git
makepkg -sri --noconfirm
cd ..
sudo systemctl enable ly
sudo systemctl disable getty@tty2

#OH-MY-ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

#CHANGING DEFAULT SHELL FOR ROOT AND USER

chsh -s /bin/zsh
sudo chsh root -s /bin/zsh

#URXVT CONFIG

touch ~/.Xresources
echo -e "
URxvt.scrollBar: false
URxvt*scrollTtyKeypress: true
URxvt*font: xft:DejaVu Sans Mono:size=12
URxvt.letterSpace: -1
*.foreground:   #cbcbd8
*.background:   #0e0d18
*.cursorColor:  #cbcbd8
*.color0:       #171625
*.color8:       #e1a8cc
*.color1:       #1f1f31
*.color9:       #79c69e
*.color2:       #302f48
*.color10:      #bebde9
*.color3:       #474668
*.color11:      #f09472
*.color4:       #646387
*.color12:      #e56ec1
*.color5:       #8887a5
*.color13:      #9794d8
*.color6:       #b2b2c5
*.color14:      #bcbe5f
*.color7:       #e2e2e9
*.color15:      #64b1bd
urxvt*depth: 32
urxvt*background: rgba:0000/0000/0200/c800
" > ~/.Xresources

#AUTOSTART
cd
wget -O wallpaper.jpg https://git.io/JvY8U

touch ~/.xinitrc
echo -e "
xrdb -merge ~/.Xresources &
picom & &
feh --bg-scale ~/wallpaper.jpg
" > ~/.xinitrc


#SETTING UP "TERMINALPARTY" THEME FOR ZSH

echo -e "
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="terminalparty"
plugins=(git)
source $ZSH/oh-my-zsh.sh" > ~/.zshrc

#CLEARING BUILD DIR
rm -rf build/*

exit 0
