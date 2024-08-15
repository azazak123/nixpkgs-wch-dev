{ stdenv, cmake, pkgsCross, overrideCC, getToolchain, getWchSDK }:

{ pname, version, src, mcu, toolchain ? null, debug ? true }:

let
  mkDerivation =
    if isNull toolchain then
      pkgsCross.riscv32-embedded.stdenv.mkDerivation
    else stdenv.mkDerivation;

  sdk = getWchSDK { inherit mcu; };
  toolchainName = getToolchain { inherit toolchain; };

  outDir = if debug then "./build/debug" else "./build/release";
in

mkDerivation {
  inherit pname version src;

  WCH_SDK_PATH = "${sdk}/lib/${mcu}-sdk";
  WCH_TOOLCHAIN = toolchainName;

  dontUseCmakeBuildDir = true;

  nativeBuildInputs = [ cmake sdk toolchain ];
  dontDisableStatic = true;

  cmakeBuildType = if debug then "Debug" else "Release";
  preConfigure =
    if debug then ''
      export CLFAGS="-DDEBUG"
    ''
    else "";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ${outDir}/* $out/bin

    runHook postInstall
  '';
}

