{
  config,
  pkgs,
  lib,
  ...
}:

let
  unstable = import <unstable> {
    config = {
      allowUnfree = true;
    };
  };
in
{
  programs = {
    jujutsu = {
      enable = true;
      package = unstable.pkgs.jujutsu;
      settings = {
        user = {
          name = "Alexandre Thenorio";
          email = "2749771+alethenorio@users.noreply.github.com";
        };
      };
    };
  };
}
