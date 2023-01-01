{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-22.05";
    riff.url = "github:DeterminateSystems/riff";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    riff,
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = (import nixpkgs) {
        inherit system;
      };
    in rec {
      # `nix develop`
      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [rustc cargo bacon cargo-edit cargo-outdated clippy gcc pkg-config pcsclite xorg.libX11.dev];
      };
    });
}
