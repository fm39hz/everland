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
  
  # Kernel parameters to handle Intel/AMD GPU conflicts
  boot.kernelParams = [
    # Disable Intel integrated graphics to avoid conflicts
    "i915.modeset=0"
    # OR alternative: set AMD as primary
    # "amdgpu.si_support=1"
    # "amdgpu.cik_support=1" 
    # Force early KMS for AMD
    "amdgpu.dc=1"
  ];
  
  # Load AMD GPU modules early and exclude Intel
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-intel" "amdgpu" ];
  boot.blacklistedKernelModules = [ "i915" ]; # Blacklist Intel graphics
  
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
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" "seat" "input" ];
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
    
    # Bluetooth
    blueman.enable = true;
    
    # Power management
    power-profiles-daemon.enable = true;
    
    # Desktop portal
    dbus.enable = true;
    
    # Seat management - CRITICAL for Wayland compositor access
    seatd = {
      enable = true;
      user = personal.user;
    };
    
    # Greetd login manager with seatd integration
    greetd = {
      enable = true;
      vt = 2;
      settings = {
        default_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
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
    
    # Disable X11 completely
    xserver.enable = false;
  };
  
  # Hardware acceleration for AMD GPU (with Intel iGPU support)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # AMD RADV drivers
      mesa
      # AMD hardware video acceleration
      libva
      libva-utils
      # Intel graphics support (if not blacklisted)
      intel-media-driver
      intel-vaapi-driver
      # AMDGPU OpenCL
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa
      libva
      intel-media-driver
    ];
  };

  # Alternative GPU configuration (comment out blacklist above and use this):
  # boot.kernelParams = [
  #   # Use both GPUs but set AMD as primary for displays
  #   "amdgpu.dc=1"
  #   "i915.enable_guc=2"
  # ];
  # boot.blacklistedKernelModules = []; # Don't blacklist anything

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
