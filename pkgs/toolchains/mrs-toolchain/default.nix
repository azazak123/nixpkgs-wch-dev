{ lib
, stdenv
, fetchurl
, runtimeShell
, rev ? "1.92"
, hash ? "sha256-M+DddYGi7qJbxdGqLDH1yLMW5UO5VNhPnh/8WZnpP+o="
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
