{ config, lib, pkgs, ... }:

{
  # No inbound services
  services.openssh.enable = false;

  # Disable unnecessary services
  services.avahi.enable = false;

  # Journal limits to prevent disk exhaustion
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxRetentionSec=7day
  '';

  # Kernel hardening
  boot.kernel.sysctl = {
    # No IP forwarding
    "net.ipv4.ip_forward" = 0;
    # SYN flood protection
    "net.ipv4.tcp_syncookies" = 1;
    # Disable source routing
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;
    # Disable ICMP redirects
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
  };
}
