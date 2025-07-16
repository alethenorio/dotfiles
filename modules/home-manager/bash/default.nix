
{ config, pkgs, lib, ...}:

{
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        g = "git";
      };
      # Larger bash history (allow 32³ entries; default is 500)
      historySize = 50000000;
      historyFileSize = 50000000;
      historyControl = [ "ignoredups" "ignorespace" ];
      # workaround to get the EDITOR env set.
      # Assigning sessionVariables does not work
      initExtra =
      let
        prompt = (builtins.readFile  ./.bash_prompt);
      in ''
        export EDITOR="vim"

        # Don't clear the screen after quitting a manual page
        export MANPAGER="less -X";

        ${prompt}
      '';
    };
  };

  home.file.".bash_completion" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      #
      # Automatically adds branch name and branch description to every commit message.
      # Modified from the stackoverflow answer here: http://stackoverflow.com/a/11524807/151445
      #

      for bcfile in ~/.bash_completion.d/* ; do
        [ -f "$bcfile" ] && . $bcfile
      done
    '';
  };
}
