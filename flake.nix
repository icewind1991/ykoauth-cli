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
    }) // {
      overlay = final: prev: {
        ykoauth-cli = final.rustPlatform.buildRustPackage rec {
          version = "0.1.0";
          pname = "ykoauth-cli";

          src = ./.;

          cargoSha256 = "sha256-GjRuG/DODkOjYmGqaI7nKRyWRCi91Ne3cZvwbWHO0io=";

          nativeBuildInputs = with final; [gcc pkg-config xorg.libX11.dev];
          buildInputs = with final; [pcsclite xorg.libX11];

          meta = with final.lib; {
            description = "CLI for reading TOTP keys from yubikeys";
            homepage = "https://github.com/icewind1991/ykoauth-cli";
            license = licenses.mit;
            platforms = platforms.linux;
          };
        };
      };
    };
}
