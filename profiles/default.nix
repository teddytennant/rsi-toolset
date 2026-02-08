{ config, lib, pkgs, ... }:

{
  imports = [
    ../modules/base.nix
    ../modules/networking.nix
    ../modules/security.nix
    ../modules/dev-tools.nix
    ../modules/ai-tools.nix
    ../modules/build-tools.nix
    ../modules/nix-tools.nix
  ];
}
