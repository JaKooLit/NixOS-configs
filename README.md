
<div align="center">
<img src="https://github.com/JaKooLit/Telegram-Animated-Emojis/blob/main/Activity/Sparkles.webp" alt="Sparkles" width="38" height="38" /> My Nixos Configs <img src="https://github.com/JaKooLit/Telegram-Animated-Emojis/blob/main/Activity/Sparkles.webp" alt="Sparkles" width="38" height="38" />
</div>


> [!CAUTION]
> I dont use Home Manager & all my systems are configured with Grub bootloader with separate /efi partition


#### 💥 notes on my Nixos-Hyprland
- GTK themes and icons needs to install manually. Here is the [`LINK`](https://github.com/JaKooLit/GTK-themes-icons)
- Hyprland-Dots [`LINK`](https://github.com/JaKooLit/Hyprland-Dots)
- Installing of Hyprland-Dots how to [`LINK`](https://github.com/JaKooLit/Hyprland-Dots?tab=readme-ov-file#-copying--installation--update-instructions-)
- all my configs are setup with flakes enabled

> [!IMPORTANT]
> ensure to add 'services.envfs.enable = true' in your configuration.nix to use the Hyprland-Dots above 

- see Notes regarding KooL's Hyprland-Dots on Nixos [`LINK`](https://github.com/JaKooLit/Hyprland-Dots/wiki/Other_Distros#-will-this-work-on-nixos)

> [!NOTE]
> I dont use any Log-in Manager. I do utilize ~/.zprofile for auto start for Hyprland

- contents of `~/.zprofile`

```
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
       Hyprland 
fi
```

#### ‼️ TIPS to use these configs
- For the purpose of this tutorial, sample config to use is "Desktop"
- install and configure NixOS with flakes
- copy the configs into your flakes folder
- edit Flakes.nix with your username and Host. NOTE and IMPORTANT, name of CONFIG DIRECTORY SHOULD be SAME as HOST
<p align="center">
    <img align="center" width="100%" src="https://github.com/JaKooLit/NixOS-configs/blob/main/NixOS-Flakes.png" />

- delete the hardware-configuration.nix from the `Desktop-nix` directory.
- copy the hardware-configuration.nix from /etc/nixos/hardware-configuration.nix
- Edit the `configuration.nix` & `desktop.nix`. NOTE and IMPORTANT the Bootloader part.
- once you update and edit as required, ran `sudo nixos-rebuild switch --flake .#<HOSTNAME>` remember to edit HOSTNAME as per your hostname.

#### 🖥️ System Specs
- Asus G15 - AMD 5900HS + Nvidia RTX 3080
- HP-Mini PC - Intel 8500T igpu only
- Desktop - Full AMD (5950X + RX 6900XT)
