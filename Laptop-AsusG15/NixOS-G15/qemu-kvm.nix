# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

## for QEMU-KVM ##
## remember to add user into group libvirtd

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
	qemu_kvm
  ];

  programs.virt-manager.enable = true;

  virtualisation = {
	libvirtd.enable = true;
	spiceUSBRedirection.enable = true;
  };    
}


