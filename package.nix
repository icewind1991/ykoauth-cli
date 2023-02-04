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

  cargoSha256 = "sha256-fC1PqSm+rjB5zdEKAatlLdEr4SPRn/Txz15kXzs7FLo=";

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