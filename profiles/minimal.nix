{ config, lib, pkgs, ... }:

{
  imports = [
    ../modules/base.nix
    ../modules/networking.nix
    ../modules/dev-tools.nix
  ];
}
