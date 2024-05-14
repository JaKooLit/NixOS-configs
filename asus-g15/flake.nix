{
  description = "G15 flakes!";
  

  inputs = {
	nixpkgs.url = "nixpkgs/nixos-unstable";
	wallust.url = "git+https://codeberg.org/explosion-mental/wallust?ref=dev";
	ags.url = "github:Aylur/ags";
  };

  outputs = { self,nixpkgs, ... }@inputs: {
	nixosConfigurations.NixOS-G15 = nixpkgs.lib.nixosSystem {
	    system = "x86_64-linux";
		specialArgs = { inherit inputs; };
	    modules = [ ./configuration.nix ];
	  };
	};

}

