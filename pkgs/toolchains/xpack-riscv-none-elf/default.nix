{ lib
, stdenv
, fetchurl
, runtimeShell
, rev ? "14.2.0-1"
, hash ? "sha256-petwdZXhQk/0EnzIshuLjLB25vAHC2cEhecrn3SAYgA="
}:

stdenv.mkDerivation rec {
  pname = "riscv-none-elf-gcc-xpack";
  version = rev;

  src = fetchurl {
    url = "https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/download/v${version}/xpack-riscv-none-elf-gcc-${version}-linux-x64.tar.gz";
    inherit hash;
  };

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/
    cp -r * $out
  '';

  preFixup = ''
    find $out -type f | while read f; do
      patchelf "$f" > /dev/null 2>&1 || continue
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f" || true
    done
  '';
}
