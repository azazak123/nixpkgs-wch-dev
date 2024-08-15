final: prev:

let
  getWchSDK = prev.callPackage ./pkgs/sdk { };
  getToolchain = prev.callPackage ./pkgs/toolchains { };
in
rec {
  mkWCHProject = prev.callPackage ./mkWCHProject {
    inherit getWchSDK getToolchain;
  };

  mkWCHShell = prev.callPackage ./mkWCHShell {
    inherit getWchSDK getToolchain;
  };

  # toolchains
  mrs-toolchain = prev.callPackage ./pkgs/toolchains/mrs-toolchain { };
  xpack-riscv-none-elf = prev.callPackage ./pkgs/toolchains/xpack-riscv-none-elf { };

  # tools
  wchisp = prev.callPackage ./pkgs/tools/wchisp { };

  # SDK
  ch58x-sdk = prev.callPackage ./pkgs/sdk { } {
    mcu = "ch58x";
  };
}
