{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nix-output-monitor
  ];
}
