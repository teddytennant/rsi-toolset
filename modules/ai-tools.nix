{ config, lib, pkgs, ... }:

{
  # Allow unfree packages (claude-code)
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    claude-code
    nodejs
    python3
  ];
}
