# it-is-always-green-in-heaven

![изображение](https://user-images.githubusercontent.com/95053089/147484340-07cc2753-6376-4209-b33f-c40fcf2b350f.png)
![изображение](https://user-images.githubusercontent.com/95053089/147536568-6eb7939d-56f6-4549-b0cf-daa872b94862.png)

# Порядок установки Arch Linux: 
После попадания в консоль установки требуется подключиться к интернету. Если интернет проводной-то вводится следующая команда:
##### dhcpd
После этого можно проверить соединение при помощи команды ping google.com.
Если же интернет беспроводной (WiFi), то выполняются следующие действия:
1. Вначале нужно посмотреть имя беспроводного сетевого интерфейса коммандой:
##### ip a
2. На всякий случай разблокируем модуль WiFi в системе (обычно он разблокирован по-умолчанию):
##### rfkill unblock wifi
3. Включаем наш модуль WiFi:
##### ip link set (имя нашего сетевого интерфейса, в моём случае wlan0) wlan0 up
4. Запускаем утилиту управления беспроводными сетями:
##### iwctl
5. В данной утилите выполняем подключение к нашей точке доступа WiFi:
##### station (имя нашего беспроводного интерфейса) wlan0 connect (имя нашей точки доступа) Archer
6. Если точка доступа с паролем, то выдаст поле ввода пароля. После подключения к точке доступа прописываем exit для выхода из утилиты iwctl, и проверяем доступность сети командой ping google.com. Важно пинговать именно Google, т.к. если Google не пингуется-то возможна проблема с DNS-адресами, которые находятся в конфиге /etc/resolv.conf, и если это необходимо-то можно его отредактировать, дописав туда:
##### nameserver 8.8.8.8
##### nameserver 8.8.4.4
Теперь надо разметить диск, на который будет установленна система. Следует посмотреть, как подписан наш диск в системе командой: 
##### fdisk -l
У меня это-/dev/sda. Создаём на диске таблицу разделов gpt (так как разметка будет гибридной):
##### fdisk /dev/sda
##### g
##### w
Далее разбиваем диск на разделы при помощи утилиты cfdisk:
##### cfdisk /dev/sda
Здесь создаём раздел в 31М с типом BIOS boot. Потом создаём раздел от 300M до 500M с типом EFI system. В этот раздел устанавливается ядро, поэтому если хотим держать несколько ядер-соответственно, выделяем больше места. Но как правило, для нескольких ядер вполне хватает 500М пространства.
Далее можно, по-желанию, создать раздел подкачки, для слабых компьютеров: 512М, тип Linux swap. 
И последним разделом мы создадим корневой раздел на всё оставшееся место с типом Linux filesystem.
После всех проделанных действий нажимаем Write, вводим yes и жмём Quit.
Проверяем разбивку диска командой
##### fdisk -l
Далее создаём файловую систему на только что созданных разделах диска, форматирование начинаем с раздела EFI system-его нужно отформатировать в fat:
##### mkfs.vfat /dev/sda2
Если Вы создавали раздел подкачки (swap), то он форматируется следующим образом:
##### mkswap /dev/sda3 (sda3 тут указан только для примера,в дальнейшем sda3 у меня будет использоваться для корневого раздела диска, так как раздел swap я не создавал)
После форматирования swap раздела,нужно включить swap командой:
##### swapon /dev/sda3
Далее форматируем корневой раздел в btrfs (как я писал ранее, так как у меня нет swap,то корневой раздел у меня sda3, у Вас это должен быть sda4)
##### mkfs.btrfs /dev/sda3
Если возникли ошибки при форматировании из-за остаточных разделов предыдущей системы,то используем следующую комманду:
##### mkfs.btrfs -f /dev/sda3
Далее монтируем наши разделы:
##### mount /dev/sda3 /mnt
Создаём каталог загрузки на диске (в зависимости от Вашего BIOS)
1. Обычный BIOS:
##### mkdir /mnt/boot
2. UEFI BIOS:
##### mkdir /mnt/boot
##### mkdir /mnt/boot/EFI
Монтируем раздел загрузки, опять же в зависимости от Вашего BIOS:
1. Обычный BIOS:
##### mount /dev/sda2 /mnt/boot
2. UEFI BIOS:
##### mount /dev/sda2 /mnt/boot/EFI
Далее устанавливаем нашу основную систему при помощи утилиты pacstrap:
##### pacstrap -i /mnt base base-devel linux linux-headers linux-firmware dosfstools btrfs-progs intel-ucode iucode-tool nano
Пакет linux-это ядро. Ядро можно поставить linux,linux-zen и linux-lts, и к ним соответствующие headers: linux-headers, linux-zen-headers, linux-lts-headers. 
intel-ucode и iucode-tools-это микрокоды для процессора. Если у Вас процессор AMD, то вместо intel-ucode и iucode-tool вы прописываете следующее:
##### amd-ucode
### Коротко о ядрах:
Самое производительное-это zen ядро, на втором месте стоит обычное ядро linux. Оба этих ядра обладают хорошим быстродействием. Но zen ядро содержит в себе самые свежие разработки, и иногда с новыми обновлениями может сделать систему нестабильной. На этот случай есть обычное ядро linux. Если же проблемы и с ним, то лучше до новых обновлений с исправлением неисправностей на какое-то время перейти на lts-ядро. Оно обновляется значительно реже и гораздо качественнее. С этим ядром система работает максимально стабильно, однако производительность там ниже. Я рекомендую обычное ядро linux.
Теперь создаём файл конфигурации файловых систем нашего диска с помощью следующей команды:
##### genfstab -U /mnt >> /mnt/etc/fstab
Потом проверяем содержимое этого конфига:
##### cat /mnt/etc/fstab
Обратите внимание, что раздел boot тут тоже присутствует и никак не обозначен-так и должно быть.
Далее переходим уже в нашу установленную систему командой:
##### arch-chroot /mnt
Вносим первые изменения в новую систему. Для начала, конфигурируем время и дату:
##### ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
##### hwclock --systohc
Переходим к русификации системы:
##### nano /etc/locale.gen
Здесь из списка выбираем языки,которые будут использоваться в нашей системе, и убираем у них комментирование (решётку в начале). Первый-это английский. Включить его надо обязательно. Другие на Ваше усмотрение. Листаем список и ищем свой язык в кодировке UTF-8, например-русский:
##### ru_RU.UTF-8 UTF-8
После того, как включили нужные нам языки нажимаем Ctrl+X, потом Y, чтобы сохранить изменения и выйти.
После чего вводим команду: 
##### locale-gen
Она нужна для генерации локализации языков.
Потом открываем в редакторе конфиг locale.conf:
##### nano /etc/locale.conf
И прописываем туда локализацию языка,на который будет переведена система (например, русский):
##### LANG=ru_RU.UTF-8
После ввода языка сохраняемся и выходим, как делали это до этого-Ctrl+X, Y.
Далее настраиваем язык консоли, чтобы логи показывались на родном языке.
##### nano /etc/vconsole.conf
##### KEYMAP=ru
##### FONT=cyr-sun16
##### Ctrl+X, Y
Потом задаём имя компьютера (не путать с именем учётной записи):
##### nano /etc/hostname
##### (Вписываем сюда любое имя компьютера, которое захотим. В моём случае будет Gromazeka.)
##### Gromazeka
##### Ctrl+X, Y
Переходим к редактированию файла доменных имён компьютера (или hosts):
##### nano /etc/hosts
Прописываем тут следующие параметры:
##### 127.0.0.1 localhost
##### ::1       localhost
##### 127.0.0.1 (Ваше имя компьютера) Gromazeka.localdomain Gromazeka
##### Ctrl+X, Y
Создаём образ ядра для оперативной памяти, так называемый initramfs:
##### mkinitcpio -p linux
ВАЖНО! Ключ -p в нижнем регистре нужен, если у Вас установлено более одного ядра в системе, чтобы указать какое ядро будет в приоритете.Таким образом, даже если установлено три ядра,-загружаться система будет только с того, который мы вывели с приоритет. Если же установлено только одно ядро, то можно указать ключ -P в верхнем регистре без указания названия ядра.
#
Теперь устанавливаем пароль для root:
##### passwd
Пароль вводится, но не отображается, будьте аккуратны.
Далее скачиваем загрузчик и сетевые утилиты:
##### pacman -S grub efibootmgr dhcpcd dhclient networkmanager
Переходим к установке загрузчика:
##### grub-install /dev/sda
Загрузчик устанавливается на весь диск, а не на раздел.
Если у вас UEFI BIOS и по каким-то причинам команда не сработала, то можете попробовать эту команду:
##### grub-install --boot-directory=/boot/EFI
После этого конфигурируем загрузчик следующей коммандой:
##### grub-mkconfig -o /boot/grub/grub.cfg
После этого пишем Exit для выхода из chroot:
##### exit
Обязательно всё размонтируем командой:
##### umount -R /mnt
И перезагружаемся в нашу установленную систему:
##### reboot
На этапе перезагрузки можно вытащить съёмный носитель с образом диска установщика Arch Linux.
#
После перезагрузки логинимся в root с паролем, который придумали. Потом открываем файл sudoers:
##### nano /etc/sudoers
И снимаем комментирование с одной из строк (удаляем решётку):
##### %wheel ALL=(ALL) ALL
Сохраняемся и выходим
##### Ctrl+X, Y
Это нужно для того, чтобы в обычной учётной записи у нас был рут доступ.
А теперь переходим как раз к созданию обычной записи юзера:
##### useradd -m -G wheel -s /bin/bash (тут пишем никнейм учётной записи с маленькой буквы, использовать заглавные буквы тут нельзя) farevil
Теперь задаём пароль для созданной учётной записи:
##### passwd farevil
Будьте внимательны-ни в коем случае не ставьте один и тот же пароль на рут и на обычного пользователя, они должны отличаться.
Выходим из рут:
##### exit
И логинимся уже в нашу учётную запись пользователя.
Для проверки рут доступа вводим:
##### sudo su
Пароль вводим от учётной записи юзера.
Запускаем сетевую службу networkmanager:
##### systemctl enable NetworkManager
Перезагружаемся:
##### reboot
После перезагрузки логинимся под юзером и подключаемся к интернету, как это было описано в начале гайда. Для подключения к точке доступа wifi теперь нет утилиты iwctl, но вместо неё можно использовать nmcli, подключение через неё выглядит следующим образом:
##### nmcli d wifi connect (Имя точки доступа) Archer
Если у точки доступа установлен пароль,то команда будет выглядеть так:
##### nmcli d wifi connect Archer passwd (Пароль) 1234567890
После того, как успешно подключились к интернету, открываем в редакторе pacman.conf:
##### sudo nano /etc/pacman.conf
И убираем решётку со строчки multilib:
##### [multilib]
##### Include = /etc/pacman.d/mirrorlist
##### Ctrl+X, Y

# Далее идёт список пакетов для установки драйверов для графики у Intel, AMD и NVIDIA:

##### Прописываем sudo pacman -Syu, и далее списком пакеты для установки в зависимости от Вашей системы:
##### Intel:
sudo pacman -Syu lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-    loader libva-media-driver xf86-video-intel 
##### Nvidia:
sudo pacman -Syu nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader lib32-opencl-nvidia opencl-nvidia libxnvctrl 
##### Nvidia + Intel:
sudo pacman -Syu nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader lib32-opencl-nvidia opencl-nvidia libxnvctrl lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader libva-intel-driver xf86-video-intel 
##### AMD:
sudo pacman -Syu lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
#
Далее установим network-manager-applet-это важное дополнение для NetworkManager, которое используется во многих графических оболочках:
##### sudo pacman -S network-manager-applet
Теперь установим сервер оконных приложений (xorg), среду визуализации графических приложений и оконный менеджер (в примере используется GNOME, но я дам список установки других оконных менеджеров. Если нужен i3-то пропустите этот блок и приступите к блоку "Оформление системы"):
##### sudo pacman -S xorg xorg-server gnome gnome-extra gdm
Включаем автозапуск display manager-а gdm 
##### systemctl enable gdm
# Другие оконные менеджеры:
### XFCE:
##### pacman -S xorg xorg-server xfce4 xfce4-goodies lightdm lightdm-gtk-greeter 
##### Включаем дисплей менеджер systemctl enable lightdm 
### KDE Plasma:
##### pacman -S xorg xorg-server plasma  plasma-wayland-session  egl-wayland sddm sddm-kcm packagekit-qt5 kde-applications 
##### Включаем дисплей менеджер systemctl enable sddm 
### Cinnamon:
##### pacman -S xorg xorg-server cinnamon 
##### Включаем дисплей менеджер systemctl enable gdm 
### Deepin:
##### pacman -S xorg xorg-server deepin deepin-extra lightdm lightdm-deepin-greeter 
##### Включаем дисплей менеджер systemctl enable lightdm
### Enlightenment:
##### pacman -S xorg xorg-server enlightenment lightdm lightdm-gtk-greeter
##### Включаем дисплей менеджер systemctl enable lightdm
### Mate:
##### pacman -S xorg xorg-server  mate   mate-extra  mate-panel   mate-session-manager
##### Включаем дисплей менеджер systemctl enable mdm
### LXDE:
##### pacman -S xorg xorg-server lxde-common  lxsession openbox lxde lxdm
##### Включаем дисплей менеджер systemctl enable lxdm
### Прочие оконные менеджеры тут:
https://wiki.archlinux.org/title/desktop_environment
#


# Порядок установки моего оформления системы:
##### pacman -S git
##### mkdir ~/gitclone
##### cd ~/gitclone
##### git clone https://aur.archlinux.org/pikaur.git
##### cd pikaur
##### makepkg -sri
##### sudo pikaur -Syu && sudo reboot
##### pikaur -S nvidia nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader vulkan-headers libxnvctrl i3-gaps polybar i3-lock sakura dmenu kate pcmanfm blueman sxhkd setxkbmap nitrogen dunst imwheel udiskie maim xclip ttf-font-awesome ttf-iosevka-nerd ttf-weather-icons lxappearance pavucontrol breeze-snow-cursor-theme microsoft-edge-stable-bin vlc steam spotify gnome-disks stacer minecraft-launcher nm-connection-editor krita wps-office telegram-desktop discord adobe-source-code-pro-fonts ttf-ms-fonts ttf-ubuntu-font-family neofetch cmatrix cava qbittorrent baobab
##### sudo nvidia-xconfig
##### sudo mkinitcpio -p linux
##### sudo grub-mkconfig -o /boot/grub/grub.cfg
##### sudo reboot
##### mkdir ~/.config/polybar/scripts
##### sudo cp etc/dunst/dunstrc ~/.config/dunst/dunstrc
##### sudo rm etc/dunst/dunstrc
##### mkdir ~/.config/i3
##### sudo pikaur -Syu && sudo reboot
