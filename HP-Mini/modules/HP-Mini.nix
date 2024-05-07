# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  # Kernel Parameters miniPC
  #boot.loader.grub.theme = "/boot/grub/themes/nixos/";
  boot.kernelParams = [ "nowatchdog" ];
  
  # Kernel 
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "NixOS-MiniPC";
  
  users.users.ja = {
  	isNormalUser = true;
  	extraGroups = [ "wheel" "video" "input" "audio" ]; # Enable ‘sudo’ for the user.
	shell = pkgs.zsh;
  	packages = with pkgs; [
  	];
  };

  # for HP - Mini pc
  environment.systemPackages = with pkgs; [
    #flatpak
    glxinfo
    #obs-studio
    vscodium
    webcord

    #hardware-acceleration
    libva
    libva-utils

	nvtopPackages.intel #unstable
  ];
  
  # ZSH
  programs.zsh = {
	enable = true;
	enableCompletion = true;
  };
  
  #users.defaultUserShell = pkgs.zsh;
  #environment.shells = with pkgs; [ zsh ];
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;
    
  # HARDWARES:
  hardware = {
	bluetooth = {
			enable = true;
			powerOnBoot = true;
		settings = {
      		General = {
      		Enable = "Source,Sink,Media,Socket";
    		};
  		};
	};

	cpu.intel.updateMicrocode = true;

	opengl = {
    	enable = true;
    	driSupport = true;
    	driSupport32Bit = true;
  	};

  }; 

  services = {
	watchdogd.enable = false; # watchdog
	blueman.enable = true;

	xserver.videoDrivers = ["intel"];

	#flatpak.enable = true;
  };
  
	
  # For Electron apps to use wayland
  #environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
}


