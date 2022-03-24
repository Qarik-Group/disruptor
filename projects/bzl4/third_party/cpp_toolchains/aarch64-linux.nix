let
  # Inspired by Digital Assets DAML repo
  system = builtins.currentSystem;
  nixpkgs = import <nixpkgs> { inherit system; };
  crossPkgs = nixpkgs.pkgsCross.aarch64-multiplatform;
  crossGCC = crossPkgs.buildPackages.gcc;
  crossGCCUnwrapped = crossPkgs.buildPackages.gcc-unwrapped;
  crossBinutils = crossPkgs.buildPackages.binutils;
  crossBinutilsUnwrapped = crossPkgs.buildPackages.binutils-unwrapped;
  prefixStrippedGCC = nixpkgs.runCommand "gcc-aarch64-symlinks" { } ''
    mkdir -p $out/bin
    for tool in \
      ar \
      dwp \
      nm \
      objcopy \
      objdump \
      strip
    do
        ln -s ${crossBinutilsUnwrapped}/bin/aarch64-unknown-linux-gnu-$tool $out/bin/$tool
    done;
    ln -s ${crossBinutils}/bin/aarch64-unknown-linux-gnu-ld $out/bin/ld
    for tool in \
      cc \
      gcc \
      gcov
    do
        ln -s ${crossGCC}/bin/aarch64-unknown-linux-gnu-$tool $out/bin/$tool
    done;
    ln -s ${crossGCCUnwrapped}/bin/aarch64-unknown-linux-gnu-cpp $out/bin/cpp
  '';
in nixpkgs.buildEnv {
  name = "cc_toolchain_linux_aarch64";
  paths = [ prefixStrippedGCC ];
}
