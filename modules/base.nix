{ config, lib, pkgs, ... }:

{
  # Core agent user
  users.users.agent = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.bash;
    home = "/home/agent";
    createHome = true;
  };

  # Passwordless sudo for wheel
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # Timezone and locale
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable nix-ld for dynamically linked executables (e.g. claude-code's node)
  programs.nix-ld.enable = true;

  # Enable flakes and nix-command inside the container
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Basic system packages
  environment.systemPackages = with pkgs; [
    bash
    coreutils
    findutils
    gnugrep
    gnused
  ];

  system.stateVersion = "25.11";
}
