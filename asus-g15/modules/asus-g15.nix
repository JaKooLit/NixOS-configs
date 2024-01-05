# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  # Kernel Parameters for Asus G15
  #boot.loader.grub.theme = "/boot/grub/themes/nixos/";
  boot = {
	initrd.kernelModules = [ "amdgpu" ];
	kernelParams = [ 
		"rd.driver.blacklist=nouveau" 
		"modprobe.blacklist=nouveau" 
		"nvidia-drm.modeset=1" 
		"iommu=on" 
		"amd_iommu=on" 
		"amd_pstate=guided" 
		"nowatchdog" ];
	kernelPackages = pkgs.linuxPackages_latest; # Kernel
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
			"libvirtd" ]; 
    packages = with pkgs; [		
     	];
  	};

	defaultUserShell = pkgs.zsh;
  };

  environment.shells = with pkgs; [ zsh ];
  
  # for Asus G15
  environment.systemPackages = with pkgs; [
    #hardware-acceleration
    libva
    libva-utils

	# scanner
	(epsonscan2.override { withNonFreePlugins = true; withGui = true; }) 

    #nvidia-specific hardware acceleration
    libvdpau
    libvdpau-va-gl 
    nvidia-vaapi-driver
    vaapiVdpau
    vdpauinfo

    discord
    glxinfo
    obs-studio
    yt-dlp
    vscodium
			
    brightnessctl
  ];
  
  powerManagement = {
	enable = true;
	cpuFreqGovernor = "ondemand";
  };
    
  # Zsh configuration
  programs.zsh = {
    enable = true;
	enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
        theme = "fino-time";
      };
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
  };

  services = {
	asusd = {
      enable = true;
      enableUserService = true;
    };

	supergfxd.enable = true;
	power-profiles-daemon.enable = true;

	xserver.libinput.enable = true; # for touchpad support

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
		enable = true; # necessary for network printing
		nssmdns4 = true;
		openFirewall = true;
	};

	blueman.enable = true;

	#flatpak.enable = true;

	xserver.videoDrivers = ["nvidia" "amdgpu"]; 
  };
  
  # Bluetooth, video card..
  hardware = {
	cpu.amd.updateMicrocode = true;

	bluetooth.enable = true;
	bluetooth.powerOnBoot = true;
	bluetooth.settings = {
		General = {
		Enable = "Source,Sink,Media,Socket";
		};
	};
	
	opengl = {
    	enable = true;
    	driSupport = true;
    	driSupport32Bit = true;
  		};

	nvidia = {
    	prime.amdgpuBusId = "PCI:7:0:0";
    	prime.nvidiaBusId = "PCI:1:0:0";
    	modesetting.enable = true;
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
  #environment.sessionVariables.NIXOS_OZONE_WL = "1";
}


