{}:

{ toolchain ? null }:

if isNull toolchain then "riscv32-none-elf" else {
  mrs-toolchain = "riscv-none-embed";
  riscv-none-elf-gcc-xpack = "riscv-none-elf";
}.${toolchain.pname}
