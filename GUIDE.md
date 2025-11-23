# Arch Linux and Hyprland installation, setup and customization guide

*Note: whenever you see something between the `<>` symbols in this guide, it means that you need to replace this with something else in your specific case. For example, if your personal username is `user1` and if you see a command that says `ls /home/<username>/.config` then it means that you need to execute `ls /home/user1/.config`*

## Preparing

- Download the arch iso image online

- Plug the USB stick and use Rufus to flash the iso to the USB stick (this will overwrite data from the USB)

- Before starting the install, go to your bios settings (hit F2 or DEL on startup for most motherboards) and make sure to disable Secure Boot

- Reboot the computer, open the boot selection menu (depends on hardware, F8 for me, or you can change order in bios, accessible with F2 or DEL)

- Boot into the USB stick

- Select the first option to install arch

## Installing

- To change the keyboard layout, use `loadkeys <layout>` so for french AZERTY it is `loadkeys fr-pc` or `loadkeys fr` (slightly different layouts, `fr-pc` is probably the one you're using)

- Make sure to have Ethernet plugged in for easier setup. If you can't plug an ethernet cable, then you first need to connect to a wifi network

- For that, execute `iwctl` to enter into the wifi setup space, then use `device list` to list your computer's wireless devices, usually you'll only get one entry with a `wlan0` device, replace `wlan0` with the name you get for the next steps if you have a different one

- Enable it with `adapter phy0 set-property Powered on` then `device wlan0 set-property Powered on`

- Now execute `station wlan0 scan` to search for nearby wifi networks, wait a few seconds, then execute `station wlan0 get-networks` to list all the detected wifi networks

- Then connect to your wifi with `station wlan0 connect <wifiName>` and enter your wifi password if needed, and finally use `exit` to go back to the terminal and continue the install process

- You can list disks and partitions with `lsblk`, use this command as much as needed, each time you need to check your partitions and their names

- Note that for this install, I assume that your computer uses UEFI, which is the case on almost every somewhat recent computer, if you're still on legacy BIOS then refer to the arch wiki at [https://wiki.archlinux.org/title/Installation_guide](https://wiki.archlinux.org/title/Installation_guide) section 1.9 for detailed instructions

- IMPORTANT: if you're dual booting and have another OS (such as Windows), skip the creation and formatting of the EFI boot partition, as it already exists, but then mount the already present EFI boot partition when the guides tells you to

- Use `cfdisk /dev/<diskName>` using the physical disk on which you want to install arch linux, and create 3 partitions: one for the boot, around 1Gb, one for the swap, for example 8Gb (optional but strongly recommended, you can later create a swap file instead), and the main one, what's left

- If you don't want to create a swap partition, you can make a swap file later on

- Format partitions:  
Main part: `mkfs.ext4 /dev/<mainPart>`  
EFI Boot part: `mkfs.fat -F 32 /dev/<bootPart>`  
Swap part: `mkswap /dev/<swapPart>`  

- Mount partitions:  
Main: `mount /dev/<mainPart> /mnt`  
EFI Boot: `mount --mkdir /dev/<bootPart> /mnt/boot/efi`  
Swap: `swapon /dev/<swapPart>`  

- Install basic packages with pacstrap, here is what I think is the minimal install:

```bash
pacstrap -K /mnt base linux linux-firmware nano base-devel <amd-ucode OR intel-ucode> networkmanager efibootmgr grub
```

- If you want to use wifi, also install the `iwd` and `dhcpcd` packages, for example I personally like to install these, but you can have a way less bloated system:

```bash
pacstrap -K /mnt base linux linux-firmware nano base-devel amd-ucode sof-firmware networkmanager man-db man-pages texinfo bash bluez-libs curl efibootmgr grep grub gzip kitty-terminfo nmap openssh openssl pacman pacman-mirrorlist python python-requests python-urllib3 rsync sqlite sudo systemd tar xz zsh e2fsprogs gvfs gvfs-mtp os-prober fastfetch wget iwd dhcpcd
```

- Generate the fstab: `genfstab -U /mnt > /mnt/etc/fstab`

- Enter the install: `arch-chroot /mnt`

- Set timezone: `ln -sf /usr/share/zoneinfo/<Region>/<City> /etc/localtime`

- For example, for French timezone:

```bash
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
```

- Sync the time: `hwclock --systohc`

- To generate locales, execute `nano /etc/locale.gen` and uncomment (remove the `#`) the locale(s) that you want to generate (use the UTF-8 ones), then save and exit the file and run `locale-gen` to generate them

- Execute `nano /etc/locale.conf` and enter in the file `LANG=<language>`

- For example, for US English, write `LANG=en_US.UTF-8`

- Save and exit the file

- Then for the keyboard layout, execute `nano /etc/vconsole.conf` and write `KEYMAP=<keymap>`

- For example, for the French pc layout, write `KEYMAP=fr-pc`

- To name the computer, do `nano /etc/hostname` and enter the name you want to give your computer (only letters, numbers and dash symbols, between 3 and 15 characters) then save and exit the file

- To set the root password, execute `passwd` and enter the password twice

- To add a user, execute `useradd -m -G wheel -s /bin/bash <username>`

- Then run `passwd <username>` and enter the user password twice

- To enable sudo, execute `EDITOR=nano visudo` and uncomment the line that says `%wheel ALL=(ALL:ALL) ALL` then save and exit the file

- Enable the network service with `systemctl enable NetworkManager`

- Install grub with `grub-install /dev/<disk>` by specifying the disk with your new install (the disk, not the partition)

- Then apply grub configuration with `grub-mkconfig -o /boot/grub/grub.cfg`

- We can now reboot, type `exit` to go back to the installer terminal, then `umount -a` to unmount everything, then `reboot`

## Configuring the system

*Useful tip: if you need multiple tty terminals during the configuration, you can switch terminal with CTRL+Alt+\<F1-F6\> which will allow to go back and forth between different terminals, to read the uuid and write it in a file without writing it down for example*

- First, if you don't have an ethernet cable, then you need to configure the wifi again, you first need to enable the iwd service with `sudo systemctl enable --now iwd` and the dhcp service with `sudo systemctl enable --now dhcpcd` and run `sudo dhcpcd wlan0` (install these packages with pacman if needed)

- After that, run `sudo nano /etc/iwd.main.conf` and add the following content:

```ini
[General]
EnableNetworkConfiguration=true
```

- And then run `sudo systemctl enable --now systemd-networkd` and `sudo systemctl restart iwd`

- Then refer to the beginning of this guide, just under the **Installing** section, and follow the exact same steps to connect to wifi again

- Change pacman config with `sudo nano /etc/pacman.conf` and under the `misc` options, uncomment and set the number of parallel downloads (to 10 for example), uncomment `Color`, add `ILoveCandy` for a cool pacman effect when downloading packages, and uncomment the `[multilib]` section (both lines), then execute `sudo pacman -Syyu` to update pacman and the system

- To select the fastest pacman mirrors, install `reflector` with `sudo pacman -S reflector` then backup the default mirrorlist with `sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak` and then update the mirrorlist with `sudo reflector --verbose --latest 5 --protocol https --sort rate --country <Country> --save /etc/pacman.d/mirrorlist` then update with `sudo pacman -Syyu`

- To run reflector on each startup, set the following config with `sudo nano /etc/xdg/reflector/reflector.conf` and change the settings like this (change the country to yours, you can put multiple separated by commas):

```ini
--save /etc/pacman.d/mirrorlist
--country France
--protocol https
--latest 5
--sort rate
```

- And enable the service with `sudo systemctl enable --now reflector`

- Install some basic apps, like a terminal, web browser, file browser, various utilities, etc. For example, here's what I usually install to fulfill all my needs, 
of course don't install all of these but only what you need (do some research on what those packages are if in doubt):

```bash
sudo pacman -S kitty firefox nemo git elinks wine pavucontrol pulseaudio pulseaudio-bluetooth pulseaudio-jack ntfs-3g pass gnome-keyring seahorse qt5-wayland vlc sxiv nvim kate udisks2 python-pip tk gtk4-layer-shell fzf network-manager-applet gnome-calculator arduino-ide kdeconnect libratbag piper vi 7zip inkscape gvfs-goa gvfs-google ark gimp sqlitebrowser nfs-utils gvfs-nfs gvfs-smb dosfstools exfatprogs micro linux-headers gdb
```

- Enable the audio service after login with `systemctl --user enable pulseaudio`

- For bluetooth support, install it with `sudo pacman -S bluez blueman bluez-utils` then enable it with `sudo modprobe btusb` then `sudo systemctl enable --now bluetooth`

- Setup java with `sudo pacman -S jdk-openjdk`

- To install yay (utility to install packages from the community repository), make sure to have `base-devel` and `git` installed with pacman, then download yay with `git clone https://aur.archlinux.org/yay.git` then enter the folder with `cd yay` and compile with `makepkg -si` and finally exit with `cd ..` and remove the folder with `rm -rf yay/`

- We can now install vscode for example with `yay -S visual-studio-code-bin`

- To enable bluetooth autoconnect for paired and trusted devices, install the package with `yay -S bluetooth-autoconnect` then enable the global service with `sudo systemctl enable --now bluetooth-autoconnect` and the sound user service with `systemctl --user enable --now pulseaudio-bluetooth-autoconnect`

- Setup flatpak with `sudo pacman -S flatpak`

- Install a firewall with `sudo pacman -S ufw` then enable it with `sudo systemctl enable --now ufw` then `sudo ufw enable`

- For faster app launch time, install preload with `yay -S preload` and enable it with `sudo systemctl enable --now preload` (this will cost a bit more ram, but has the advantage to make apps launch almost instantly)

- If dual booting with windows, change the time reference with `sudo timedatectl set-local-rtc 1 --adjust-system-clock` then reboot into windows and resync the time there from the windows settings

- Configure grub with `sudo nano /etc/default/grub` and change settings such as the timeout and the default entry (enter a number or a string), then apply the changes with `sudo grub-mkconfig -o /boot/grub/grub.cfg`

- If you prefer the `update-grub` command shortcut for refreshing grub, then install it with `yay -S update-grub` and you can now run `sudo update-grub` instead

- If dual booting with windows, add it to the menu entries. For this, install modprobe with `sudo pacman -S os-prober` then enable os-prober in the grub config file at `/etc/default/grub` so that it automatically detects other systems

- If you have issues with modprobe or want to manually add the entry, then get the windows EFI partition UUID with `lsblk --fs` and remember the UUID of the windows EFI partition, then edit the custom entries file with `sudo nano /etc/grub.d/40_custom` and add the following at the end (replace `<customName>` with the entry name you want and `<efiPart>` with the UUID you got previously):

```bash
menuentry "<customName>" {
insmod part_gpt
insmod fat
insmod search_fs_uuid
insmod chain
search --fs-uuid --no-floppy --set=root <efiPart>
chainloader (${root})/efi/Microsoft/Boot/bootmgfw.efi
}
```

- Then apply the changes again with `sudo grub-mkconfig -o /boot/grub/grub.cfg` (or with `sudo update-grub` if installed)

- You can theme grub as you wish, you can find a list of some themes [here](https://github.com/jacksaur/Gorgeous-GRUB) for example

- If using an Nvidia GPU, we need to install drivers, get info on the GPU with `lspci -k -d ::03xx` then search the appropriate package on [https://wiki.archlinux.org/title/NVIDIA](https://wiki.archlinux.org/title/NVIDIA)

- For example, for the RTX 4060, we need the `nvidia` package. Install the required package, for example with `sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils`

- If you have multiple drives and want them to be mounted on startup, then create a folder for each partition in the `/mnt` directory, then edit the fstab

- For example, if you want to mount a windows partition, first create a directory, with for example `sudo mkdir /mnt/windows`, then get the partition uuid with `lsblk --fs` and edit the fstab with `sudo nano /etc/fstab` and add the following by replacing with your uuid:

```ini
UUID=<yourUUID> /mnt/<folderName> <fileSystem> defaults,nofail 0 0
```

- In respective order, put the drive uuid, then the mount directory, then the filesystem (`ntfs` for windows, `ext4` for linux etc), then the options, finally just set the last two arguments to 0, then save and exit the file and execute `sudo systemctl daemon-reload` to reload the config, and then `sudo mount -a` to mount the new drives

- If you didn't create a swap partition, you can create a swap file instead, run `sudo mkswap -U clear --size 20G --file /swapfile` by replacing the `20G` by the amount of swap you want, then activate it with `sudo swapon /swapfile`, and finally add an entry in the fstab for the swap file by editing `/etc/fstab` as root and adding the following line:

```ini
/swapfile none swap defaults 0 0
```

- By default, NetworkManager will scan for nearby wifi networks using a different mac address each time, which can lead to a bunch of "unknown device" showing up in your router interface, you can avoid this by configuring NetworkManager by editing `/etc/NetworkManager/NetworkManager.conf` as root and adding the following content:

```ini
[device]
wifi.scan-rand-mac-address = no
[ethernet]
ethernet.cloned-mac-address = permanent
[wifi]
wifi.cloned-mac-address = permanent
```

- Then restart the service with `sudo systemctl restart NetworkManager`

- To use zsh instead of the default bash, install the `zsh` and `zsh-completions` packages using pacman, then execute `zsh` in the terminal and follow the configuration assistant, you might also want to move some configurations from your `.bashrc` to `.zshrc` if you made some changes yourself, such as the starship launch command (replace bash with zsh) or your aliases

- To permanently change to zsh, run `chsh -s /bin/zsh` (and eventually `sudo chsh -s /bin/zsh` to make the root user have zsh too)

- You can enable plugins for zsh for various functionalities, you can see a `.zshrc` config file in my repo for example

- To install the zsh inline autocompletion, install the plugin with `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions` then add `zsh-autosuggestions` in the plugins section of the `.zshrc` file 

## Setup hyprland

- First, install kitty with `pacman` if it's not already installed

- Then, install hyprland with `sudo pacman -S hyprland`

- Also install the xdg portal for hyprland with `sudo pacman -S xdg-desktop-portal-hyprland`

- You can now launch hyprland by executing `Hyprland`

- After each reboot, you'll need to manually log into the tty, and then execute `Hyprland` to launch the interface

- However if you want a graphical login interface, you can install a login manager, some popular options are `sddm`, `lightdm`, `gdm`, or `ly` (you can find more), for that install the login manager you want with `sudo pacman -S <loginManager>` then enable and launch it with `sudo systemctl enable --now <loginManager>` and inside the login interface, set the interface to launch into Hyprland (note that by default, the login manager might be set to a qwerty layout, to change that refer to the chosen login manager documentation)

- Or if you only have one user configured, you can automatically log your user in and launch hyprlock on startup to enter your password, if you wish to do that then refer to later in this section

- Keep in mind that for now, the keyboard layout is set to US qwerty, we will first change that (if needed)

- First, open the terminal with Super+Q (Q for qwerty layout, so if you have for example an AZERTY keyboard, you need to press Super+A, Super is the Windows key on most keyboards)

- Then open the config file with `nano ~/.config/hypr/hyprland.conf` and in the `INPUT` section change the `kb_layout` variable value, for example set it to `fr` for a french AZERTY layout, then save the file

- The config will automatically reload when changed

- Then remove the warning at the top of the screen by commenting (adding `#` in front) the `autogenerated = 1` line and saving the file

- You can also enable the NumLock by default by going back in the `INPUT` field, and add a variable `numlock_by_default = true`

- List monitors with `hyprctl monitors all` and remember the name of your monitors (first line, just after "Monitor") then go back to the hyprland config file (`nano ~/.config/hypr/hyprland.conf`) and add your own monitor under the first monitor line:

```ini
monitor=<name>,<resolution>,<position>,<scale>
```

- The position and scale can both be set to `auto` if you don't want to change them

- To format the resolution, it's `<width>x<height>@<refreshRate>` (the `@<frequency>` part is optional, it will default to `60`)

- You can set a gtk and qt theme in the h config file to set a global dark theme, for example with the following lines:

```ini
exec = gsettings set org.gnome.desktop.interface gtk-theme "<darkGTK3Theme>"
exec = gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
env = QT_QPA_PLATFORMTHEME,qt6ct
```

- You can use `Fluent-Dark` for example as a dark gtk3 theme, you can install it with `git clone https://github.com/vinceliuice/Fluent-gtk-theme` then enter the cloned directory and run `./install.sh` and after that you can delete the directory

- It's also possible to change the mouse sensitivity under the `INPUT` section by changing the `sensitivity` variable, and you can disable mouse acceleration by adding a variable `accel_profile = flat`

- At the end of the config file, you can set your own keyboard shortcuts to execute commands or open apps, you can also at the beginning of the file set apps and commands to execute on hyprland startup by using `exec-once`

- You can browse and edit the config yourself, or check the wiki for a complete list of possible configs, or find premade configs online (I made one on my repo at [https://github.com/ilwan07/ArchRice](https://github.com/ilwan07/ArchRice))

- Install a program launcher, for example wofi with `sudo pacman -S wofi`

- We also need a notification daemon to be able to see notifications, we will use swaync, install it with `yay -S swaync` and make sure that it gets executed on startup in the hyprland config file

- If you want to use hyprlock on startup as described earlier, then first install it with `sudo pacman -S hyprlock` then install greetd with `sudo pacman -S greetd` and enable it so it launches on startup with `sudo systemctl enable greetd`

- Edit the greetd config with `sudo nano /etc/greetd/config.toml` and we need to make it log in automatically, for that go to the end of the file, and add the following content by putting your own username:

```toml
[initial_session]
command = "Hyprland"
user = "<yourUsername>"
```

- Now, hyprland should automatically launch on startup, but it doesn't ask for a password, let's fix that

- First, we need to create a config file for hyprlock in `~/.config/hypr/hyprlock.conf`, you can create your own from scratch using the wiki, or check [my repo](https://github.com/ilwan07/ArchRice) for a premade config

- Then, in the hyprland config, add `hyprlock` to the `exec-once` section

- You can also automatically unlock the gnome keyring on login by editing `/etc/pam.d/hyprlock` as root and putting the following content in it:

```ini
auth include login
auth optional pam_gnome_keyring.so

account include login
password include login

session include login
session optional pam_gnome_keyring.so auto_start
```

## Customize the interface

- You can customize a lot of things in hyprland. If you don't know where to start, have a look at [my repo](https://github.com/ilwan07/ArchRice), you need to install all the dependencies and copy the config files in your user directory

- To change the mouse theme, install hyprcursor with `sudo pacman -S hyprcursor` and also run `sudo pacman -S xdg-desktop-portal-gtk` then go in the config file, and under `ENVIRONMENT VARIABLES` add `env = XCURSOR_THEME,<theme>`, you can for example use the `Oxygen_White` theme, which you can install with `yay -S oxygen-cursors` then select it in `nwg-look` (install it with yay, see below), also add the following line in the hyprland config file: `exec = gsettings set org.gnome.desktop.interface cursor-theme "<theme>"`

- Set up hyprpaper with `sudo pacman -S hyprpaper` then create a config file with `nano ~/.config/hypr/hyprpaper.conf` and write the following:

```ini
preload = <pathToWallpaper>
wallpaper = , <pathToWallpaper>
```

- Also install font awesome to be able to display some font icons, for that use `sudo pacman -S ttf-font-awesome`

- You can customize wofi by editing the `~/.config/wofi/style.css` file, again look at [my repo](https://github.com/ilwan07/ArchRice)

- To get a status bar at the top of your screen, you can use a program such as waybar, which you can install with `sudo pacman -S waybar`

- You can execute waybar to preview how the status bar will look like, you can configure it by modifying the config files in `~/.config/waybar/`, you can see an example on [my repo](https://github.com/ilwan07/ArchRice) again

- To make the terminal look nicer, you can change the config from `~/.config/kitty`, again refer to [my repo](https://github.com/ilwan07/ArchRice)

- To enhance the command line, install starship with `sudo pacman -S starship` and also a custom font with `sudo pacman -S ttf-cascadia-code-nerd` and create the config file with `nano ~/.config/starship.toml` (you can leave it empty/with the default content for now) then enable it by using `nano ~/.bashrc` then at the beginning of the file, just after the first three lines, write `eval "$(starship init bash)"`

- Again, refer to [my repo](https://github.com/ilwan07/ArchRice) for the starship customization

- You can use that font in the vscode terminal by changing the `terminal.integrated.fontFamily` setting to `CaskaydiaCove Nerd Font Mono`

- For japanese and other unicode characters support, install some more fonts:

```bash
sudo pacman -S noto-fonts-cjk noto-fonts-emoji noto-fonts
``` 

- To avoid other issues with unrecognized characters, you can install a few more fonts:

```bash
yay -S ttf-freefont ttf-linux-libertine ttf-dejavu ttf-inconsolata ttf-ubuntu-font-family otf-unifont
```

- And a few more to properly display math formulas:

```bash
sudo pacman -S otf-libertinus otf-latinmodern-math
```

- To theme the gtk applications, install nwg-look with `yay -S nwg-look` then install a theme, for example catppuccin mocha themes, with `yay -S catppuccin-gtk-theme-mocha` then open the `nwg-look` app (from a program launcher, or by executing `nwg-look` in the terminal) and select the theme you want to use

- You can customize the fastfetch utility by modifying the config file in `~/.config/fastfetch/config.jsonc`, again refer to [my repo](https://github.com/ilwan07/ArchRice)

- Enable auto indentation and syntax highlighting in nano by creating a nano config file as `~/.nanorc` and putting this in the file:

```ini
set autoindent
include /usr/share/nano/*.nanorc
include /use/share/nano/extra/*.nanorc
```

- Then copy this config to the root user with `sudo cp ~/.nanorc /root/.nanorc`

- If you want to use a bluetooth device on both linux and windows in dual boot, you can follow [these instructions](https://github.com/spxak1/weywot/blob/main/guides%2Fbt_dualboot.md)

- You can also add aliases to create your own terminal shortcuts

- For this, open the `~/.bashrc` file and at the end, add as much aliases as you want using the following format:

```
alias <shortcut>='<commandToExecute>'
```

- If you want a more elegant way than grub to boot, you can install and setup refind instead and theme it, install `refind` with `pacman`, then install it with `sudo refind-install`

- Next, install a theme of your choice, you can find some [here](https://github.com/martinmilani/rEFInd-theme-collection), or you can use mine [here](https://github.com/ilwan07/ArchRice/tree/main/RefindTheme)

- To further configure the refind menu, edit the config file as root, it is located at `/boot/efi/EFI/refind/refind.conf`

## Setup other useful programs

- Install the hyprshot screenshot utility with `yay -S hyprshot` and you can add keybinds in the hyprland config file to take screenshots (again, refer to [my repo](https://github.com/ilwan07/ArchRice))

- Setup git with `git config --global user.name "<yourName>"` and `git config --global user.email "<yourEmail>"` then `git config --global init.defaultBranch main` and set the default text editor used by git with `git config --global core.editor "<editor>"` (for example `"nano"`) then install github-cli with `sudo pacman -S github-cli` and link your github account with `gh auth login`

- Set nemo as the default file manager with x `xdg-mime default nemo.desktop inode/directory application/ x-gnome-saved-search`

- You will also need to tell nemo that your terminal is kitty with `gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty`

- Install cliphist with `sudo pacman -S cliphist` for a clipboard manager (you can set keybinds in the hyprland config)

- To manage your rgb lights, install openrgb with `sudo pacman -S openrgb` and create in the openrgb interface a profile, then put the command to apply the profile in the hyprland config (look at [my repo](https://github.com/ilwan07/ArchRice) for reference)

- Setup python with a main virtual environment for quick testing, open the terminal, make sure to be in your user directory (or where you want your venv to be) and run `python -m venv .venv` to create your virtual environment, you can later run `source ~/.venv/bin/activate` to enter the python venv, then use python or install packages with pip for example

- If you use vscode, you need to tell it to use gnome-libsecret, launch vscode and press ctrl+shift+P then select `Preferences: Configure Runtime Arguments` and in the file add `"password-store": "gnome-libsecret"`

- You can install slack with `yay -S slack-desktop`

- For anonymous browsing, install tor with `sudo pacman -S torbrowser-launcher` and tribler torrent downloader with `yay -S tribler-bin`

- Install steam with `sudo pacman -S steam` and the microsoft fonts with `yay -S ttf-ms-win11-auto` and in the steam settings, in steam play, enable the use of proton hotfix to be able to run windows games

- To capture the screen, install obs with `sudo pacman -S obs-studio` then install xdg portal with `sudo pacman -S xdg-desktop-portal-wlr` and install `v4l2loopback-obs-dkms` with `yay`, and then some qt packages with `sudo pacman -S qt5ct qt6ct` and finally in your hyprland config file add an environment variable by adding `env = QT_QPA_PLATFORM,wayland`

- If you want a task viewer in your terminal, install bpytop with `sudo pacman -S bashtop` and run `bashtop` in the terminal to launch it

- For a terminal file viewer, install ranger with `sudo pacman -S ranger`

- To get info on your cpu, install cpufetch with `sudo pacman -S cpufetch` and run the command just like with fastfetch

- To automatically mount drives, install udiskie with `sudo pacman -S udiskie` and add the `udiskie` command to the hyprland config to launch it at startup

- To get a nice ai assistant app, install newelle with `yay -S newelle` and also install needed modules with `sudo pacman -S gtksourceview5 python-matplotlib`

- To be able to use printers, follow this guide: [https://gist.github.com/progzone122/0b4e2a85ea44d0dc1e74fc16ee4d9700](https://gist.github.com/progzone122/0b4e2a85ea44d0dc1e74fc16ee4d9700)

- For epson printers and scanners, you might as well need a few more dependencies, install them with `yay -S epson-inkjet-printer-escpr epson-inkjet-printer-escpr2` then `sudo pacman -S sane-airscan avahi nss-mdns` then enable the avahi service with `sudo systemctl enable --now avahi-daemon` and finally edit `/etc/sane.d/dll.conf` with sudo and add `airscan` to the list if it's not already here, you can then use skanpage (install instructions below) to use the scanner

- To print as pdf, also install cups-pdf with `sudo pacman -S cups-pdf` then change the pdf save path by editing the `/etc/cups/cups-pdf.conf` file and in `Path Settings` uncomment the line starting with `Out` and put the output directory you want, for example:

```ini
Out /home/${USER}/Documents
```

- For scanning, install sane and a frontend such as skanpage with `sudo pacman -S sane skanpage` and if it asks which tesseract pack to install, select the one with your language (for optical characters recognition)

- You can install more languages for character recognition with `sudo pacman -S tesseract-data-<lan>` with `<lan>` being the first 3 characters of the language name in lowercase, or you can just `sudo pacman -S tesseract-data` and it will let you choose which one to install

- You can install onlyoffice with `yay -S onlyoffice-bin` to edit various documents

- You can use `libinput` to record and replay macros, to record execute `sudo libinput record <fileName.yaml>` then choose which device to record the activity of, record the macro and press ctrl+c when you're done, then execute `sudo libinput replay <fileName.yaml\>` to replay the recorded macro

- You can find more on macros with libinput here: [https://man.archlinux.org/man/libinput-record.1.en](https://man.archlinux.org/man/libinput-record.1.en)

- To create ascii art easily, install `ascii-draw` with yay

- Install a music player like `gapless` with `yay`, which it also needs `gst-plugins-good` from `pacman`

- To install davinci resolve, follow the steps at [https://wiki.archlinux.org/title/DaVinci_Resolve](https://wiki.archlinux.org/title/DaVinci_Resolve) and apply the wayland fix if necessary (see link)

- You can install `coolercontrol` with `yay` to monitor and configure your computer fan speed, then enable it with `sudo systemctl enable --now coolercontrold`, and reload sensors with `sudo sensors-detect`

- Install a markdown editor such as marktext with `yay -S marktext-bin`

- To make pixel art, install aseprite with `yay -S aseprite`

- You can install a gui to copy special characters with `sudo pacman -S gucharmap`

- For battery management on laptops, install `powerkit` with `yay`

- For a fast download manager, install `freedownloadmanager` with `yay`

- You can use a speech to text program such as nerd-dictation, install it with `yay -S nerd-dictation-git` and configure it, some instructions can be found [here](https://github.com/ideasman42/nerd-dictation).

- Install the snap service with `yay -S snapd` then `sudo systemctl enable --now snapd` and `sudo systemctl enable --now snapd.apparmor`

- For lightweight virtualization and creating virtual machines, install `gnome-boxes` with `pacman`

- For fake usb detection and recovery, install the `f3` tool with `yay`

- To manage wifi from iwctl with a graphical interface, install `iwgtk` with `yay`

- Your should also know that if you need to make changes to any `.desktop` file without them being overwritten after an update, you need to copy those files from `/usr/share/applications/` to `~/.local/share/applications/` (with the `cp` command for example) and then change the file you just copied

## Cosmetic programs

- You can install cava which is a cosmetic terminal music visualizer with `sudo pacman -S cava` and then run it by executing `cava` in a terminal, configure this tool by editing `~/.config/cava/config`, again refer to [my repo](https://github.com/ilwan07/ArchRice), make sure to configure it to use the correct audio process (`pulseaudio` in our case if you followed this guide exactly)

- To have cool colorful pipes running around in a terminal window, install pipes.sh `with yay -S pipes.sh` then run the program by executing `pipes.sh` in a terminal instance

- To replicate the matrix in the terminal, install cmatrix with `sudo pacman -S cmatrix`

- Install a fun terminal aquarium with `sudo pacman -S asciiquarium` and type `asciiquarium` in the terminal to launch it

- For a nice retro terminal app, install it with `sudo pacman -S cool-retro-term`

- Install a clock for your terminal with `yay -S tty-clock` and run it with `tty-clock`
