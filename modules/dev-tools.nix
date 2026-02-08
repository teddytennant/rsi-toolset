{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Version control
    git
    gh
    openssh  # SSH client

    # Network tools
    curl
    wget

    # Data processing
    jq
    yq-go

    # Search and navigation
    ripgrep
    fd
    fzf
    tree

    # Editors
    vim
    nano

    # Terminal tools
    tmux
    htop

    # File utilities
    file
    less
    rsync
    zip
    unzip

    # Process and system
    procps

    # Text processing
    gawk
    gnutar
    gzip
    xz
    zstd
  ];
}
