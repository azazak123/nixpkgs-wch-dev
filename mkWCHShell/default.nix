{ pkgsCross, mkShell, getToolchain, getWchSDK }:

{ name, mcu, toolchain ? null }:

{ pkgs ? import ../default.nix }:

let
  mkShell =
    if isNull toolchain then
      pkgsCross.riscv32-embedded.mkShell
    else pkgs.mkShell;

  sdk = getWchSDK { inherit mcu; };
  toolchainName = getToolchain { inherit toolchain; };
in

mkShell {
  inherit name;

  shellHook = ''
    export WCH_SDK_PATH="${sdk}/lib/${mcu}-sdk";
    export WCH_TOOLCHAIN=${toolchainName};
  '';

  packages = with pkgs; [
    cmake
    sdk
    wchisp
  ];
}
