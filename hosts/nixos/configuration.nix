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
    ./hardware-configuration.nix
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
  };
  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "hyprland";
  services.desktopManager.gnome.enable = true;

  services.printing.enable = true;

  services.pulseaudio.enable = false;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
  };

  users.users.${username} = {
    isNormalUser = true;
    description = userDescription;
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
  };

  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Core tools
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
    starship
    zoxide
    fzf
    tmux
    eza
    bat

    # Development tools
    go
    lua
    python3
    python3Packages.pip
    clang
    zig
    rustup
    nodePackages_latest.pnpm
    nodePackages_latest.yarn
    gcc
    openssl
    gnumake
    meson
    ninja
    coreutils

    # File management and archives
    thunar
    thunar-archive-plugin
    thunar-volman
    yazi
    p7zip
    unzip
    zip
    unrar
    file-roller
    ncdu
    duf

    # System monitoring
    htop
    btop
    lm_sensors
    inxi

    # Network and internet
    aria2
    qbittorrent
    tailscale

    # Audio and video
    pulseaudio
    pavucontrol
    ffmpeg
    mpv

    # Image and graphics
    imagemagick
    gimp
    hyprpicker
    swww
    imv
    swappy

    # Productivity and office
    obsidian
    libreoffice-qt6-fresh

    # Communication and social
    telegram-desktop
    vesktop
    element-desktop

    # Browsers
    firefox

    # System utilities
    libgcc
    bc
    libnotify
    v4l-utils
    socat
    pkg-config
    brightnessctl
    playerctl
    appimage-run
    yad

    # Wayland specific
    hyprshot
    grim
    slurp
    waybar
    dunst
    wl-clipboard
    cliphist

    # Virtualization
    libvirt
    qemu
    virt-manager
    spice
    spice-gtk
    spice-protocol
    OVMF

    # File systems
    ntfs3g
    os-prober

    # Downloaders
    yt-dlp

    # Fun and customization
    cmatrix
    lolcat
    fastfetch

    # Education
    wireshark

    # Music
    pear-desktop
    spotify
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  services = {
    libinput.enable = true;
    upower.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    thermald.enable = true;
    gnome.gnome-keyring.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        runAsRoot = true;
      };
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
  };

  services.blueman.enable = true;

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts-color-emoji
    fira-sans
    roboto
    noto-fonts-cjk-sans
    font-awesome
    material-icons
  ];

  xdg.mime.defaultApplications = {
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/chrome" = "firefox.desktop";
    "text/html" = "firefox.desktop";
    "application/x-extension-htm" = "firefox.desktop";
    "application/x-extension-html" = "firefox.desktop";
    "application/x-extension-shtml" = "firefox.desktop";
    "application/x-extension-xhtml" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "inode/directory" = "thunar.desktop";
    "text/plain" = "nvim.desktop";
    "x-scheme-handler/terminal" = "kitty.desktop";
    "video/quicktime" = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";
    "application/pdf" = "firefox.desktop";
    "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
    "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";
  };

  system.stateVersion = "25.11";
}
