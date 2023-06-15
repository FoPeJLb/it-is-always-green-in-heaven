Обязательные действия после установки
Включение службы fstrim (ускоряет работу с ssd)
sudo systemctl enable fstrim.timer
sudo fstrim -v /      (если не работает, то -va)

Даемон, который следит за энтропией системы через аппаратный таймер и ускоряет запуск системы
sudo pacman -S rng-tools
sudo systemctl enable --now rngd

Отключение ожидания сети NetworkManager-ом при запуске системы
sudo systemctl mask NetworkManager-wait-online.service

Установка инструмента pikaur для взаимодействия с aur-репозиторием
mkdir git
cd git
sudo pacman -Syu
sudo pacman -S git
git clone https://aur.archlinux.org/pikaur.git
cd pikaur/
makepkg -sri
cd ..

Reflector отсортирует доступные репозитории по скорости, выбрана страна Германия как оптимальная, можно изменить
sudo pacman -S reflector rsync curl 
sudo reflector --verbose --country 'Germany' -l 25 --sort rate --save /etc/pacman.d/mirrorlist
sudo pikaur -Syu

dbus-broker - это реализация шины сообщений в соответствии со спецификацией D-Bus. Обеспечивает чуть более быстрое общение с видеокартой через PCIe
sudo pacman -S dbus-broker
sudo systemctl enable --now dbus-broker.service

Zramswap — это специальный демон, который сжимает оперативную память ресурсами центрального процессора и создает в ней файл подкачки. Очень ускоряет
систему вне зависимости от количества памяти, однако добавляет нагрузку на процессор, т.к. его ресурсами и происходит сжатие памяти. Поэтому, на слабых
компьютерах с малым количеством ОЗУ, это может негативно повлиять на производительность в целом.
sudo pikaur -S zramswap
sudo systemctl enable --now zramswap.service
echo "ZRAM_COMPRESSION_ALGO=zstd" | sudo tee -a /etc/zramswap.conf

Основной "джентельменский" набор
sudo pikaur -S make automake gcc pacman-contrib gvim gvfs gvfs-mtp i3-wm discord steam firefox kate lrzip unrar unzip unace p7zip squashfs-tools stacer kdenlive polybar dunst
pcmanfm pulseaudio blueman breeze-default-cursor-theme baobab sbxkb nitrogen lxpolkit-git sxhkd imwheel udiskie telegram dmenu htop lxappearance qbittorrent gamemode
sakura lib32-gamemode lib32-nvidia-utils nvidia-settings vulkan-tools lib32-openssl-1.0-hardened lib32-openal bluez-utils neofetch gtk gtk3 gnome gnome-extra vlc 
minecraft-launcher piper nm-connection-editor krita plasma-systemmonitor pavucontrol ntfs-3g yad xdotool piscesys-gtk-themes-git python3 playerctl dbus-python mailspring
cava zsh
sudo systemctl enable pulseaudio && sudo systemctl start pulseaudio
sudo systemctl enable bluetooth && sudo systemctl start bluetooth

Смена оболочки с bash на zsh
sudo -s
chsh -s /bin/zsh root
chsh -s /bin/zsh username

Установка OhMyZsh! для zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

Установка тем для rofi:
git clone https://github.com/orkhasnat/rofi-themes
cd rofi-themes
chmod +x setup.sh
./setup.sh

Шрифты:
ttf-font-awesome noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-ms-fonts noto-fonts-extra ttf-liberation ttf-dejavu ttf-droid ttf-ubuntu-font-family
ttf-hack-nerd ttf-iosevka-nerd adobe-source-serif-fonts adobe-source-han-serif-tw-fonts adobe-source-han-serif-otc-fonts adobe-source-han-serif-kr-fonts
adobe-source-han-serif-jp-fonts adobe-source-han-serif-hk-fonts adobe-source-han-serif-cn-fonts adobe-source-sans-fonts adobe-source-han-sans-tw-fonts
adobe-source-han-sans-otc-fonts adobe-source-han-sans-kr-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-hk-fonts adobe-source-han-sans-cn-fonts
adobe-source-code-pro-fonts ttf-cascadia-code otf-cascadia-code ttf-nerd-fonts-symbols-common wqy-zenhei freetype2 xorg-mkfontscale xorg-fonts-alias-misc
xorg-fonts-cyrillic xorg-fonts-alias-cyrillic xorg-fonts-misc xorg-fonts-encodings

Удаление мусора GNOME:
sudo pacman -Rsn epiphany gnome-boxes gnome-calculator gnome-calendar gnome-contacts gnome-maps gnome-music gnome-weather gnome-clocks gnome-photos 
gnome-software gnome-user-docs totem yelp gnome-user-share gnome-characters simple-scan eog tracker3-miners rygel evolution-data-server gnome-font-viewer
gnome-remote-desktop gnome-logs orca malcontent gvfs-afc gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb gvfs-google evolution gnome-notes gnome-devel-docs
endeavour folks geary gnome-chess gnome-dictionary gnome-2048 gnome-games gnome-builder gnome-klotski gnome-mahjongg gnome-nibbles gnome-recipes gnome-mines 
gnome-robots gnome-sudoku gnome-tetravex gnome-text-editor

Действия по окончанию установки:

[Решение долгого открытия приложений]
sudo pacman -Rdd xdg-desktop-portal-gnome
sudo pacman -S xdg-desktop-portal-gtk

[Отображение пароля в терминале в виде * при вводе]
В файл /etc/sudoers/ добавить строку:
Defaults pwfeedback
