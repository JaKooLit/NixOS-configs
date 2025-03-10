# Main default config

{ config, pkgs, host, username, options, lib, inputs, system, ...}: let
  inherit (import ./variables.nix) keyboardLayout;
   python-packages = pkgs.python3.withPackages (
    ps:
      with ps; [
        requests
        pyquery # needed for hyprland-dots Weather script
        ]
    );
  
  in {
  imports = [
    ./hardware.nix
    ./users.nix
    ./packages-fonts.nix
	  ./qemu-kvm.nix
    ../../modules/amd-drivers.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
  ];

  # BOOT related stuff
  boot = {
    kernelPackages = pkgs.linuxPackages_latest; # Kernel

    kernelParams = [
      "systemd.mask=systemd-vconsole-setup.service"
      "systemd.mask=dev-tpmrm0.device" #this is to mask that stupid 1.5 mins systemd bug
 	  "iommu=on" 
	  "amd_iommu=on" 
	  "amd_pstate=active" 
	  "nowatchdog"
	  "modprobe.blacklist=sp5100_tco" 
 	  ];

    # This is for OBS Virtual Cam Support
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    
    initrd = { 
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
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
  drivers.nvidia.enable = false;
  drivers.nvidia-prime = {
    enable = false;
    intelBusID = "";
    nvidiaBusID = "";
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

	pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
	  wireplumber.enable = true;
  	  };
	
	udev.enable = true;
	envfs.enable = true;
	dbus.enable = true;

	fstrim = {
      enable = true;
      interval = "weekly";
      };
  
    libinput.enable = false;

    rpcbind.enable = false;
    nfs.server.enable = false;
  
    openssh.enable = false;
    flatpak.enable = false;
	
  	blueman.enable = true;
  	
  	hardware.openrgb.enable = true;
  	hardware.openrgb.motherboard = "amd";

	fwupd.enable = true;

	upower.enable = true;
	
	pulseaudio.enable = false; # unstable Feb 2025
    
    #printing = {
    #  enable = false;
    #  drivers = [
        # pkgs.hplipWithPlugin
    #  ];
    #};
    
    gnome.gnome-keyring.enable = true;
    
    #avahi = {
    #  enable = true;
    #  nssmdns4 = true;
    #  openFirewall = true;
    #};
    
    #ipp-usb.enable = true;
    
    #syncthing = {
    #  enable = false;
    #  user = "${username}";
    #  dataDir = "/home/${username}";
    #  configDir = "/home/${username}/.config/syncthing";
    #};
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
  
  #hardware.sane = {
  #  enable = true;
  #  extraBackends = [ pkgs.sane-airscan ];
  #  disabledDefaultBackends = [ "escl" ];
  #};



  # hardware stuff
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

    # AMD Microcode update
    cpu.amd.updateMicrocode = true;
	#pulseaudio.enable = false; #disabled in unstable Feb 2025

  	# Extra Logitech Support
	logitech.wireless.enable = false;
	logitech.wireless.enableGraphical = false;
  };

  # SYSTEMD
  systemd.services = {
	  NetworkManager-wait-online.enable = false;
	  firewalld.enable = true;
	  power-profiles-daemon = {
		  enable = true;
		  wantedBy = [ "multi-user.target" ];
  		};
  };

  # Masking sleep, hibernate, suspend
  systemd = {
	  targets = {
	    sleep = {
	    enable = false;
	    unitConfig.DefaultDependencies = "no";
  		};
	    suspend = {
	    enable = false;
	    unitConfig.DefaultDependencies = "no";
		  };
	    hibernate = {
	    enable = false;
	    unitConfig.DefaultDependencies = "no";
		  };
	    "hybrid-sleep" = {
	    enable = false;
	    unitConfig.DefaultDependencies = "no";
		  };
	  };
  };

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
  virtualisation.libvirtd.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.spiceUSBRedirection.enable = true;
  
  services.spice-vdagentd.enable = true;

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
  system.stateVersion = "24.05"; # Did you read the comment?
}