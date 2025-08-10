{
  description = "FM39hz's Nix flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Community flakes for additional applications
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    spicetify-nix,
    ...
    } @ inputs: let
      system = "x86_64-linux";
      specialArgs = { inherit inputs; }; # this is the important part
      # User's specific information
      personal = {
        city = "Hanoi";
        user = "fm39hz";
        hostname = "fm39hz-desktop";
        email = "hitpoint2k3@gmail.com";
        timeZone = "Asia/Ho_Chi_Minh";
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = "vi_VN.UTF-8";
        homeDir = "/home/${personal.user}";
      };
      
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        # needed to install obsidian ugh
        permittedInsecurePackages = [
          "electron-25.9.0"
        ];
        input-fonts.acceptLicense = true; # license for input-fonts: https://input.djr.com/license/. go support it's creator here!!: http://input.djr.com/buy
      };
    };
    in {
      # NixOS system configuration
      nixosConfigurations = {
        ${personal.hostname} = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { 
            inherit personal;
            inputs = self.inputs; 
          };
          modules = [
            ./configuration.nix
            {
              programs.hyprland = {
                enable = true;
                withUWSM = true;
              };

              xdg.portal = {
                enable = true;
                xdg.terminal-exec = {
                  enable = true;
                  package = pkgs.xdg-terminal-exec-mkhl;
                };
                xdgOpenUsePortal = true;
                config = {
                  common.default = ["gtk"];
                  hyprland.default = [
                    "hyprland"
                    "gtk"
                  ];
                };
                extraPortals = with pkgs; [
                  xdg-desktop-portal-gtk
                  xdg-desktop-portal-hyprland
                ];
              };
            }
          ];
        };
      };
      
      # Home Manager configurations
      homeConfigurations = {
        ${personal.user} = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              # needed to install obsidian ugh
              permittedInsecurePackages = [
                "electron-25.9.0"
              ];
              input-fonts.acceptLicense = true; # license for input-fonts: https://input.djr.com/license/. go support it's creator here!!: http://input.djr.com/buy
            };
          };
          extraSpecialArgs = { 
            inherit personal; 
            inputs = self.inputs;
          };
          modules = [
            stylix.homeModules.stylix
            spicetify-nix.homeManagerModules.default
            ./home.nix
          ];
        };
      };
    };
}
