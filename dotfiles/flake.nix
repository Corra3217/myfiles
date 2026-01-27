{
       description = "My nixos configuration";

       inputs = {
               unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
               nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
               home-manager = {
                       url = "github:nix-community/home-manager/release-25.11";
                       inputs.nixpkgs.follows = "nixpkgs";
               };
       };

       outputs = { self, nixpkgs, home-manager, ... } @ inputs:  
       let
               pkgs = nixpkgs.legacyPackages.x86_64-linux;
               testpkgs = inputs.unstable.legacyPackages.x86_64-linux;
       in  
       {  
               nixosConfigurations.NixPad = nixpkgs.lib.nixosSystem {
                       specialArgs = { inherit inputs; };
                       modules = [
                               ./configuration.nix
                               home-manager.nixosModules.home-manager  {
                                       home-manager = {  
                                               useGlobalPkgs = true;
                                               useUserPackages = true;
                                               backupFileExtension = "backup";
                                               users.nixuser = import ./home.nix;
                                       };
                               }
                       ];
               };

               devShells.x86_64-linux.default = pkgs.mkShell {
                       buildInputs = [  
                               testpkgs.neovim  
                               testpkgs.neofetch  
                               testpkgs.gcc
                       ];
               };

               packages.x86_64-linux.default = pkgs.hello;
       };
}
