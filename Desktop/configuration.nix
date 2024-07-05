# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

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
      ./Profiles/Desktop/hardware-configuration.nix
      #./modules/HP-Mini.nix
      #./asus-g15.nix
      ./Profiles/Desktop/qemu-kvm.nix
      ./Profiles/Desktop/desktop.nix
    ];
	
	# bootloader
  boot.loader.efi = {
		efiSysMountPoint = "/efi";
		canTouchEfiVariables = true;
  		};
  boot.loader.grub = {
		enable = true;
		devices = [ "nodev" ];
		efiSupport = true;
  	gfxmodeBios = "auto";
		memtest86.enable = true;
		extraGrubInstallArgs = [ "--bootloader-id=NixOS" ];
		configurationName = "Desktop";
  	};
  boot.loader.timeout = 1;
 
  # NOTE SET KERNEL BOOTLOADER OPTIONS and Hostname ON INDIVIDUAL MODULE NIX  
  networking.networkmanager.enable = true; 

  # Set your time zone.
  time.timeZone = "Asia/Seoul";


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  };

  # NOTE: DEFINE USER ACCOUNT in different module
  
  # Unfree softwares
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command"  "flakes" ];
  
  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = (with pkgs; [
  # System Packages
    baobab
    btrfs-progs
    cpufrequtils
	  duf
    ffmpeg   
    glib #for gsettings to work
	  killall  
    libappindicator
    libnotify
    openssl #required by Rainbow borders
    vim
    wget
    xdg-user-dirs
	  xdg-utils

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
    gnome-system-monitor
    file-roller
    grim
    gtk-engine-murrine #for gtk themes
    hyprcursor # requires unstable channel
    hypridle # requires unstable channel
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
    wl-clipboard
    wlogout
    yad

    #waybar  # if wanted experimental next line
    #(pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))
  ]) ++ [
	  python-packages
	  inputs.wallust.packages.${pkgs.system}.wallust
	  #inputs.ags.packages.${pkgs.system}.ags
  ];

  programs = {
	hyprland = {
    enable = true;
    xwayland.enable = true;
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
	  xdg-desktop-portal-hyprland
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
  	#xserver = {
  	#	enable = true;
  	#	displayManager.gdm.enable = false;
  	#	displayManager.lightdm.enable = false;
  	#	displayManager.lightdm.greeters.gtk.enable = false;
  	#	};
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
    
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  #networking.nftables.enable = true;
  #networking.firewall = {
	#enable = true;
	#allowedTCPPorts = [ 80 443 ];
	#allowedUDPPortRanges = [
	    #{ from = 4000; to = 4007; }
	    #{ from = 8000; to = 8010; }
	    #];
  #};
  #sudo firewall-cmd --add-port=1025-65535/tcp --permanent
  #sudo firewall-cmd --add-port=1025-65535/udp --permanent
      
  # SYSTEMD
  systemd.services = {
	  NetworkManager-wait-online.enable = false;
	  firewalld.enable = true;
	  power-profiles-daemon = {
		  enable = true;
		  wantedBy = [ "multi-user.target" ];
  		};
  }; 

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
      
  # Auto system update
  #  system.autoUpgrade = {
  #  enable = true;
  #  allowReboot = true;
  #    };


  # This is for polkit-gnome BUT IT IS NOT WORKING
  #systemd = {
  #	user.services.polkit-gnome-authentication-agent-1 = {
  #  description = "polkit-gnome-authentication-agent-1";
  #  wantedBy = [ "graphical-session.target" ];
  #  wants = [ "graphical-session.target" ];
  #  after = [ "graphical-session.target" ];
  #  serviceConfig = {
   #     Type = "simple";
   #     ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
   #     Restart = "on-failure";
   #     RestartSec = 1;
   #     TimeoutStopSec = 10;
  #	    };
  #	};
  #};

   
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";  

  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  
    # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}

