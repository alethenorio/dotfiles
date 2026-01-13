{ ... }:

{
  programs = {
    git = {
      enable = true;
      settings = {
        user.email = "2749771+alethenorio@users.noreply.github.com";
        user.name = "Alexandre Thenorio";
        alias = {
          # Get the current branch name (not so useful in itself, but used in other aliases)
          branch-name = "!git rev-parse --abbrev-ref HEAD";
          # Push the current branch to the remote "origin", and set it to track the upstream branch
          publish = "!git push -u origin $(git branch-name)";
          recent = "branch --sort=-committerdate --format=\"%(committerdate:relative)%09%(refname:short)\"";
        };
        core = {
          editor = "vim";
        };
        mergetool."vanillavim" = {
          cmd = "vim \"$MERGED\"";
        };
        merge = {
          tool = "vanillavim";
        };
        branch = {
          sort = "-committerdate";
        };
        help = {
          autocorrect = 1;
        };
        rebase = {
          autosquash = true;
          updateRefs = true;
        };
        diff = {
          # Detect copies as well as renames
          renames = 1;
          colorMoved = true;
        };
        rerere = {
          # Enables recording of merge conflicts and automatically
          # reusing resolution next time it sees the same conflict
          enabled = true;
        };
      };
    };
  };
}
