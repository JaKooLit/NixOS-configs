# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  # Kernel Parameters miniPC
  #boot.loader.grub.theme = "/boot/grub/themes/nixos/";
  boot.kernelParams = [ 
	"nowatchdog"
	"modprobe.blacklist=iTCO_wdt"
 	];
  
  # Kernel 
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "NixOS-MiniPC";
  
  # User account
  users = {
	users.ja = {
    	isNormalUser = true;
    	extraGroups = [ 
			"wheel" 
			"video" 
			"input" 
			"audio"
			 ]; 
    packages = with pkgs; [		
     	];
  	};

	defaultUserShell = pkgs.zsh;
  };

  environment.shells = with pkgs; [ zsh ];

  # for HP - Mini pc
  environment.systemPackages = with pkgs; [
    glxinfo
    vscodium
    webcord
	nvtopPackages.intel # requires unstable channel
  ];
  # Additional fonts needed for office stuff
  fonts.packages = with pkgs; [
	cascadia-code
 	];
	
  powerManagement = {
	enable = true;
	cpuFreqGovernor = "schedutil";
  };
    
  # Zsh configuration
  programs.zsh = {
    enable = true;
	enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
        theme = "xiong-chiamiov-plus";
      	};
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    promptInit = ''
      fastfetch --config ~/.config/fastfetch/config-compact.jsonc;
    '';
  };
  
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
			Experimental = true;
			};
		};
	};

	cpu.intel.updateMicrocode = true;

	opengl = {
    	enable = true;
    	driSupport = true;
    	driSupport32Bit = true;
		extraPackages = with pkgs; [
   			libva
			libva-utils	
     		];
  	};

  }; 

  services = {
	watchdogd.enable = false; # watchdog
	blueman.enable = true;

	xserver.videoDrivers = ["intel"];

	#flatpak.enable = true;
  };
  
	
  # For Electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
}


