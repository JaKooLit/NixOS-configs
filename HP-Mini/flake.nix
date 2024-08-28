{
  description = "HP-MiniPC"; 
  	
  inputs = {
  	nixpkgs.url = "nixpkgs/nixos-unstable";
	#wallust.url = "git+https://codeberg.org/explosion-mental/wallust?ref=dev";
	hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; # unstable hyprland
	distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes"; 
  	};

  outputs = 
	inputs@{ self,nixpkgs, ... }:
    	let
      	system = "x86_64-linux";
      	host = "NixOS-MiniPC";
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
	   		modules = [ ./profiles/configuration.nix ];
			};
		};
	};
}
