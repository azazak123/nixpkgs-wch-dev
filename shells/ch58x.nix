{ pkgs ? import ../default.nix }:

pkgs.mkWCHShell
{
  name = "ch58x-shell";
  mcu = "ch58x";
}
{ inherit pkgs; }
