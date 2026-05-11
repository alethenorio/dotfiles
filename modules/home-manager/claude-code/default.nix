# Override claude-code version independently of nixpkgs-unstable.
#
# To update: change `version` and `hash` below, then rebuild.
# Get the hash with:
#   nix-prefetch-url "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/<VERSION>/linux-x64/claude"
# Then convert to SRI:
#   nix hash convert --hash-algo sha256 --to sri <hash>
{ pkgs-unstable }:
let
  version = "2.1.138";
  hash = "sha256-w8Vv+8Es8W5AwzaHyf5jYe0lDDWp4XGNDDjUkEn1+MM=";
in
pkgs-unstable.claude-code-bin.overrideAttrs (old: {
  inherit version;
  src = pkgs-unstable.fetchurl {
    url = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${version}/linux-x64/claude";
    inherit hash;
  };
})
