{
  rustPlatform,
  gcc,
  pkg-config,
  xorg,
  pcsclite,
  lib,
  enableClipboard ? true,
}: let
  inherit (lib) optionals licenses platforms;
in rustPlatform.buildRustPackage rec {
  version = "0.1.0";
  pname = "ykoauth-cli";

  src = ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ykoath-0.1.0" = "sha256-wBiEoaRNPG3jkY8HHPC4VwNC6/HrPSU1K4AcILLytrA=";
    };
  };

  nativeBuildInputs = [gcc pkg-config] ++ optionals enableClipboard [xorg.libX11.dev];
  buildInputs = [pcsclite] ++ optionals enableClipboard [xorg.libX11];

  buildNoDefaultFeatures = true;
  buildFeatures = optionals enableClipboard ["clipboard"];

  meta = {
    description = "CLI for reading TOTP keys from yubikeys";
    homepage = "https://github.com/icewind1991/ykoauth-cli";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}