# 💫 https://github.com/JaKooLit 💫 #
# Packages and Fonts config including the "programs" options

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
	  bc
    baobab
    btrfs-progs
    clang
    curl
    cpufrequtils
    duf
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
     #   inherit (oldAttrs) pname;
     #   version = "1.9.0";
     # }))
    ags_1 #for Desktop overview  
    btop
    brightnessctl # for brightness control
    cava
    cliphist
    eog
    gnome-system-monitor
    grim
    gtk-engine-murrine #for gtk themes
    hypridle # requires unstable channel
    imagemagick 
    inxi
    jq
    kitty
    libsForQt5.qtstyleplugin-kvantum #kvantum
    networkmanagerapplet
    nwg-look
	  nwg-displays
    #nvtopPackages.full	 
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

	#added for desktop
    discord
    glxinfo
    #krabby
    nvtopPackages.amd
    obs-studio
    obs-studio-plugins.obs-vaapi
    ranger
    shotcut
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
    victor-mono
    #(nerdfonts.override {fonts = ["JetBrainsMono"];}) # stable banch
    nerd-fonts.jetbrains-mono # unstable
    nerd-fonts.fira-code # unstable
    nerd-fonts.fantasque-sans-mono # unstable
 	];
  
  programs = {
	  hyprland = {
      enable = true;
		    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; #hyprland-git
			portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; #xdph-development
		    #portalPackage = pkgs.xdg-desktop-portal-hyprland;
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
