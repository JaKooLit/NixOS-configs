# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, inputs, system,... }:

  {
  # Kernel Parameters Desktop
  boot = {
    kernelParams = [
    	"systemd.mask=systemd-vconsole-setup.service"
    	"systemd.mask=dev-tpmrm0.device"
      "nowatchdog"
	   	"modprobe.blacklist=sp5100_tco"
 	  ];
  
    initrd = { 
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
    };
  
    kernelModules = [ ];
    extraModulePackages = [ ];

    # bootloader grub theme
    loader.grub = rec {
      theme = inputs.distro-grub-themes.packages.${system}.nixos-grub-theme;
      splashImage = "${theme}/splash_image.jpg";
    };

    # Kernel 
    kernelPackages = pkgs.linuxPackages_latest;
  };
  
  
  networking.hostName = "NixOS-Desktop";

  # User account
  users = {
	users.ja = {
    isNormalUser = true;
    extraGroups = [ 
		  "wheel" 
		  "video" 
		  "input" 
		  "audio"
		  "libvirtd"
		  "tss"
		]; 
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
    shotcut
    yt-dlp
    vscodium
        
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
  	# Zsh configuration
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
	    krabby random --no-mega --no-gmax --no-regional --no-title -s;
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
    
	graphics = {
    	enable = true;
    	enable32Bit = true;
		  extraPackages = with pkgs; [
   			libva
			  libva-utils	
     		];
  	};

  };  
  
  services = {  	
  	xserver.videoDrivers = ["amdgpu"];
  	
  	blueman.enable = true;
  	
  	hardware.openrgb.enable = true;
  	hardware.openrgb.motherboard = "amd";
  };

  # For Electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  #TPM
  security.tpm2 = {
  	enable = false;
  	pkcs11.enable = false;
  	tctiEnvironment.enable = false;

  };
  
  #services.flatpak.enable = true; 
}


