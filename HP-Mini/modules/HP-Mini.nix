# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  # Kernel Parameters miniPC
  #boot.loader.grub.theme = "/boot/grub/themes/nixos/";
  boot.kernelParams = [ "nowatchdog" ];
  
  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
 
  users.users.ja = {
  	isNormalUser = true;
  	extraGroups = [ "wheel" "video" "input" "audio" ]; # Enable ‘sudo’ for the user.
  	packages = with pkgs; [
    	pywal
    	xfce.mousepad
    	tree
  	];
  };

  # for HP - Mini pc
  environment.systemPackages = with pkgs; [
    #flatpak
    glxinfo
    #obs-studio
    yt-dlp
    vscodium
    webcord

    #hardware-acceleration
    libva
    libva-utils
			
    # Hyprland to work well
    nvtop-intel
    qt6.qtwayland
    xdg-desktop-portal-hyprland
    #waybar - if want experimental then next line
    #(pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))
    waybar
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  
  programs.xwayland.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];
  
  networking.hostName = "NixOS-MiniPC";
  
  # ZSH
  programs.zsh = {
	enable = true;
	enableCompletion = true;
	};
  
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;
    
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

  # Intel Microcode update
  hardware.cpu.intel.updateMicrocode = true;
  
  ### GPU STUFF ##
  ## AMD GPU
  #boot.initrd.kernelModules = [ "amdgpu" ];
  
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load intel drivers for Xorg and Wayland
  services.xserver.videoDrivers = ["intel"];

}


