{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.sops-nix.url = "github:Mic92/sops-nix";
  inputs.agenix.url = "github:ryantm/agenix";

  outputs = { self, nixpkgs, sops-nix, agenix, ... }: {
    nixosConfigurations.fishtank = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        sops-nix.nixosModules.sops
        agenix.nixosModules.default
        {
          environment.systemPackages = [ agenix.packages.${system}.default ];
        }
      ];
    };
  };
}
