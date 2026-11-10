{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, treefmt-nix, ... }:
    let
      forSystems =
        f:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ] (system: f nixpkgs.legacyPackages.${system});

      treefmt =
        pkgs:
        treefmt-nix.lib.mkWrapper pkgs {
          programs = {
            mdformat.enable = true;
            nixfmt.enable = true;
            rustfmt.enable = true;
            taplo.enable = true;
            yamlfmt = {
              enable = true;
              settings.formatter.retain_line_breaks_single = true;
            };
          };
        };
    in
    {
      devShells = forSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            cargo
            rustc
            clippy
            rustfmt
            rust-analyzer
            (treefmt pkgs)
          ];
        };
      });

      formatter = forSystems treefmt;
    };
}
