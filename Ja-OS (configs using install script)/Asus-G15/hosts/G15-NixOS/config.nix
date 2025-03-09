# 💫 https://github.com/JaKooLit 💫 #
# Main default config


# NOTE!!! : Packages and Fonts are configured in packages-&-fonts.nix


{ config, pkgs, host, username, options, lib, inputs, system, ...}: let
  
  inherit (import ./variables.nix) keyboardLayout;
    
  in {
  imports = [
    ./hardware.nix
    ./users.nix
    ./packages-fonts.nix
	  ./qemu-kvm.nix # added for virtualization
    ../../modules/amd-drivers.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
  ];

  # BOOT related stuff
  boot = {
    #kernelPackages = pkgs.linuxPackages_zen; # Kernel
 	kernelPackages = pkgs.linuxPackages_latest; # Kernel

    kernelParams = [
		 "rd.driver.blacklist=nouveau" 
		 "modprobe.blacklist=nouveau" 
		 "nvidia-drm.modeset=1" 
		 "iommu=on" 
		 "amd_iommu=on" 
		 "amd_pstate=active" 
		 "nowatchdog"
		 "modprobe.blacklist=sp5100_tco" 
 	  ];

    # This is for OBS Virtual Cam Support
    #kernelModules = [ "v4l2loopback" ];
    #extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    
    initrd = { 
     availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
     kernelModules = [ ];
    };

    # Needed For Some Steam Games
    #kernel.sysctl = {
    #  "vm.max_map_count" = 2147483642;
    #};

    ## BOOT LOADERS: NOT USE ONLY 1. either systemd or grub  
    # Bootloader SystemD
    #loader.systemd-boot.enable = true;
  
    loader.efi = {
	    efiSysMountPoint = "/efi"; #this is if you have separate /efi partition
	    canTouchEfiVariables = true;
  	  };

    loader.timeout = 1;    
  			
    # Bootloader GRUB
    loader.grub = {
	    enable = true;
	      devices = [ "nodev" ];
	      efiSupport = true;
        gfxmodeBios = "auto";
	      memtest86.enable = true;
	      extraGrubInstallArgs = [ "--bootloader-id=${host}" ];
	      configurationName = "${host}";
  	  	};

    # Bootloader GRUB theme, configure below

    ## -end of BOOTLOADERS----- ##
  
    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
      };
    
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
      };
    
    plymouth.enable = true;
  };

  # GRUB Bootloader theme. Of course you need to enable GRUB above.. duh!
  distro-grub-themes = {
    enable = true;
    theme = "nixos";
  };


  # Extra Module Options
  drivers.amdgpu.enable = true;
  drivers.intel.enable = false;
  drivers.nvidia.enable = true;
  drivers.nvidia-prime = {
    enable = true;
    #amdgpuBusID = "";
    #nvidiaBusID = "";
  };
  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;

  # networking
  networking.networkmanager.enable = true;
  networking.hostName = "${host}";
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Services to start
  services = {
    xserver = {
      enable = false;
      xkb = {
        layout = "${keyboardLayout}";
        variant = "";
      };
    };
    
    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          user = username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland"; # start Hyprland with a TUI login manager
        };
      };
    };
    
    smartd = {
      enable = false;
      autodetect = true;
      };
    
	gvfs.enable = true;
	tumbler.enable = true;

	ayatana-indicators.enable = true;
	pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
	  wireplumber.enable = true;
  	};
    
	pulseaudio.enable = false; #unstable	
	  
	udev.enable = true;
	envfs.enable = true;
	dbus.enable = true;

	fstrim = {
    enable = true;
    interval = "weekly";
    };
  
	libinput.enable = true;

	rpcbind.enable = false;
	nfs.server.enable = false;
  
	openssh.enable = true;
	flatpak.enable = false;
	
	blueman.enable = true;
  	
	# asusctl related
	asusd = {
	  enable = true;
	  enableUserService = true;
     };

	supergfxd.enable = true;
	power-profiles-daemon.enable = true;

	logind = {
	  lidSwitch = "ignore";
	  lidSwitchExternalPower = "ignore";
	  lidSwitchDocked = "ignore";
	 };

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

  #hardware.openrgb.enable = true;
  #hardware.openrgb.motherboard = "amd";

	fwupd.enable = true;

	upower.enable = true;
    
	gnome.gnome-keyring.enable = true;
    

  };
  
  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # zram
  zramSwap = {
	  enable = true;
	  priority = 100;
	  memoryPercent = 30;
	  swapDevices = 1;
    algorithm = "zstd";
    };

  powerManagement = {
  	enable = true;
	  cpuFreqGovernor = "schedutil";
  };

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

	i2c.enable = true;
  };

  # Extra Logitech Support
  hardware.logitech.wireless.enable = false;
  hardware.logitech.wireless.enableGraphical = false;

  # Bluetooth
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
  };

  # Enable sound with pipewire.
  #hardware.pulseaudio.enable = false;

  # Security / Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # Cachix, Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Virtualization / Containers
  #virtualisation.libvirtd.enable = false;
  #virtualisation.podman = {
  #  enable = false;
  #  dockerCompat = false;
  #  defaultNetwork.settings.dns_enabled = false;
  #};

  # OpenGL
  hardware.graphics = {
    enable = true;
  };

  console.keyMap = "${keyboardLayout}";

  # For Electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
