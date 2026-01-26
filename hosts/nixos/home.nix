{ config, pkgs, inputs, ... }:
let
  userName = "mark";
  homeDirectory = "/home/${userName}";
  stateVersion = "25.11";
in
{
  home = {
    username = userName;
    homeDirectory = homeDirectory;
    stateVersion = stateVersion;

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "kitty";

      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };

    packages = with pkgs; [
      kitty
      rofi
      yazi
      hyprpaper
      hyprshot
      swww
      swappy
      imv
      brightnessctl
      playerctl
      wlogout
      networkmanagerapplet
      pavucontrol
      cliphist
    ];

    file = {
      ".config/hypr".source = ../../dotfiles/.config/hypr;
      ".config/waybar".source = ../../dotfiles/.config/waybar;
    };
  };

  programs.home-manager.enable = true;
}
