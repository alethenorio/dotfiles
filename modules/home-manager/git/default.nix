
{ config, pkgs, lib, ...}:

{
  programs = {
    git = {
      enable = true;
      userName = "Alexandre Thenorio";
      userEmail = "2749771+alethenorio@users.noreply.github.com";
      aliases = {
        # Get the current branch name (not so useful in itself, but used in other aliases)
	      branch-name = "!git rev-parse --abbrev-ref HEAD";
        # Push the current branch to the remote "origin", and set it to track the upstream branch
	      publish = "!git push -u origin $(git branch-name)";
        recent = "branch --sort=-committerdate --format=\"%(committerdate:relative)%09%(refname:short)\"";
      };
      extraConfig = {
        core = {
          editor = "vim";
        };
        mergetool."vanillavim" = {
          cmd = "vim \"$MERGED\"";
        };
        merge = {
          tool = "vanillavim";
        };
        help = {
          autocorrect = 1;
        };
        rebase = {
          autosquash = true;
        };
        diff = {
          # Detect copies as well as renames
	        renames = 1;
        };
      };
    };
  };
}
