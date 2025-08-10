# Basic NixOS configuration for use with flakes
{  pkgs, personal, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Basic system configuration
  system.stateVersion = "25.05"; # Did you read the comment?
  
  # Bootloader configuration (adjust for your system)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
  "video=DP-1:1920x1080@170"
  "video=HDMI-A-1:1920x1080@60"
  ];
  # Networking configuration
  networking = {
    hostName = personal.hostname;
    networkmanager.enable = true;
  };
  
  # Time and locale
  time.timeZone = personal.timezone;
  i18n.defaultLocale = personal.defaultLocale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = personal.extraLocaleSettings;
    LC_IDENTIFICATION = personal.extraLocaleSettings;
    LC_MEASUREMENT = personal.extraLocaleSettings;
    LC_MONETARY = personal.extraLocaleSettings;
    LC_NAME = personal.extraLocaleSettings;
    LC_NUMERIC = personal.extraLocaleSettings;
    LC_PAPER = personal.extraLocaleSettings;
    LC_TELEPHONE = personal.extraLocaleSettings;
    LC_TIME = personal.extraLocaleSettings;
  };

  # Enable flakes
  nix = { 
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = ["https://hyprland.cachix.org"];
      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # User configuration
  users.users.${personal.user} = {
    isNormalUser = true;
    description = "My user on Nixos";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" ];
    shell = pkgs.zsh;
  };
  
  # Enable zsh system-wide
  programs.zsh.enable = true;
  
  # Essential system packages (minimal - most apps managed via Home Manager)
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    neovim
    home-manager
  ];
  
  # System services
  services = {
    openssh.enable = true;
    
    # Audio system
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    
    # Docker service - handled by virtualisation.docker
    
    # Bluetooth
    blueman.enable = true;
    
    # Power management
    power-profiles-daemon.enable = true;
    
    # Location services can be added if needed
    # geoclue2.enable = true; # For location services
    
    # Database services (optional - enable if needed)
    # mysql = {
    #   enable = true;
    #   package = pkgs.mariadb;
    # };
    
    # Desktop portal
    dbus.enable = true;
    
    # Greetd login manager (alternative to display managers)
    greetd = {
      enable = true;
      vt = 2;
      settings = {
        default_session = {
          command = "${pkgs.hyprland}/bin/Hyprland"; # Direct binary instead
          user = personal.user;
        };
      };
    };
    
    # Network time sync
    timesyncd.enable = true;
    
    # System monitoring
    locate = {
      enable = true;
      package = pkgs.plocate;
    };
    
    # Hardware support
    fwupd.enable = true; # Firmware updates
    
    # Input method support
    services.xserver = {
      enable = false;
    };
  };
  
  # Hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # AMD RADV drivers
      mesa
      # AMD hardware video acceleration
      libva
      libva-utils  
      # AMDGPU pro OpenCL (if needed)
      # amdgpu-pro
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa
      libva
    ];
  };

# Add AMD kernel modules
boot.initrd.kernelModules = [ "amdgpu" ];
boot.kernelModules = [ "kvm-intel" "amdgpu" ];

  programs.dconf.enable = true;
  # Gaming and graphics
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  
  # Virtualization
  virtualisation.docker.enable = true;
  
  # Explicitly disable PulseAudio since we're using PipeWire
  services.pulseaudio.enable = false;
  
  # Security configuration
  security.rtkit.enable = true;
  
  # Filesystem configuration is now handled by hardware-configuration.nix
  # The make nixos-config command will generate the proper hardware configuration
  # including filesystems, boot settings, and hardware-specific options
}
