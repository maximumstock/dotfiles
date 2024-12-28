let
  maximumstock = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHXKgTkKiSd5fJzH2cxUCN0f/c27tYNNl0M5u8G+TtR";
  users = [ maximumstock ];

  fishtank = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJpzOWvO+4ljo1La3B6KRCEi5KgRR9sxFmj/+zUNo+ih";
  systems = [ fishtank ];
in
{
  "photoprism.age".publicKeys = systems ++ users;
  "tailscale.age".publicKeys = systems ++ users;
}
