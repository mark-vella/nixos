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
    };

    packages = with pkgs; [
      kitty
    ];
  };

  programs.home-manager.enable = true;
}
