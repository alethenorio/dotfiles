{ ... }:

{
  # When using Ghostty, some dead keys (such as ~ on a Swedish keyboard) don't work
  # so we need to add something like fcitx5.
  # See https://github.com/ghostty-org/ghostty/discussions/8899 for more details.
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
  };

  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    settings = {
      theme = "";
      copy-on-select = "clipboard";
      scrollback-limit = 100000000000;
    };
  };
}
