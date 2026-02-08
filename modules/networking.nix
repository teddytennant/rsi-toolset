{ config, lib, pkgs, ... }:

{
  # Container networking is managed by the host — no DHCP needed
  networking.useDHCP = false;

  # Firewall: allow outbound, block all inbound
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  # DNS resolvers
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # SSH agent support (client-side)
  programs.ssh.startAgent = true;

  # Pre-populate known hosts for common forges
  programs.ssh.knownHosts = {
    "github.com" = {
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    };
    "gitlab.com" = {
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
    };
  };
}
