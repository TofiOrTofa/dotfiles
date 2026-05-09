{
  inputs = {
    # Переходим на стабилку, чтобы не воевать с будущим
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = { self, nixpkgs-unstable, nixpkgs-stable, home-manager, ... }:
    let
      system = "x86_64-linux";

      unstable-pkgs = nixpkgs-unstable.legacyPackages.${system};
      stable-pkgs = nixpkgs-stable.legacyPackages.${system};
    in {
      homeConfigurations."comu" = home-manager.lib.homeManagerConfiguration {

        pkgs = stable-pkgs;
        modules = [ ./home.nix ];

        extraSpecialArgs = {
          inherit stable-pkgs;
          inherit unstable-pkgs;
        };
      };
    };
}

