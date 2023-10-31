# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./asus-g15.nix
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
	efiSupport = true;
        gfxmodeBios = "auto";
	devices = [ "nodev" ];
	extraGrubInstallArgs = [ "--bootloader-id=NixOS" ];
	configurationName = "NixOS";
  };
  boot.loader.timeout = 1;
 
  # NOTE SET KERNEL BOOTLOADER OPTIONS ON INDIVIDUAL NIX
  
  #networking.hostName = "NixOS-G15"; # Define your hostname.
  # Pick only one of the below networking options.
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
     font = "Lat2-Terminus16";
     keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # NOTE: defined in other module
  #users.users.ja = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" "video" "input" "audio" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     xfce.mousepad
  #     tree
  #   ];
  #};
  
  # Latest Kernel
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  # Unfree softwares
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    audacious
    blueman
    btop
    btrfs-progs
    cava
    cliphist
    dunst
    ffmpeg
    firefox
    foot
    git
    glib #for gsettings to work
    gnome.gnome-system-monitor
    grim
    jq
    libappindicator
    libnotify
    lxqt.pcmanfm-qt
    mpv
    neofetch
    networkmanagerapplet
    nwg-look
    nvtop
    openssl # required by Rainbow borders   
    pamixer
    pavucontrol
    pipewire
    python3
    polkit_gnome
    slurp
    snapper
    supergfxctl
    swaybg
    swayidle
    swaylock-effects
    swww
    qt5ct
    qt6ct
    vim
    wget
    wireplumber
    wl-clipboard
    wofi
    viewnior
    xarchiver
    xdg-user-dirs
    zram-generator
    (pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))
  ];

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
	thunar-archive-plugin
	thunar-volman
	tumbler
  ];
  
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  
  # FONTS
  fonts.packages = with pkgs; [
    noto-fonts
    fira-code
    noto-fonts-cjk
    jetbrains-mono
    font-awesome
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
 ];
  
  # ZSH
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  
  # PIPEWIRE
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  #services.udisks2.enable = true;
  security.polkit.enable = true;
  services.envfs.enable = true;

  # Enable default programs
  programs.dconf.enable = true;
  
  # Dbus
  services.dbus.enable = true;

  # zram
  zramSwap.enable = true;

  # Swaylock
  security.pam.services.swaylock.text = "auth include login";
  
  # Trim For SSD, fstrim.
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Fwupd # Firmware updater
  services.fwupd.enable = true;
   
  # udev
  services.udev.enable = true;
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;
  
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


