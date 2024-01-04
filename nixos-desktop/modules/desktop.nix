# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  # Kernel Parameters for Desktop
  #boot.loader.grub.theme = "/boot/grub/themes/nixos/";
  boot.kernelParams = [ 
	"iommu=on" 
	"amd_iommu=on" 
	"amd_pstate=guided" 
	"nowatchdog" 
	"nmi_watchdog=0"	
  ];
  
  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
 
  # User account
  users.users.ja = {
    isNormalUser = true;
    extraGroups = [ "libvirtd" "wheel" "video" "input" "audio" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
     	];
  };

  # for Desktop
  environment.systemPackages = with pkgs; [
    #flatpak
    glxinfo
    obs-studio
	  obs-studio-plugins.obs-vaapi 
	  nvtop-amd
    yt-dlp
    vscodium
    webcord
    
    glxinfo
    libva			
    qt6.qtwayland
    xdg-desktop-portal-hyprland
    #waybar - if want experimental then next line
    #(pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))
    waybar

	qemu_kvm
	virt-manager

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
  };
  
  programs.xwayland.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];
  
  #powerManagement.cpuFreqGovernor = "schedutil";

  networking.hostName = "NixOS";
  
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

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.onShutdown = "shutdown";
  virtualisation.spiceUSBRedirection.enable = true;
  #virtualisation.libvirtd.qemu.package = with pkgs; [
	#qemu_kvm
	#virt-manager
  #];		
  
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load amd and nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["amdgpu"];

  # corectrl (Overclocking AMD GPU's)
  programs.corectrl.enable = true;
  programs.corectrl.gpuOverclock.enable = true;
  programs.corectrl.gpuOverclock.ppfeaturemask = "0xffffffff";
}


