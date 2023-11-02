# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  # Kernel Parameters for Asus G15
  boot.loader.grub.theme = "/boot/grub/themes/nixos/";
  boot.kernelParams = [ "rd.driver.blacklist=nouveau" "modprobe.blacklist=nouveau" "nvidia-drm.modeset=1" "iommu=on" "amd_iommu=on" "amd_pstate=guided" "nowatchdog" ];
  
  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
 
  # User account
  users.users.ja = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "input" "audio" "libvirtd" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [	
		xfce.mousepad
		tree	
     	];
  };

  # for Asus G15
  environment.systemPackages = with pkgs; [
    asusctl
    supergfxctl

	#hardware-acceleration
    libva
	libva-utils

	#nvidia-specific hardware acceleration
	libvdpau
	libvdpau-va-gl 
    nvidia-vaapi-driver
	vaapiVdpau
    vdpauinfo

    #flatpak
    glxinfo
    obs-studio
    yt-dlp
    vscodium
    webcord
			
    # Hyprland to work well
    brightnessctl
    qt6.qtwayland
    xdg-desktop-portal-hyprland
    #waybar
    (pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))

    #gaming stuff
    gamemode
    goverlay
    lutris
    mangohud
    protonup-qt
    steam-small
    vkbasalt
    wineWowPackages.minimal
    winetricks
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true;
  };
  
  programs.xwayland.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];
  
  powerManagement.cpuFreqGovernor = "schedutil";

  networking.hostName = "NixOS-G15";
  
  # ZSH
  programs.zsh = {
	enable = true;
	enableCompletion = true;
	};
  
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  
  # Asusctl and Supergfxctl
  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
  
  services.supergfxd.enable = true;

  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";
  services.logind.lidSwitchDocked = "ignore";
  
  # BLUETOOTH
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;
  hardware.bluetooth.settings = {
      General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };
  
  # For Electron apps to use wayland
  #environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # Flatpak (urghhhh dont really wanted though :( but vscodium dont work
  #services.flatpak.enable = true; 

  # AMD Microcode update
  hardware.cpu.amd.updateMicrocode = true;
  
  ### GPU STUFF ##
  ## AMD GPU
  boot.initrd.kernelModules = [ "amdgpu" ];
  
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load amd and nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia" "amdgpu"];

  hardware.nvidia = {
    prime.amdgpuBusId = "PCI:7:0:0";
    prime.nvidiaBusId = "PCI:1:0:0";
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    #powerManagement.finegrained = true;
    # Dynamic Boost
    dynamicBoost.enable = true;

    nvidiaPersistenced = false;
    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    open = false;

    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

}


