# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./modules/hardware-configuration.nix
      ./modules/asus-g15.nix
      ./modules/qemu-kvm.nix
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

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "${pkgs.terminus_font}/share/consolefonts/ter-132b.psf.gz";
     keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # NOTE: DEFINE USER ACCOUNT in different module
  
  # Latest Kernel
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  # Unfree softwares
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
  	# System Packages
    baobab
    btrfs-progs
    cpufrequtils
    firewalld
    ffmpeg   
    git
    glib #for gsettings to work   
    libappindicator
    libnotify
    openssl # required by Rainbow borders
    python3
    pipewire  
    vim
    wget
    wireplumber
    xdg-user-dirs

	# I normally have and use
    audacious
    firefox
    mpv
    neofetch
    ranger
	    
	krabby # pokemon colorscripts like
    
    # Hyprland Stuff        
    blueman
    btop
    cava
    cliphist
    dunst
    gnome.eog
    gnome.gnome-system-monitor
    gnome.file-roller
    grim
    gtk-engine-murrine #for gtk themes
    jq
    kitty
    pcmanfm
    networkmanagerapplet
    nwg-look # requires unstable channel
    nvtop
    pamixer
    pavucontrol
    polkit_gnome
    pywal
	qt6Packages.qtstyleplugin-kvantum #kvantum
	libsForQt5.qtstyleplugin-kvantum #kvantum
    slurp
	shotcut
    swappy
    swaybg
    swayidle
    swaylock-effects
    swww
	unzip
    qt5ct
    qt6ct
    rofi-wayland
    wl-clipboard
    wlogout
    yad
  ];

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
	exo
	mousepad
	thunar-archive-plugin
	thunar-volman
	tumbler
  ];
  # for thunar to work better
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # SOUNDS #
  # sound.enable = true; # dont enable for pipewire
  # hardware.pulseaudio.enable = true;  
  # PIPEWIRE
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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
  
  # Programs #
  # dconf
  programs.dconf.enable = true;
    
  # SERVICES #
  # udev
  services.udev.enable = true; 
  #services.udisks2.enable = true;
  services.envfs.enable = true;  
  # Dbus
  services.dbus.enable = true;  
  # Trim For SSD, fstrim.
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Fwupd # Firmware updater
  services.fwupd.enable = true;
  
  # upower
  services.upower.enable = true;
  
  # SECURITY
  # Swaylock
  security.pam.services.swaylock.text = "auth include login";
  security.polkit.enable = true; 
  
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
  systemd.services.firewalld.enable = true; 
  systemd.services.power-profiles-daemon = {
	enable = true;
	wantedBy = [ "multi-user.target" ];
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

  #systemd = {
  #	user.services.polkit-gnome-authentication-agent-1 = {
  #  description = "polkit-gnome-authentication-agent-1";
  #  wantedBy = [ "graphical-session.target" ];
  #  wants = [ "graphical-session.target" ];
  #  after = [ "graphical-session.target" ];
  #  serviceConfig = {
  #      Type = "simple";
  #      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #      Restart = "on-failure";
  #      RestartSec = 1;
  #      TimeoutStopSec = 10;
  #	    };
  #	};
  #};

  # zram
  zramSwap = {
	enable = true;
	priority = 100;
	memoryPercent = 30;
	swapDevices = 1;
  };

  # zram-generator NOTE: add in the packages
  #services.zram-generator = {
    #enable = true;
    #settings = {
	#name = dev;
	#zram-size = "8192";
	#compression-algorithm = "zstd";
	#swap-priority = 100;
	#};
  #};
  
  nix.settings.experimental-features = [ "nix-command"  "flakes" ];
  
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
  system.stateVersion = "23.05"; # Did you read the comment?

}


