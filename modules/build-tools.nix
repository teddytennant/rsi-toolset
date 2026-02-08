{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnumake
    gcc
    pkg-config
  ];
}
