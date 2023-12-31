# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/0bbe3967-c1e1-442b-97ca-54c60b0effc5";
      fsType = "btrfs";
      options = [ "noatime" "compress=zstd:4" "ssd" "discard=async" "space_cache=v2" "subvol=root" ];
    };

  fileSystems."/efi" =
    { device = "/dev/disk/by-uuid/B39B-9ABD";
      fsType = "vfat";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/9c6f7389-833b-4a2a-92f9-eec3e29aa919";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/0bbe3967-c1e1-442b-97ca-54c60b0effc5";
      fsType = "btrfs";
      options = [ "noatime" "compress=zstd:4" "ssd" "discard=async" "space_cache=v2" "subvol=home" ];
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/0bbe3967-c1e1-442b-97ca-54c60b0effc5";
      fsType = "btrfs";
      options = [ "noatime" "compress=zstd:4" "ssd" "discard=async" "space_cache=v2" "subvol=var" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/0bbe3967-c1e1-442b-97ca-54c60b0effc5";
      fsType = "btrfs";
      options = [ "noatime" "compress=zstd:4" "ssd" "discard=async" "space_cache=v2" "subvol=nix" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/672859bf-0fc2-45bb-877b-4bd222f4ba2c"; }
    ];

  fileSystems."/home/ja/00shared-drives/shared-1TB" =
    { device = "/dev/disk/by-uuid/8f80f828-1642-4e98-8f65-a8c681215e6f";
      fsType = "ext4";
    };

  fileSystems."/home/ja/00shared-drives/shared-500G" =
    { device = "/dev/disk/by-uuid/2c88e4ba-39e2-41d1-a88e-92d794b13baf";
      fsType = "ext4";
    };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
