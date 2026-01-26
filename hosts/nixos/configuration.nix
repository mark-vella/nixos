{ config, lib, pkgs, inputs, ... }:
let
  username = "mark";
  userDescription = "Mark Vella";
  homeDirectory = "/home/${username}";
  hostName = "nixos";
  timeZone = "Europe/Malta";
in
{
  imports = [
    ../../hardware-configuration.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = hostName;
    networkmanager.enable = true;
  };

  time.timeZone = timeZone;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "mt_MT.UTF-8";
      LC_IDENTIFICATION = "mt_MT.UTF-8";
      LC_MEASUREMENT = "mt_MT.UTF-8";
      LC_MONETARY = "mt_MT.UTF-8";
      LC_NAME = "mt_MT.UTF-8";
      LC_NUMERIC = "mt_MT.UTF-8";
      LC_PAPER = "mt_MT.UTF-8";
      LC_TELEPHONE = "mt_MT.UTF-8";
      LC_TIME = "mt_MT.UTF-8";
    };
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = userDescription;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    bun
    docker
    git
    lazydocker
    lazygit
    neovim
    nodejs_24
    opencode
    pgtop
    powertop
    ripgrep
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  system.stateVersion = "25.11";
}
