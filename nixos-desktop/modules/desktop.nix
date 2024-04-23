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
  	];
  
  	# kernel
  	kernelPackages = pkgs.linuxPackages_latest;
  	
  	# kernel modules
  	initrd.kernelModules = [ "amdgpu" ];
  	
  	#loader.grub.theme = "/boot/grub/themes/nixos/";
  };
  
  # User account
  users = {
  	users.ja = {
    	isNormalUser = true;
    	extraGroups = [ "libvirtd" "wheel" "video" "input" "audio" ]; # Enable ‘sudo’ for the user.
    	packages = with pkgs; [
     	];
  	};
  	
  	#zsh
  	defaultUserShell = pkgs.zsh;
  };

  networking.hostName = "NixOS";
  
  environment.shells = with pkgs; [ zsh ];

  # for Desktop (all AMD)
  environment.systemPackages = with pkgs; [
    glxinfo
	#gst_all_1.gstreamer
	#gst_all_1.gst-libav
	#gst_all_1.gst-plugins-base
    #gst_all_1.gst-plugins-good
    #gst_all_1.gst-plugins-bad
    #gst_all_1.gst-plugins-ugly
	#gst_all_1.gst-vaapi # necessary for obs-vaapi
    obs-studio
	obs-studio-plugins.obs-vaapi
	#obs-studio-plugins.obs-gstreamer
	nvtopPackages.amd
    yt-dlp
    vscodium
    webcord
    
    glxinfo
    libva1
	libva-utils			
    #waybar experimental - next line
    #(pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))


    #gaming stuff
    #gamemode
    #goverlay
    #lutris
    #mangohud
    #protonup-qt
    #steam-small
    #vkbasalt
    #wineWowPackages.minimal
    #winetricks
  ];
  
  programs = {
	zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestions.enable = true;
		syntaxHighlighting.enable = true;
		ohMyZsh = {
			enable = true;
			plugins = [ "git" ];
			theme = "xiong-chiamiov-plus";
			};
	};
	
	# corectrl (Overclocking AMD GPU's)
	corectrl = {
		enable = true;
		gpuOverclock.enable = true;
		gpuOverclock.ppfeaturemask = "0xffffffff";
		};

  };
  
  #powerManagement.cpuFreqGovernor = "schedutil";
  
  hardware = {
  	bluetooth.enable = true;
  	bluetooth.powerOnBoot = true;
  	bluetooth.settings = {
      General = {
      	Enable = "Source,Sink,Media,Socket";
    	};
    };
    
    # AMD Microcode update
    cpu.amd.updateMicrocode = true;
    
    opengl = {
    	enable = true;
    	driSupport = true;
    	driSupport32Bit = true;
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
  #environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # Flatpak (urghhhh dont really wanted though :( but vscodium dont work
  #services.flatpak.enable = true; 
}


