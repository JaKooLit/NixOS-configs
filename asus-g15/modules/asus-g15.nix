# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  # Kernel Parameters for Asus G15
  #boot.loader.grub.theme = "/boot/grub/themes/nixos/";
  boot = {
	kernelPackages = pkgs.linuxPackages_latest; # Kernel
	initrd.kernelModules = [ "amdgpu" ];
	kernelParams = [ 
		"rd.driver.blacklist=nouveau" 
		"modprobe.blacklist=nouveau" 
		"nvidia-drm.modeset=1" 
		"iommu=on" 
		"amd_iommu=on" 
		"amd_pstate=guided" 
		"nowatchdog"
		"modprobe.blacklist=sp5100_tco" 
		];
  };

  networking.hostName = "NixOS-G15";

  # User account
  users = {
	users.ja = {
    	isNormalUser = true;
    	extraGroups = [ 
			"wheel" 
			"video" 
			"input" 
			"audio"
			"scanner" 
			"lp" 
			"libvirtd" ]; 
    packages = with pkgs; [		
     	];
  	};

	defaultUserShell = pkgs.zsh;
  };

  environment.shells = with pkgs; [ zsh ];
  
  # for Asus G15
  environment.systemPackages = with pkgs; [
	autoAddDriverRunpath
	brightnessctl
    discord
	fzf
    glxinfo
	krabby
    libreoffice-fresh
	librewolf
    obs-studio
    thunderbird
    yt-dlp
    vscodium
    (epsonscan2.override { withNonFreePlugins = true; withGui = true; }) 
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
      	krabby random --no-title -s;
      	source <(fzf --zsh);
		HISTFILE=~/.zsh_history;
		HISTSIZE=10000;
		SAVEHIST=10000;
		setopt appendhistory;
    '';
  };

  # for printer
  programs.system-config-printer.enable = true;

  services = {
	asusd = {
      	enable = true;
      	enableUserService = true;
    };

	supergfxd.enable = true;
	power-profiles-daemon.enable = true;

	libinput.enable = true; # for touchpad support

	logind.lidSwitch = "ignore";
	logind.lidSwitchExternalPower = "ignore";
	logind.lidSwitchDocked = "ignore";

	printing = {
		enable = true;
		drivers = with pkgs; [
			epson-escpr
			epson-escpr2			
			];
  		};
	
	avahi = {
		enable = true; # necessary for network printing / scanning
		nssmdns4 = true;
		openFirewall = true;
      	publish = {
        	enable = true;
        	addresses = true;
        	userServices = true;
      		};
		};

	blueman.enable = true;

	xserver.videoDrivers = ["nvidia" "amdgpu"]; 
  };
  
  # Bluetooth, video card, scanner..
  hardware = {
	cpu.amd.updateMicrocode = true;

	# for network scanner
	sane = {
		enable = true;
		extraBackends = [
			pkgs.epsonscan2
		];
		disabledDefaultBackends = ["escl"];
  		};

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


	opengl = {
    	enable = true;
    	driSupport = true;
    	driSupport32Bit = true;
		extraPackages = with pkgs; [
			vaapiVdpau
    		libvdpau
    		libvdpau-va-gl 
    		nvidia-vaapi-driver
    		vdpauinfo
			libva
    		libva-utils		
     		];
  		};

	nvidia = {
    	prime.amdgpuBusId = "PCI:7:0:0";
    	prime.nvidiaBusId = "PCI:1:0:0";
    	modesetting.enable = true;
		prime.offload.enable =true;
    	# Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    	powerManagement = {
			enable = true;
		};
    	# Fine-grained power management. Turns off GPU when not in use.
    	# Experimental and only works on modern Nvidia GPUs (Turing or newer).
    	#powerManagement.finegrained = true;
    	
    	dynamicBoost.enable = true; # Dynamic Boost

    	nvidiaPersistenced = false;
    	# Use the NVidia open source kernel module (not to be confused with the
    	# independent third-party "nouveau" open source driver).
    	open = false;

    	nvidiaSettings = true;
    	package = config.boot.kernelPackages.nvidiaPackages.stable;
  		};
  };

  # For Electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}


