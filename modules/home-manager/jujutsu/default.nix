{
  pkgs-unstable,
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
        aliases = {
          showdesc = {
            definition = [
              "log"
              "-r"
              "@"
              "--no-graph"
              "-T"
              "description"
              "--limit"
              "1"
            ];
            doc = "Shows the current change description";
          };
        };
      };
    };
  };
}
