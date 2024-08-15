# nixpkgs-wch-dev

Nix flake and overlay for developing for WCH MCUs.

This tool is a work in progress.

## General

This flake provides packages and tools to make development for WCH MCUs easier. Moreover, it consists of Nix functions to make package and shell creation more convenient.

### Package building

To create a package, one can use the `mkWCHProject` Nix function. It has the following parameters:

- `pname` - package name
- `version` - package version
- `src` - path to the source code
- `mcu` - MCU's name (e.g. `ch58x`)
- `toolchain` - one of the toolchain packages
- `debug` - whether to enable debug build or not (default: `true`)

### Shell Creation

Additionally, one can use `mkWCHShell` Nix function to create a shell. Its parameters are:

- `name` - shell name
- `mcu` - MCU's name (e.g., `"ch58x"`)
- `toolchain` - one of toolchain packages

### Provided Packages and Shells

Shells:

- `ch58x`

Tools:

- [`wchisp`](https://github.com/ch32-rs/wchisp)

Supported toolchains:

- default - [RISC-V GNU Compiler Toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain). Used when field is unspecified
- `riscv-none-elf-gcc-xpack` - [The xPack GNU RISC-V Embedded GCC](https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack)
- `mrs-toolchain` - [MounRiver studio](http://www.mounriver.com/) toolchain

## Examples

To enter a simple predefined shell:

```bash
nix develop github:azazak123/nixpkgs-wch-dev#ch58x
```

Package definition:

```nix
packages.example = pkgs.mkWCHProject {
  pname = "example";
  version = "1";
  src = ./.;
  debug = false;
  mcu = "ch58x";
};
```

Example of a simple `flake.nix` file:

```nix
{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs-wch-dev.url = "github:azazak123/nixpkgs-wch-dev";
  };

  outputs =
    { self, nixpkgs, nixpkgs-wch-dev }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux.extend (nixpkgs-wch-dev.overlays.default);
    in
    {
      packages.x86_64-linux.default = pkgs.mkWCHProject {
        pname = "example";
        version = "0.1";
        src = ./.;
        debug = false;
        mcu = "ch58x";
      };

      devShells.x86_64-linux = {
        default = nixpkgs-wch-dev.devShells.x86_64-linux.ch58x;
      };
    };
}
```

A more complicated example can be found in the `examples` folder. It has a blink program that includes a simple project structure example with a source folder, `flake.nix`, and `CMakeLists.txt`.

## Supported MCUs

For now, I only have ch58x unfortunately. As my collection grows, I will add new MCUs.

- `ch58x`

## Related projects

Here are some projects that I used and took inspiration from. Many thanks to their developers!

- <https://github.com/mirrexagon/nixpkgs-esp-dev>
- <https://github.com/MatthewCroughan/nrf-nix>
- <https://github.com/rgoulter/ch592-ble-hid-keyboard-example>
- <https://github.com/ohmytime/CH58X-CMake>
  
## Contribution

Contributions to `nixpkgs-wch-dev` are welcome! Whether you are fixing a bug, adding new features, improving documentation, or providing feedback, your input helps improve this project!
