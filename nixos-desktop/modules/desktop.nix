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
    #flatpak
    glxinfo
	gst_all_1.gstreamer
	gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
	gst_all_1.gst-vaapi # necessary for obs-vaapi
    obs-studio
	obs-studio-plugins.obs-vaapi 
	nvtop-amd
    yt-dlp
    vscodium
    webcord
    
    glxinfo
    libva1
	libva-utils			
    #waybar - if want experimental then next line
    #(pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))
    waybar

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
		};
	
	# corectrl (Overclocking AMD GPU's)
	corectrl = {
		enable = true;
		gpuOverclock.enable = true;
		gpuOverclock.ppfeaturemask = "0xffffffff";
		};
  };
  
  #powerManagement.cpuFreqGovernor = "schedutil";
  
  # OpenRGB
  #services.hardware.openrgb.motherboard = amd;
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  #services.xserver.libinput.enable = true;
  
  
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
  };

  # For Electron apps to use wayland
  #environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # Flatpak (urghhhh dont really wanted though :( but vscodium dont work
  #services.flatpak.enable = true; 
}


