{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:

{
  programs = {
    jujutsu = {
      enable = true;
      package = pkgs-unstable.jujutsu;
      settings = {
        user = {
          name = "Alexandre Thenorio";
          email = "2749771+alethenorio@users.noreply.github.com";
        };
      };
    };
  };
}
