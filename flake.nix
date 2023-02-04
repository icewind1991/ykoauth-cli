{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-22.11";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }: utils.lib.eachDefaultSystem (system: let
      pkgs = (import nixpkgs) {
        inherit system;
      };
    in rec {
     # `nix build`
     packages.ykoauth-cli = pkgs.callPackage ./package.nix {};
     defaultPackage = packages.ykoauth-cli;

      # `nix develop`
      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [rustc cargo bacon cargo-edit cargo-outdated clippy gcc pkg-config pcsclite xorg.libX11.dev];
      };
    }) // {
      overlay = final: prev: {
        ykoauth-cli = final.callPackage ./package.nix {};
      };
    };
}
