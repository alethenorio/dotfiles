{ pkgs-unstable, config, ... }:

{
  home.packages = with pkgs-unstable; [
    (pkgs-unstable.symlinkJoin {
      name = "pi-coding-agent";
      buildInputs = [ pkgs-unstable.makeWrapper ];
      paths = [ pkgs-unstable.pi-coding-agent ];
      postBuild = ''
        wrapProgram $out/bin/pi \
          --set NPM_CONFIG_PREFIX ${config.home.homeDirectory}/.pi/npm/ \
          --prefix PATH : ${pkgs-unstable.lib.makeBinPath [ pkgs-unstable.nodejs_latest ]}
      '';
    })
  ];
}
