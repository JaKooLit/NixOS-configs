### My Nixos Configs

> [!NOTE]
> I dont use Home Manager

#### notes on my Nixos-Hyprland
- GTK themes are install manually. Here is the [`LINK`](https://github.com/JaKooLit/GTK-themes-icons)
- Hyprland-Dots [`LINK`](https://github.com/JaKooLit/Hyprland-Dots)
- Installing of Hyprland-Dots how to [`LINK`](https://github.com/JaKooLit/Hyprland-Dots?tab=readme-ov-file#-copying--installation--update-instructions-)
- Some Notes regarding Hyprland-Dots for Nixos [`LINK`](https://github.com/JaKooLit/Hyprland-Dots?tab=readme-ov-file#-copying--installation--update-instructions-)


> [!NOTE]
> I dont use any Log-in Manager. I do utilize ~/.zprofile for auto start for Hyprland
- ~/.zprofile
```
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
       Hyprland 
fi
```


System Specs
- Asus G15 - AMD CPU + Nvidia Discreet GPU
- HP-Mini PC - Intel 8500T igpu only
- Desktop - Full AMD
