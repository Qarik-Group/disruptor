{
   system ? builtins.currentSystem
 , pkgs ? import <nixpkgs> { inherit system; }
}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    bazel_4
    bazel-buildtools
  ];
  shellHook = ''
    # readlink as absolute path is needed
    echo "startup --output_base $(readlink -f ./bazel-output)" > "$(pwd)"/.output-bazelrc
  '';
}
