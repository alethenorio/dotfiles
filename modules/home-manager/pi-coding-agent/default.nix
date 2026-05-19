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

  # Use our overridden pi-coding-agent with the latest version
  pi-coding-agent = import ./package.nix { inherit pkgs-unstable; };

  pi = pkgs-unstable.writeShellScriptBin "pi" ''
    WORKDIR="$(pwd)"
    exec ${pkgs-unstable.bubblewrap}/bin/bwrap \
      --ro-bind / / \
      --dev /dev \
      --proc /proc \
      --tmpfs /tmp \
      --bind "${workspaceDir}" "${workspaceDir}" \
      --bind "$WORKDIR" "$WORKDIR" \
      --bind "${homeDir}/.pi" "${workspaceDir}/.pi" \
      --bind "${homeDir}/.config/gcloud" "${workspaceDir}/.config/gcloud" \
      --chdir "$WORKDIR" \
      --share-net \
      --setenv HOME "${workspaceDir}" \
      --setenv NPM_CONFIG_PREFIX "${workspaceDir}/.pi/npm/" \
      --setenv PATH "${nodePath}:$PATH" \
      -- ${pi-coding-agent}/bin/pi "$@"
  '';
in
{
  home.packages = [ pi ];

  home.file.".pi/agent/extensions/vertex-anthropic".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/home-manager/pi-coding-agent/extensions/vertex-anthropic";

  home.file.".pi/agent/extensions/status-line".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/home-manager/pi-coding-agent/extensions/status-line";
}
