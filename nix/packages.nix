{
  lib,
  optimize,
  pkgs,
  stdenv,
  zig,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zn";
  version = "0.0.0";

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.intersection (lib.fileset.fromSource (lib.sources.cleanSource ../.)) (
      lib.fileset.unions [
        ../src
        ../build.zig
        ../build.zig.zon
      ]
    );
  };

  nativeBuildInputs = [ zig ];

  dontConfigue = true;
  dontInstall = true;

  buildPhase = ''
    NO_COLOR=1
    PACKAGE_DIR=${pkgs.callPackage ../build.zig.zon.nix {}}
    zig build install --global-cache-dir $(pwd)/.cache --system $PACKAGE_DIR -Doptimize=${optimize} --prefix $out
  '';
})

