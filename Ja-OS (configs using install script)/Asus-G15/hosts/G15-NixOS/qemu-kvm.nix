# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

## for QEMU-KVM ##
## remember to add user into group libvirtd

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
	#qemu
	virt-manager
	virt-viewer
  ];

  #programs.virt-manager.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;   
}


