# Add this to the host NixOS configuration to enable container networking.
# Containers use veth pairs (ve-*) and need NAT to reach the internet.
{ config, lib, pkgs, ... }:

{
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "enp4s0";
  };
}
