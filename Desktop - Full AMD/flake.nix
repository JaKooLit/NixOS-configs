{
  description = "My Desktop flakes!";

  inputs = {
	nixpkgs.url = "nixpkgs/nixos-unstable";
	wallust.url = "git+https://codeberg.org/explosion-mental/wallust?ref=dev"; # change to dev or master depending your choice
  };
  
   outputs = { self, nixpkgs, ... }@inputs: {
	nixosConfigurations = {
	  NixOS = nixpkgs.lib.nixosSystem {
	    system = "x86_64-linux";
	    specialArgs = { inherit inputs; };
	    modules = [ ./configuration.nix ];
	  };
	};
  };
	  	

}
