# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, inputs, system,... }:

{
  # Kernel Parameters miniPC
  #boot.loader.grub.theme = "/boot/grub/themes/nixos/";
  boot.kernelParams = [ 
	"nowatchdog"
	"modprobe.blacklist=iTCO_wdt"
 	];
  
  # bootloader grub theme
  boot.loader.grub = rec {
    theme = inputs.distro-grub-themes.packages.${system}.nixos-grub-theme;
    splashImage = "${theme}/splash_image.jpg";
  };

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
	fzf
    glxinfo
	krabby
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
	cpuFreqGovernor = "performance";
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
	krabby random --no-mega --no-gmax --no-regional --no-title -s;
      	source <(fzf --zsh);
	HISTFILE=~/.zsh_history;
	HISTSIZE=10000;
	SAVEHIST=10000;
	setopt appendhistory;
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


