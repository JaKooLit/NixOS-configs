# 💫 https://github.com/JaKooLit 💫 #
# Packages and Fonts config

{ pkgs, inputs, ...}: let

  python-packages = pkgs.python3.withPackages (
    ps:
      with ps; [
        requests
        pyquery # needed for hyprland-dots Weather script
        ]
    );

  in {
  environment.systemPackages = (with pkgs; [
  # System Packages
    baobab
    btrfs-progs
    clang
    curl
    cpufrequtils
    duf
    eza
    ffmpeg   
    glib #for gsettings to work
    gsettings-qt
    git
    killall  
    libappindicator
    libnotify
    openssl #required by Rainbow borders
    pciutils
    vim
    wget
    xdg-user-dirs
    xdg-utils

    fastfetch
    (mpv.override {scripts = [mpvScripts.mpris];}) # with tray
    #ranger
      
    # Hyprland Stuff
    #(ags.overrideAttrs (oldAttrs: {
    #    inherit (oldAttrs) pname;
    #    version = "1.8.2";
    #  }))
    ags    
    btop
    brightnessctl # for brightness control
    cava
    cliphist
    eog
	file-roller
    gnome-system-monitor
    grim
    gtk-engine-murrine #for gtk themes
    hyprcursor # requires unstable channel
    hypridle # requires unstable channel
    imagemagick 
    inxi
    jq
    kitty
    libsForQt5.qtstyleplugin-kvantum #kvantum
    networkmanagerapplet
    nwg-look # requires unstable channel
    nvtopPackages.full
    pamixer
    pavucontrol
    playerctl
    polkit_gnome
    pyprland
    libsForQt5.qt5ct
    kdePackages.qt6ct
    kdePackages.qtwayland
    kdePackages.qtstyleplugin-kvantum #kvantum
    rofi-wayland
    slurp
    swappy
    swaynotificationcenter
    swww
    unzip
    wallust
    wl-clipboard
    wlogout
	#xarchiver
    yad
    yt-dlp

	#added to miniPC
	audacious
	discord-canary
	gparted
	qbittorrent
	ranger
	vscodium

    #waybar  # if wanted experimental next line
    #(pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))
  ]) ++ [
	python-packages
  ];

  # FONTS
  fonts.packages = with pkgs; [
    noto-fonts
    fira-code
    noto-fonts-cjk-sans
    jetbrains-mono
    font-awesome
	terminus_font
    nerd-fonts.jetbrains-mono
	nerd-fonts.fira-code
 	];

  nixpkgs.config.allowUnfree = true;
  
  programs = {
	hyprland = {
     enable = true;
     	#package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; #hyprland-git
     	portalPackage = pkgs.xdg-desktop-portal-hyprland; # xdph
  	  xwayland.enable = true;
      };

	
	waybar.enable = true;
	hyprlock.enable = true;
	firefox.enable = true;
	git.enable = true;
    nm-applet.indicator = true;
    neovim.enable = true;

	thunar.enable = true;
	thunar.plugins = with pkgs.xfce; [
	  exo
	  mousepad
	  thunar-archive-plugin
	  thunar-volman
	  tumbler
  	  ];
	
    virt-manager.enable = false;
    
    xwayland.enable = true;

    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
	
  };  

  # Extra Portal Configuration
  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
  };

}
