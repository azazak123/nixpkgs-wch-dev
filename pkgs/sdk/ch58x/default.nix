{ lib
, stdenv
, fetchFromGitHub
, rev ? "434c9d9916f47dc40d67490228a222f434560edf"
, hash ? "sha256-UymigxqSN9Apkvg5cX0kEW5DWngyhHRvwtdgkgqVPCY="
}:

stdenv.mkDerivation rec {
  pname = "ch58x-sdk";
  version = rev;

  src = fetchFromGitHub {
    owner = "openwch";
    repo = "ch583";
    inherit rev hash;
  };

  patches = [
    ./header-case.patch
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/ch58x-sdk
    cp -a ./EVT/EXAM/* $out/lib/ch58x-sdk/
    
    runHook postInstall
  '';
}
