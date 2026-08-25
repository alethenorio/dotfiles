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
{ pkgs-unstable }:
let
  version = "0.84.2";
  hash = "sha256-d29ft9otYxdHRWYIAX8KMHPpppToX9ME5LbPb1rPcYo=";
  npmDepsHash = "sha256-6J5Efe+6ptCuR3VZojwYPZO8BBnnZsOQ4OAeB64uYOY=";
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
})
