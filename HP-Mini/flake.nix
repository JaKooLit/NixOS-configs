{
  description = "HP-MiniPC flakes!";

  inputs = {
	nixpkgs.url = "nixpkgs/nixos-unstable";
	wallust.url = "git+https://codeberg.org/explosion-mental/wallust?ref=dev";
	#hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; # unstable hyprland
	#ags.url = "github:Aylur/ags"; 
  };

  outputs = { self,nixpkgs, ... }@inputs: {
	nixosConfigurations.NixOS-MiniPC = nixpkgs.lib.nixosSystem {
	    system = "x86_64-linux";
		specialArgs = { inherit inputs; };
	    modules = [ ./configuration.nix ];
	  };
	};

}