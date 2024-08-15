{
  description = "WCH development tools";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, flake-utils }: {
      overlays.default = import ./overlay.nix;
    } //
    flake-utils.lib.eachSystem [
      flake-utils.lib.system.x86_64-linux
    ]
      (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.default ]; };
      in
      {
        legacyPackages = {
          inherit (pkgs) mkWCHProject;
        };

        packages = rec {
          inherit (pkgs)
            # toolchains
            mrs-toolchain
            xpack-riscv-none-elf

            # tools
            wchisp

            # SDK
            ch58x-sdk;

          default = ch58x-sdk;
        };

        devShells = rec {
          ch58x = import ./shells/ch58x.nix {
            inherit pkgs;
          };
        };
      });
}
