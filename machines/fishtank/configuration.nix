# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "fishtank";
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    fzf
    zsh
    tree
    tmux
    git
    htop
    parted
    starship
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  users.users.maximumstock = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHXKgTkKiSd5fJzH2cxUCN0f/c27tYNNl0M5u8G+TtR maximumstock@Maximilians-MBP.fritz.box"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHU1c6hTHlZEsSIy0wu8yZw9v5RObSejgCmDD7Du81AE maximumstock@anaconda" # backup, passphrase-less
    ];
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHXKgTkKiSd5fJzH2cxUCN0f/c27tYNNl0M5u8G+TtR maximumstock@Maximilians-MBP.fritz.box"
  ];
  programs.zsh.enable = true;
  users.defaultUserShell = with pkgs; pkgs.zsh;

  # Samba https://gist.github.com/vy-let/a030c1079f09ecae4135aebf1e121ea6
  # https://nixos.wiki/wiki/Samba
  # Also need to add smbpasswd -a <user>
  services.samba-wsdd = {
    # make shares visible for Windows clients
    enable = true;
    openFirewall = true;
  };
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = smbnix
      netbios name = smbnix
      security = user
      hosts allow = 192.168.0. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
      valid users = maximumstock
    '';
    shares = {
      tanka = {
        path = "/srv/tanka";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
      tankb = {
        path = "/srv/tankb";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
      "Time Machine" = {
        path = "/srv/tanka/timemachine";
        browseable = "yes";
        public = "no";
        writable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "maximumstock";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
      };
    };
  };

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 445 139 3300 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_port = 3300;
        http_addr = "";
      };
    };
    provision = {
      datasources = {
        settings = {
          datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              url = "http://[::1]:9001";
            }
          ];
        };
      };
      dashboards = {
        settings = {
          providers = [
            {
              name = "fishtank";
              options.path = "/etc/grafana-dashboards";
            }
          ];
        };
      };
    };
  };

  environment.etc = {
    "grafana-dashboards/node-exporter-full_rev30.json" = {
      source = ./grafana-dashboards/node-exporter-full.json;
      group = "grafana";
      user = "grafana";
    };
  };

  services.prometheus = {
    enable = true;
    port = 9001;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
    scrapeConfigs = [
      {
        job_name = "fishtank";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
    ];
  };

  # nginx reverse proxy
  # services.nginx.virtualHosts.${config.services.grafana.domain} = {
  #   locations."/" = {
  #       proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
  #       proxyWebsockets = true;
  #   };
  # };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}

