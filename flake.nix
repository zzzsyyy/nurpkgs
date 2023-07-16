{
  description = "My personal NUR repository";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      meta = import ./meta.nix;
    in
    {
      legacyPackages = forAllSystems (system: import ./default.nix {
        pkgs = import nixpkgs { inherit system; };
      });
      packages = forAllSystems (system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system});
      nixosModule = self.nixosModules.default;
      nixosModules.default = { ... }: {
        nixpkgs.overlays = [ self.overlay ];
        nix.settings = {
          substituters = [ meta.cache ];
          trusted-public-keys = [ meta.pubkey ];
        };
      };
    };
}
