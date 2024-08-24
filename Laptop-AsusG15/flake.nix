{
  description = "Asus G15 flakes!";

  inputs = {
	nixpkgs.url = "nixpkgs/nixos-unstable";
	distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
	hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; #development or -git version
	#wallust.url = "git+https://codeberg.org/explosion-mental/wallust?ref=dev";  
  	};

  outputs = 
	inputs@{ self,nixpkgs, ... }:
    	let
      	system = "x86_64-linux";
      	host = "NixOS-G15";
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
