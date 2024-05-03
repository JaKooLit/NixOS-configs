# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./modules/hardware-configuration.nix
      ./modules/HP-Mini.nix
      #./asus-g15.nix
      #./qemu-kvm.nix
      #./Desktop.nix
    ];

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
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
	configurationName = "NixOS";
  };
  boot.loader.timeout = 1;
 
  # NOTE SET KERNEL BOOTLOADER OPTIONS and Hostname ON INDIVIDUAL MODULE NIX  
  # networking.hostName = "NixOS"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
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
  environment.systemPackages = with pkgs; [
  	# System Packages
    baobab
    btrfs-progs
    cpufrequtils
    ffmpeg   
    glib #for gsettings to work
    killall   
    libappindicator
    libnotify
    openssl # required by Rainbow borders
    python3
	python311Packages.requests
	sof-firmware 
    vim
    wget
    xdg-user-dirs
	xdg-utils
    
	# I normally have and use
    audacious
	mpv
    neofetch
	hyfetch # neofetch upgraded
        
    # Hyprland Stuff        
    btop
    cava
    cliphist
    gnome.eog
    gnome.gnome-system-monitor
    grim
	hyprcursor # requires unstable channel
	hypridle # requires unstable channel
	hyprlock # requires unstable channel
    jq
    kitty
    libsForQt5.qtstyleplugin-kvantum
    mpvScripts.mpris
    networkmanagerapplet
    nwg-look # requires unstable channel
    pamixer
    pavucontrol
	playerctl
    polkit_gnome
	pyprland
    pywal
    qbittorrent
    qt5ct
    qt6ct #unstable
    qt6Packages.qtstyleplugin-kvantum
	qt6.qtwayland
    ranger
    rofi-wayland
    slurp
    swappy
	swaynotificationcenter
    swww
    unzip
    wl-clipboard
    wlogout
    yad
    yt-dlp

    
	#colorscripts
	#dwt1-shell-color-scripts
	krabby #pokemon colorscripts like
	
	# waybar with experimental
    #(pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))
  ];

  programs = {

	hyprland = {
    	enable = true;
    	xwayland.enable = true;
  	};

  	xwayland.enable = true;
	
	waybar.enable = true;

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

	file-roller.enable = true;

	dconf.enable = true;
  };


  services = {
	# for thunar to work better
  	gvfs.enable = true;
  	tumbler.enable = true;
	
	# pipewire audio
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
  };


  security = {
	rtkit.enable = true;
	pam.services.swaylock.text = "auth include login";
	polkit.enable = true;
	polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';
  };



  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    	xdg-desktop-portal-gtk
		xdg-desktop-portal-hyprland
  ];  
  
  # FONTS
  fonts.packages = with pkgs; [
    noto-fonts
    fira-code
    noto-fonts-cjk
    jetbrains-mono
    font-awesome
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
 ];
  
  powerManagement = {
	enable = true;
	cpuFreqGovernor = "schedutil";
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
  systemd.services.NetworkManager-wait-online.enable = false;
  #systemd.services.firewalld.enable = true; 
  
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
   
  systemd = {
  	user.services.polkit-gnome-authentication-agent-1 = 	{
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
  	};
  };


  # Enable the X11 windowing system.
  # services.xserver.enable = true;  

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


