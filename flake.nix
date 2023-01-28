{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-22.11";
    naersk.url = "github:nix-community/naersk";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    naersk,
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = (import nixpkgs) {
        inherit system;
      };
      naersk-lib = naersk.lib."${system}";
      buildDependencies = with pkgs; [gcc pkg-config pcsclite xorg.libX11.dev];
    in rec {
     # `nix build`
     packages.ykoauth-cli = naersk-lib.buildPackage {
       pname = "ykoauth-cli";
       root = ./.;
       nativeBuildInputs = buildDependencies;
     };
     defaultPackage = packages.ykoauth-cli;
     defaultApp = packages.ykoauth-cli;

      # `nix develop`
      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [rustc cargo bacon cargo-edit cargo-outdated clippy] ++ buildDependencies;
      };
    });
}
