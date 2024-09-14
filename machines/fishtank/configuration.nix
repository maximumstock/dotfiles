# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "fishtank";
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHU1c6hTHlZEsSIy0wu8yZw9v5RObSejgCmDD7Du81AE maximumstock@anaconda" # backup
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
  networking.firewall.allowedTCPPorts = [
    # SMB
    445
    139
    3300 # Grafana
    # 58080 # paperless
    2342 # Photoprism
  ];
  networking.firewall.allowedUDPPorts = [
    # Jellyfin
    137
    138
  ];

  # Jellyfin based on https://nixos.wiki/wiki/Jellyfin
  # Enable vaapi on OS-level
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver # previously vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      intel-media-sdk # QSV up to 11th gen
    ];
  };
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
        static_configs = [
          { targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ]; }
        ];
      }
    ];
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      # Periodically sync backups to a 2nd disk
      "0 * * * *    root    rsync -avz --delete /srv/tanka/timemachine /srv/tankb/backups2/"
    ];
  };

  # Photoprism based on https://nixos.wiki/wiki/PhotoPrism
  services.photoprism = {
    enable = true;
    port = 2342;
    originalsPath = "/srv/tanka/media/Pictures/Archive";
    address = "0.0.0.0";
    settings = {
      PHOTOPRISM_ADMIN_USER = "admin";
      PHOTOPRISM_DEFAULT_LOCALE = "en";
      PHOTOPRISM_DATABASE_DRIVER = "mysql";
      PHOTOPRISM_DATABASE_NAME = "photoprism";
      PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
      PHOTOPRISM_DATABASE_USER = "photoprism";
    };
  };

  # MySQL
  services.mysql = {
    enable = true;
    dataDir = "/srv/tankb/mysql";
    package = pkgs.mariadb;
    ensureDatabases = [ "photoprism" ];
    ensureUsers = [ {
      name = "photoprism";
      ensurePermissions = {
        "photoprism.*" = "ALL PRIVILEGES";
      };
    } ];
  };

  # # Thank you NobbZ https://github.com/NobbZ/nixos-config/blob/23b66c28fd50b0dd437599399b2b52d7d071e772/nixos/configurations/mimas.nix#L380-L388
  # services.paperless = {
  #   enable = true;
  #   address = "0.0.0.0";
  #   port = 58080;
  #   settings.PAPERLESS_OCR_LANGUAGE = "deu+eng";
  # };
  # systemd.services.paperless-scheduler.after = ["var-lib-paperless.mount"];
  # systemd.services.paperless-consumer.after = ["var-lib-paperless.mount"];
  # systemd.services.paperless-web.after = ["var-lib-paperless.mount"];

  powerManagement.enable = true;
  powerManagement.powertop.enable = true; # enables auto-tune upon startup
  services.tlp.enable = true;
  services.tlp.settings = {
    CPU_ENERGY_PERF_POLICY_ON_AC = "power"; # https://linrunner.de/tlp/settings/processor.html#cpu-energy-perf-policy-on-ac-bat
    RUNTIME_PM_ON_AC = "on"; # https://linrunner.de/tlp/settings/runtimepm.html
    PCIE_ASPM_ON_AC = "powersupersave";
    PLATFORM_PROFILE_ON_AC = "lower-power";
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
