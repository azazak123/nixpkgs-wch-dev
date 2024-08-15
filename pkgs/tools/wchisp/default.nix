{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "wchisp";
  version = "v0.2.3";

  src = fetchFromGitHub {
    owner = "ch32-rs";
    repo = pname;
    rev = version;
    hash = "sha256-ga55A4dMK9uOsq9BYIdPc+rIvNNbfbPFVXAM4wsDHn8=";
  };

  cargoHash = "sha256-scyTsaIqnT/i6hmJRSwn/b+Mv568u2LVyv7ut3LHeQg=";
}
