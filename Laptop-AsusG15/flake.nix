{
  description = "Asus G15 flakes!";

  inputs = {
	nixpkgs.url = "nixpkgs/nixos-unstable";
	wallust.url = "git+https://codeberg.org/explosion-mental/wallust?ref=dev"; # change to dev or master depending your choice
	distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes"; 
  	};

  outputs = 
	inputs@{ self,nixpkgs, ... }:
    	let
      	system = "x86_64-linux";
      	host = "Asus-G15";
      	username = "ja";

      	pkgs = import nixpkgs {
        	inherit system;
        	config = {
          	allowUnfree = true;
        	};
      	};
    in
    {
	nixosConfigurations = {
		"${host}" = nixpkgs.lib.nixosSystem rec {
			specialArgs = { 
			inherit system;
			inherit inputs;
    	inherit username;
      inherit host;
			};
	   		modules = [ ./Profiles/configuration.nix ];
			};
		};
	};  	
}
