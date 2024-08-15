{
  description = "Simple example of blink program";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-wch-dev.url = "git+file:../../.";
  };

  outputs =
    { self, nixpkgs, flake-utils, nixpkgs-wch-dev }:
    flake-utils.lib.eachSystem [
      flake-utils.lib.system.x86_64-linux
    ]
      (system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.extend (nixpkgs-wch-dev.overlays.default);
      in
      {
        packages.default = pkgs.mkWCHProject {
          pname = "blink";
          version = "0.1";

          src = ./.;
          debug = false;

          mcu = "ch58x";
        };

        devShells = {
          default = nixpkgs-wch-dev.devShells.x86_64-linux.ch58x;
          mrs-toolchain = pkgs.mkWCHShell
            {
              name = "ch58x-shell";
              mcu = "ch58x";
              toolchain = pkgs.mrs-toolchain;
            }
            { inherit pkgs; };
          xpack-toolchain = pkgs.mkWCHShell
            {
              name = "ch58x-shell";
              mcu = "ch58x";
              toolchain = pkgs.xpack-riscv-none-elf;
            }
            { inherit pkgs; };
        };
      });
}
