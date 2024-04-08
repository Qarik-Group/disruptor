{
   system ? builtins.currentSystem
 , pkgs ? import <nixpkgs> { inherit system; }
 , pkgs_latest ? import <nixpkgs_latest> { inherit system; }
}:
let
  bazelisk = pkgs.bazelisk.overrideAttrs (oldAttrs: rec {
    postFixup = "ln -s $out/bin/bazelisk $out/bin/bazel";
  });
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    bazelisk
    bazel-buildtools
    jdk11
  ];
  shellHook = ''
    # readlink as absolute path is needed
    echo "startup --output_base $(readlink -f ./bazel-output)" > "$(pwd)"/.output-bazelrc
  '';
}
