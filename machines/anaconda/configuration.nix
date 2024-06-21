# Edit this configuration file to define what should be installed onC
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config = {
    packageOverrides = pkgs: rec {
      polybar = pkgs.polybar.override {
        i3GapsSupport = true;
        pulseSupport = true;
        mpdSupport = true;
        nlSupport = true;
      };
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "anaconda"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp34s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "DejaVu Sans Mono" ];
        serif = [ "DejaVu Sans" ];
        sansSerif = [ "DejaVu Sans Serif" ];
      };
    };
    fonts = with pkgs; [
      # noto-fonts
      hack-font
      # font-awesome
      # powerline-fonts
      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];
  };

  # Select internationalisation properties.
  i18n = { defaultLocale = "de_DE.UTF-8"; };

  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the GNOME 3 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.displayManager.defaultSession = "none+i3";
  services.xserver.libinput.mouse.accelSpeed = "0.1";

  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    extraPackages = with pkgs; [ i3status i3lock polybar ];
  };

  services.udev.extraRules = ''
    # Wally Moonlander Flashing
    # STM32 rules for the Moonlander and Planck EZ
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", \
    MODE:="0666", \
    SYMLINK+="stm32_dfu"

    # Moonlander Live Training
    # Rule for all ZSA keyboards
    SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
    # Rule for the Moonlander
    SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
  '';

  # MPD
  services.mpd = {
    enable = true;
    extraConfig = ''
      audio_output {
        type "pulse" # MPD must use Pulseaudio
        name "Pulseaudio" # Whatever you want
        server "127.0.0.1" # MPD must connect to the local sound server
      }
    '';
  };

  # Configure keymap in X11
  services.xserver.layout = "de";
  services.xserver.xkbOptions = "eurosign:e, ctrl:nocaps";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.extraConfig = "
    load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 # Needed by mpd to be able to use Pulseaudio
    load-module module-switch-on-connect
  ";

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };

  users.groups.plugdev = { };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.maximumstock = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "plugdev" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
    libreoffice
    vlc
    parted
    git
    htop
    tmux
    tree
    zsh
    fzf
    curl
    wget
    ripgrep
    wineWowPackages.stable
  ];

  environment.variables = {
    EDITOR = pkgs.lib.mkOverride 0 "nvim";
    SHELL = pkgs.lib.mkOverride 0 "zsh";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  networking.firewall.enable = false;

  virtualisation.docker.enable = true;
  virtualisation.docker.extraOptions =
    "--metrics-addr 127.0.0.1:9323 --experimental";

  services.restic.backups = {
    fishtank = {
      initialize = true;
      repository = "sftp:fishtank-backup:/srv/tanka/timemachine/anaconda";
      user = "maximumstock";
      paths = [
        "${config.users.users.maximumstock.home}/Dokumente"
        "${config.users.users.maximumstock.home}/code"
        "${config.users.users.maximumstock.home}/.config"
        "${config.users.users.maximumstock.home}/.ssh"
      ];
      passwordFile = "/etc/nixos/secrets/restic_password.txt";
      extraBackupArgs = let
        ignorePatterns = [
          "node_modules"
          "target"
        ];
        ignoreFile = builtins.toFile "ignore"
          (builtins.foldl' (a: b: a + "\n" + b) "" ignorePatterns);
      in [ "--exclude-file=${ignoreFile}" ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

