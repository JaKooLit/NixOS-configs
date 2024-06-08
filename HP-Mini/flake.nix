{
  description = "HP-MiniPC flakes!";

  inputs = {
	nixpkgs.url = "nixpkgs/nixos-unstable";
	wallust.url = "git+https://codeberg.org/explosion-mental/wallust?ref=dev";
	#hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; # unstable hyprland
	distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes"; 
  };

  outputs = { self,nixpkgs, ... }@inputs: {
	nixosConfigurations.NixOS-MiniPC = nixpkgs.lib.nixosSystem rec {
	    system = "x86_64-linux";
		specialArgs = { inherit system inputs; };
	    modules = [ ./configuration.nix ];
	  };
	};

}