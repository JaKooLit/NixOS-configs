# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  # Kernel Parameters for Desktop
  boot = {  
  	kernelParams = [ 
	"iommu=on" 
	"amd_iommu=on" 
	"amd_pstate=guided" 
	"nowatchdog" 
	"nmi_watchdog=0"
	"modprobe.blacklist=sp5100_tco"	
  	];
  
  	# kernel
  	kernelPackages = pkgs.linuxPackages_latest;
  	
  	# kernel modules
  	initrd.kernelModules = [ "amdgpu" ];
  	
  	#loader.grub.theme = "/boot/grub/themes/nixos/";
  };
  
  networking.hostName = "NixOS";
  
  # User account
  users = {
	users.ja = {
    	isNormalUser = true;
    	extraGroups = [ 
			"wheel" 
			"video" 
			"input" 
			"audio"
			"libvirtd" ]; 
    packages = with pkgs; [		
     	];
  	};

	defaultUserShell = pkgs.zsh;
  };

  environment.shells = with pkgs; [ zsh ];
  # for Desktop (all AMD)
  environment.systemPackages = with pkgs; [
	discord
  	fzf
    glxinfo
    krabby
    nvtopPackages.amd
    obs-studio
	obs-studio-plugins.obs-vaapi
    yt-dlp
    vscodium
    
		
    #waybar experimental - next line
    #(pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))


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

  programs = {
	zsh = {
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
      	krabby random --no-title -s;
      	source <(fzf --zsh);
		HISTFILE=~/.zsh_history;
		HISTSIZE=10000;
		SAVEHIST=10000;
		setopt appendhistory;
    	'';
	};
	
	# corectrl (Overclocking AMD GPU's)
	corectrl = {
		enable = true;
		gpuOverclock.enable = true;
		gpuOverclock.ppfeaturemask = "0xffffffff";
		};

  };
  
  powerManagement = {
  	enable = true;
	cpuFreqGovernor = "schedutil";
  };
  
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
    
    # AMD Microcode update
    cpu.amd.updateMicrocode = true;
    
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
  	das_watchdog.enable = false;
  	
  	xserver.videoDrivers = ["amdgpu"];
  	
  	blueman.enable = true;
  	
  	hardware.openrgb.enable = true;
  	hardware.openrgb.motherboard = "amd";
  };

  # For Electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # Flatpak (urghhhh dont really wanted though :( but vscodium dont work
  #services.flatpak.enable = true; 
}


