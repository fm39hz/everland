.PHONY: update clean build nixos-config

update:
	home-manager switch -b backup --flake .#fm39hz --extra-experimental-features 'nix-command flakes'

clean:
	nix-collect-garbage -d

build:
	home-manager build --flake .#fm39hz --extra-experimental-features 'nix-command flakes'

# Generate hardware configuration for NixOS installation
# Run this from NixOS installer after mounting target filesystem to /mnt
nixos-config:
	@echo "Generating hardware configuration..."
	@echo "Note: This should be run from NixOS installer with target filesystem mounted to /mnt"
	sudo nixos-generate-config --root ./ --show-hardware-config > hardware-configuration.nix
	@echo "Hardware configuration saved to hardware-configuration.nix"
