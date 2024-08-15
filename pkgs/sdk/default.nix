{ callPackage
, rev ? null
, sha256 ? null
}:

{ mcu }:

let
  sdk = callPackage ./${mcu} { };
in
sdk 
