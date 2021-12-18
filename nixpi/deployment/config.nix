let
  pkgs = import <nixpkgs> { };
  vpnConfiguration = import ./vpn-configuration.nix;

  # Helper to create a machine with the wireguard configuration and the hardware
  # configuration for the specified raspberry model.
  machine = raspberry-model: name:
    ({ ... }:
      let
        vpnClientConfiguration = vpnConfiguration.clients."${name}";
        wireguard = import ./wireguard-client.nix {
          inherit vpnClientConfiguration;
          vpnServerConfiguration = vpnConfiguration.server;
        };
      in {
        imports = [ (./. + "/hardware/rpi${raspberry-model}.nix") ];
        deployment.targetHost = vpnClientConfiguration.ip;
      } // wireguard);
in {
  network.description = "A Raspberry Pi (4, 3B+) cluster.";

  # Define the machines in the network
  a = machine "4" "a";
  b = machine "4" "b";
  c = machine "3B+" "c";

  # Default configuration applicable to all machines
  defaults = {
    networking.useDHCP = false;
    networking.interfaces.eth0.useDHCP = true;

    environment.systemPackages = with pkgs; [ wget vim git htop ];

    services.openssh.enable = true;
    users.extraUsers.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHXKgTkKiSd5fJzH2cxUCN0f/c27tYNNl0M5u8G+TtR maximumstock@Maximilians-MBP.fritz.box"
    ];

    # Define that we need to build for ARM
    nixpkgs.localSystem = {
      system = "aarch64-linux";
      config = "aarch64-unknown-linux-gnu";
    };
  };
}
