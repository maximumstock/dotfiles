# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # To allow missing kernel modules to not fail the build?
  # See https://discourse.nixos.org/t/does-pkgs-linuxpackages-rpi3-build-all-required-kernel-modules/42509/3
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # RPi3 specific boot loader config
  boot.kernelPackages = pkgs.linuxPackages_rpi3;
  # A bunch of boot parameters needed for optimal runtime on RPi 3b+
  boot.kernelParams = [ "cma=256M" ];

  networking.hostName = "nixpi";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHXKgTkKiSd5fJzH2cxUCN0f/c27tYNNl0M5u8G+TtR maximumstock@Maximilians-MBP.fritz.box"
  ];

  systemd.services.dns-thingy = {
    enable = true;
    description = "A local DNS blocker based on https://github.com/maximumstock/dns-thingy";
    unitConfig = {
      After = "network.target";
    };
    # path = [ pkgs.nix ]
    serviceConfig = {
      ExecStart = "/root/.cargo/bin/dns-block-tokio --port 53 --recording-folder /home/root";
      # ExecStart = "nix run git+https://github.com/maximumstock/dns-thingy";
      Type = "simple";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    tmux
    curl
    zsh
    starship
    fzf
    ripgrep
    neovim
    dig
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = with pkgs; pkgs.zsh;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  # Use 1GB of additional swap memory in order to not run out of memory
  # when installing lots of things while running other things at the same time.
  swapDevices = [{
    device = "/swapfile";
    size = 1024;
  }];

  virtualisation.docker.enable = true;

  # virtualisation.oci-containers.containers = {
  #   adguardhome = {
  #     image = "adguard/adguardhome:latest";
  #     ports = [
  #       "53:53/tcp"
  #       "53:53/udp"
  #       "80:80/tcp"
  #       "443:443/tcp"
  #       "443:443/udp"
  #       "3000:3000/tcp"
  #     ];
  #     volumes = [
  #       "/root/adguardhome/work:/opt/adguardhome/work"
  #       "/root/adguardhome/conf:/opt/adguardhome/conf"
  #     ];
  #     autoStart = true;
  #   };
  # };

  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "ve-+" ];
  networking.nat.externalInterface = "eth0";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

