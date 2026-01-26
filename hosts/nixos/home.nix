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
    ];

    file = {
      ".config/hypr/hyprland.conf".source = ../../dotfiles/.config/hypr/hyprland.conf;
      ".config/hypr/themes.conf".source = ../../dotfiles/.config/hypr/themes.conf;
      ".config/hypr/hyprpaper.conf".source = ../../dotfiles/.config/hypr/hyprpaper.conf;
    };
  };

  programs.home-manager.enable = true;
}
