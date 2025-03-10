# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  ## for QEMU-KVM ##
  ### remember to add user into group libvirtd
  environment.systemPackages = with pkgs; [
	qemu
  ];

  programs.virt-manager.enable = true;
  virtualisation = {
  	libvirtd = {
  		enable = true;
  	qemu = {
  		swtpm.enable = true;
  	  	};
  	};
  	spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
  
}