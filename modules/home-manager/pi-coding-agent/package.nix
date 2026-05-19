# Override pi-coding-agent version independently of nixpkgs-unstable.
#
# To update: change `version`, `hash`, and `npmDepsHash` below, then rebuild.
#
# Get the hashes by running:
#   ./update.sh
#
# Or manually:
#   1. Check latest version: curl -s https://api.github.com/repos/earendil-works/pi/releases/latest | jq -r .tag_name
#   2. Get src hash: nix-prefetch-github earendil-works pi --rev v<VERSION>
#   3. Get npmDepsHash: nix-prefetch-npm-deps (after extracting the source)
#
# Alternatively, check nixpkgs master for the latest hashes:
#   curl -s https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/by-name/pi/pi-coding-agent/package.nix
#
# NOTE: use `npmDeps = pkgs-unstable.fetchNpmDeps { ... }` instead of `npmDepsHash = ...`
# because overrideAttrs does not propagate npmDepsHash to the internal npmDeps derivation.
#
# NOTE: postInstall only needs to be overridden when nixpkgs-unstable has a version that
# uses different workspace package names than the target version. Once nixpkgs-unstable
# reaches 0.75.3+ (uses @earendil-works/* instead of @mariozechner/*), drop postInstall.
{ pkgs-unstable }:
let
  version = "0.75.3";
  hash = "sha256-c/+cxkp/EZ2PLERxTENN5edXHEs7M2oqzNepjRA4TIE=";
  npmDepsHash = "sha256-/mWjrZFzRmtkbWYMJOXKnLPxFITFndq5hgdY0DnPfAg=";
  src = pkgs-unstable.fetchFromGitHub {
    owner = "earendil-works";
    repo = "pi";
    tag = "v${version}";
    inherit hash;
  };
in
pkgs-unstable.pi-coding-agent.overrideAttrs (old: {
  inherit version src;
  npmDeps = pkgs-unstable.fetchNpmDeps {
    inherit src;
    hash = npmDepsHash;
  };
  postInstall = ''
    local nm="$out/lib/node_modules/pi-monorepo/node_modules"

    for ws in @earendil-works/pi-ai:packages/ai \
              @earendil-works/pi-agent-core:packages/agent \
              @earendil-works/pi-tui:packages/tui; do
      IFS=: read -r pkg src <<< "$ws"
      rm "$nm/$pkg"
      cp -r "$src" "$nm/$pkg"
    done

    find "$nm" -type l -lname '*/packages/*' -delete
    find "$nm/.bin" -xtype l -delete
  '';
})
