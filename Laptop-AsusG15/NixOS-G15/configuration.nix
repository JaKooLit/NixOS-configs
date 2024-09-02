# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, inputs, ... }: let
  python-packages = pkgs.python3.withPackages (
    ps:
      with ps; [
        requests
        pyquery # needed for hyprland-dots Weather script
      ]
  	);
  in {
  imports =
    [ # Include the results of the hardware scan.
	  ./Asus-G15.nix
	  ./qemu-kvm.nix
      ./hardware-configuration.nix
    ];

  # bootloader GRUB
  boot.loader = {
    efi = {
		  efiSysMountPoint = "/efi"; # MAKE SURE to comment this out if you did not set a /efi partition
		canTouchEfiVariables = true;
  		};
    grub = {
		enable = true;
		devices = [ "nodev" ];
		efiSupport = true;
  	  	gfxmodeBios = "auto";
		memtest86.enable = true;
		extraGrubInstallArgs = [ "--bootloader-id=NixOS" ];
		configurationName = "Asus-G15";
  		};
	  timeout = 1;
  };

    # default systemd-boot (make sure to comment out above if wanted to use systemd-boot)
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = (with pkgs; [
  # System Packages
    baobab
    btrfs-progs
    cpufrequtils
    duf
    ffmpeg   
    glib #for gsettings to work
    hwdata # for fastfetch
    hyfetch
    inxi  
    libappindicator
    libnotify
    openssl #required by Rainbow borders
    vim
    wget
    xdg-user-dirs

    # I normally have and use
    audacious
    fastfetch
    (mpv.override {scripts = [mpvScripts.mpris];}) # with tray
    ranger
      
    # Hyprland Stuff | Laptop related stuff on a separate .nix
	ags      
    btop
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
    qt5ct
    qt6ct
    qt6.qtwayland
    qt6Packages.qtstyleplugin-kvantum #kvantum
    rofi-wayland
    slurp
    swappy
    swaynotificationcenter
    swww
    unzip
	wallust
    wl-clipboard
    wlogout
    yad
    #(pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))
    ]) ++ [
	  #inputs.wallust.packages.${pkgs.system}.wallust #dev
	  python-packages # needed for Weather.py 
  ];

  # enabling Cachix for hyprland on nixos with flakes
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  programs = {
	hyprland = {
    	enable = true;
    	# set the flake package
    	package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    	# make sure to also set the portal package, so that they are in sync
    	portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  	};

	xwayland.enable = true;

	hyprlock.enable = true;
	firefox.enable = true;
	git.enable = true;

	thunar.enable = true;
	thunar.plugins = with pkgs.xfce; [
		exo
		mousepad
		thunar-archive-plugin
		thunar-volman
		tumbler
  		];
	
	dconf.enable = true;
	
	waybar.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    	xdg-desktop-portal-gtk
		#xdg-desktop-portal-hyprland
  ];
  
  services = {
	gvfs.enable = true;
	tumbler.enable = true;

	pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
	  wireplumber.enable = true;
  	  };
	
	udev.enable = true;
	envfs.enable = true;
	dbus.enable = true;

	fstrim = {
     	enable = true;
    	interval = "weekly";
  		};

	  fwupd.enable = true;

	  upower.enable = true;	

  # Services X11 
  #	xserver = {
  #		enable = false;
  #		displayManager.gdm.enable = false;
  #		displayManager.lightdm.enable = false;
  #		displayManager.lightdm.greeters.gtk.enable = false;
  #		};
 	#  desktopManager = {
 	#	  plasma6.enable = false;
 	#	  };
 	#  displayManager.sddm.enable = false;	
  
  };

 	# FONTS
  fonts.packages = with pkgs; [
    noto-fonts
    fira-code
    noto-fonts-cjk
    jetbrains-mono
    font-awesome
	terminus_font
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];
  
  security = {
	pam.services.swaylock.text = "auth include login";
	polkit.enable = true;
	rtkit.enable = true;
  };
          
  # SYSTEMD
  systemd.services = {
	  NetworkManager-wait-online.enable = false;
	  firewalld.enable = true;
	  power-profiles-daemon = {
		  enable = true;
		  wantedBy = [ "multi-user.target" ];
  		};
  }; 

  # flatpak
	#flatpak.enable = true;
  #systemd.services.flatpak-repo = {
  #  wantedBy = [ "multi-user.target" ];
  #  path = [ pkgs.flatpak ];
  #  script = ''
  #    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  #  '';
  #};

  # Masking sleep, hibernate, suspend.. etc
  systemd = {
		targets = {
		  sleep = {
		  enable = false;
		  unitConfig.DefaultDependencies = "no";
  	  	};
		  suspend = {
		  enable = false;
		  unitConfig.DefaultDependencies = "no";
		  };
		  hibernate = {
		  enable = false;
		  unitConfig.DefaultDependencies = "no";
		  };
		  "hybrid-sleep" = {
		  enable = false;
		  unitConfig.DefaultDependencies = "no";
		    };
	    };
  };

  # zram
  zramSwap = {
	  enable = true;
	  priority = 100;
	  memoryPercent = 30;
	  swapDevices = 1;
  };

  # Automatic Garbage Collection
  nix.gc = {
	automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
     };
      
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

