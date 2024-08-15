{ lib
, stdenv
, fetchurl
, runtimeShell
, rev ? "1.91"
, hash ? "sha256-FipXpGbjIs6rFi7eqg9L5SH54+hQKmK7zcqPr8ihml0="
}:

stdenv.mkDerivation rec {
  pname = "mrs-toolchain";
  version = rev;

  src = fetchurl {
    url = "http://file-oss.mounriver.com/tools/MRS_Toolchain_Linux_x64_V${rev}.tar.xz";
    inherit hash;
  };

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/
    cp -r RISC-V_Embedded_GCC/. $out
  '';

  preFixup = ''
    find $out -type f | while read f; do
      patchelf "$f" > /dev/null 2>&1 || continue
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f" || true
    done
  '';
}
