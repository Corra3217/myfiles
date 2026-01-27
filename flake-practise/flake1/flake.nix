{
	description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		mynixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
		oldnixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
		
	};

	outputs = { self, nixpkgs, ... } @ inputs: 
	let 
		pkgs = nixpkgs.legacyPackages.x86_64-linux;
		oldpkgs = inputs.mynixpkgs.legacyPackages.x86_64-linux;
		oldoldpkgs = inputs.oldnixpkgs.legacyPackages.x86_64-linux;
	in 
	{

		packages.x86_64-linux.hello = pkgs.hello;
		packages.x86_64-linux.default = pkgs.hello;

		devShells.x86_64-linux.default = pkgs.mkShell {
			buildInputs = [ oldoldpkgs.neovim]; 
		};

	};
}
