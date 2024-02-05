{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "maximumstock";
  home.homeDirectory = "/home/maximumstock";

  home.packages = [
    pkgs.tmux
    pkgs.zsh
    pkgs.alacritty
    pkgs.neovim
    pkgs.chromium
    pkgs.google-chrome
    pkgs.spotify
    pkgs.poetry
    (pkgs.mumble.override { pulseSupport = true; })
    pkgs.feh
    pkgs.ranger
    pkgs.starship
    pkgs.autorandr
    pkgs.playerctl
    pkgs.betterlockscreen
    pkgs.git-extras
    pkgs.anki
    pkgs.signal-desktop
    pkgs.pavucontrol
    pkgs.lldb
    pkgs.keepassxc
    pkgs.go-sct
    pkgs.jq
    pkgs.wally-cli
    pkgs.flameshot
    pkgs.vscode
    pkgs.nodejs
    pkgs.difftastic
    pkgs.delta
    pkgs.gnome.nautilus
    pkgs.discord
    pkgs.yt-dlp
    pkgs.zellij
    # i3 polybar
    pkgs.font-awesome
    pkgs.material-icons
    pkgs.xclip
    pkgs.k3b
    pkgs.unzip
    # COQ
    pkgs.python38
    pkgs.nixd
    pkgs.deploy-rs
  ];

  programs.rofi = {
    enable = true;
    plugins = [
      pkgs.rofi-calc
    ];
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";
}
