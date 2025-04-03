{
  mkShell,
  gdb,
  nixd,
  zig,
  zls,
  zon2nix,
}:
mkShell {
  name = "zn";
  packages = [
    gdb
    nixd
    zig
    zls
    zon2nix
  ];
}
