# Add this to the host NixOS configuration to enable container networking.
# Containers use veth pairs (ve-*) and need NAT to reach the internet.
#
# Required host config for rsi-toolset:
#   1. boot.enableContainers = true;
#   2. networking.nat (below)
{ config, lib, pkgs, ... }:

{
  boot.enableContainers = true;

  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "enp4s0";
  };
}
