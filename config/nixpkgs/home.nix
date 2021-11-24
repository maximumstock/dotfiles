{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "maximumstock";
  home.homeDirectory = "/home/maximumstock";

  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.chromium
    pkgs.spotify
    pkgs.vscodium
    pkgs.poetry
    (pkgs.mumble.override { pulseSupport = true; })
    pkgs.feh
    pkgs.ranger
    pkgs.starship
    pkgs.autorandr
    pkgs.playerctl
    pkgs.rofi
    pkgs.betterlockscreen
    pkgs.git-extras
    pkgs.anki
    pkgs.signal-desktop
    pkgs.pavucontrol
    pkgs.lldb
    pkgs.keepassxc
    pkgs.go-sct
    pkgs.jq
    # i3 polybar
    pkgs.font-awesome
    pkgs.material-icons
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
