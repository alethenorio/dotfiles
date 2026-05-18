{
  pkgs-unstable,
  config,
  dotfilesDir,
  ...
}:

let
  homeDir = config.home.homeDirectory;
  workspaceDir = "${homeDir}/pi-workspace";
  nodePath = pkgs-unstable.lib.makeBinPath [ pkgs-unstable.nodejs_latest ];

  pi = pkgs-unstable.writeShellScriptBin "pi" ''
    WORKDIR="$(pwd)"
    exec ${pkgs-unstable.bubblewrap}/bin/bwrap \
      --ro-bind / / \
      --dev /dev \
      --proc /proc \
      --tmpfs /tmp \
      --bind "${workspaceDir}" "${workspaceDir}" \
      --bind "$WORKDIR" "$WORKDIR" \
      --chdir "$WORKDIR" \
      --share-net \
      --setenv HOME "${workspaceDir}" \
      --setenv NPM_CONFIG_PREFIX "${workspaceDir}/.pi/npm/" \
      --setenv PATH "${nodePath}:$PATH" \
      -- ${pkgs-unstable.pi-coding-agent}/bin/pi "$@"
  '';
in
{
  home.packages = [ pi ];

  home.file."pi-workspace/.pi/agent/models.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/home-manager/pi-coding-agent/models.json";
}
