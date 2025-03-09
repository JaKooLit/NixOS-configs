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

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = (with pkgs; [
  # System Packages
    ayatana-ido
    baobab
    bc
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
    libnotify
    openssl #required by Rainbow borders
    pciutils
    vim
    wget
    xdg-user-dirs
    xdg-utils
    xorg.xhost

    fastfetch
    (mpv.override {scripts = [mpvScripts.mpris];}) # with tray
      
    # Hyprland Stuff
    ags_1 # desktop overview  
    btop
    brightnessctl # for brightness control
    cava
    cliphist
    gnome-system-monitor
    grim
    gtk-engine-murrine #for gtk themes
    hypridle 
    hyprpolkitagent
    imagemagick 
    inxi
    jq
    kitty
    libsForQt5.qtstyleplugin-kvantum #kvantum
    loupe
    networkmanagerapplet
    nwg-look
    nwg-displays
    #nvtopPackages.amd
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
    xarchiver
    yad   
    yt-dlp

    #waybar  # if wanted experimental next line
    #(pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))

    # Asus G15 additional
    brightnessctl
    discord
    glxinfo
    #krabby
    kdePackages.okular
    libreoffice-fresh
    obs-studio
    pdfarranger
    ranger
    shotcut
    teams-for-linux
    thunderbird
    yt-dlp
    vscodium
    whatsapp-for-linux

    libayatana-appindicator
    libayatana-indicator
    libayatana-common
    indicator-application-gtk3
    indicator-application-gtk3
    libindicator
    libindicator-gtk3
    libappindicator
    libappindicator-gtk3

    (epsonscan2.override { withNonFreePlugins = true; withGui = true; }) 

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
    victor-mono
    #(nerdfonts.override {fonts = ["JetBrainsMono"];}) # stable banch
    nerd-fonts.jetbrains-mono # unstable
    nerd-fonts.fira-code # unstable
    nerd-fonts.fantasque-sans-mono #unstable
 	];

  
  programs = {
	  hyprland = {
        enable = true;
		      #package = pks.hyprland;
 		      #portalPackage = pkgs.xdg-desktop-portal-hyprland; 
		      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; #hyprland-git
		      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; # xdphls
  	      xwayland.enable = true;
      };

	  waybar.enable = true;
	  hyprlock.enable = true;
	  firefox.enable = true;
	  git.enable = true;
    nm-applet.indicator = true;
    #neovim.enable = true;

	  thunar.enable = true;
	  thunar.plugins = with pkgs.xfce; [
		  exo
		  mousepad
		  thunar-archive-plugin
		  thunar-volman
		  tumbler
  	  ];
	
    virt-manager.enable = true;
	  system-config-printer.enable = true;
    
    #steam = {
    #  enable = true;
    #  gamescopeSession.enable = true;
    #  remotePlay.openFirewall = true;
    #  dedicatedServer.openFirewall = true;
    #};
    
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

  users = {
    mutableUsers = true;
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
