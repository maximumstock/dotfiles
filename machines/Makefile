fishbook:
	darwin-rebuild switch --flake fishbook/#fishbook
fishtank:
	nix run nixpkgs#nixos-rebuild -- switch --fast --flake fishtank/#fishtank --build-host fishtank --target-host fishtank
fishtank-tailscale:
	nix run nixpkgs#nixos-rebuild -- switch --fast --flake fishtank/#fishtank --build-host fishtank-tailscale --target-host fishtank-tailscale
nixpi:
	nix run nixpkgs#nixos-rebuild -- switch --fast --flake nixpi/#nixpi --build-host nixpi --target-host nixpi
anaconda:
	cd anaconda && nixos-rebuild switch

