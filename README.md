# it-is-always-green-in-heaven

![изображение](https://user-images.githubusercontent.com/95053089/147484340-07cc2753-6376-4209-b33f-c40fcf2b350f.png)
![изображение](https://user-images.githubusercontent.com/95053089/147536568-6eb7939d-56f6-4549-b0cf-daa872b94862.png)


Порядок установки:
##### pacman -S git
##### mkdir ~/gitclone
##### cd ~/gitclone
##### git clone https://aur.archlinux.org/pikaur.git
##### cd pikaur
##### makepkg -sri
##### pikaur -Syu
##### pikaur -S nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader lib32-opencl-nvidia opencl-nvidia libxnvctrl lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader libva-intel-driver xf86-video-intel nvidia-dkms-performance i3-gaps polybar i3-lock sakura dmenu kate pcmanfm blueman sxhkd setxkbmap nitrogen dunst imwheel udiskie maim xclip ttf-font-awesome ttf-iosevka-nerd ttf-weather-icons lxappearance plasma-systemmonitor pavucontrol breeze-snow-cursor-theme firefox vlc steam spotify gnome-disks stacer minecraft-launcher nm-connection-editor krita wps-office telegram-desktop discord adobe-source-code-pro-fonts ttf-ms-fonts ttf-ubuntu-font-family neofetch cmatrix cava qbittorrent baobab
##### sudo reboot
##### mkdir ~/.config/polybar/scripts
##### sudo cp etc/dunst/dunstrc ~/.config/dunst/dunstrc
##### sudo rm etc/dunst/dunstrc
##### mkdir ~/.config/i3
##### sudo pikaur -Syu && sudo reboot
