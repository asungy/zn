{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs-stable = import inputs.nixpkgs-stable { inherit system; };
        pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
        zig = inputs.zig.packages.${system}."0.14.0";
      in
      {
        devShell = pkgs-unstable.callPackage ./nix/devShell.nix {
          inherit zig;
          zon2nix = pkgs-stable.zon2nix;
        };

        packages =
        let
          mkArgs = optimize: {
            inherit optimize zig;
          };
        in rec {
          zn-debug = pkgs-unstable.callPackage ./nix/packages.nix (mkArgs "Debug");
          zn-releasesafe = pkgs-unstable.callPackage ./nix/packages.nix (mkArgs "ReleaseSafe");
          zn-releasefast = pkgs-unstable.callPackage ./nix/packages.nix (mkArgs "ReleaseFast");

          zn = zn-releasefast;
          default = zn;
        };
      }
    );
}
