sudo pacman -S i3 rxvt-unicode zsh gdb git dmenu openssh htop nnn neofetch nano conky compton --noconfirm
sudo pacman -S chromium qtcreator libreoffice-fresh --noconfirm
sudo pacman -S xf86-input-synaptics --noconfirm

mkdir build
cd build

git clone https://aur.archlinux.org/ly-git.git
cd ly-git
makepkg -sri
cd ..

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

chsh -s /bin/zsh
sudo chsh root -s /bin/zsh

echo "export ZSH=""$USER"/.oh-my.zsh" >  ~/.zshrc
echo "ZSH_THEME="terminalparty" >> ~/.zshrc
