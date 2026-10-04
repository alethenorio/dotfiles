# Override claude-code version independently of nixpkgs-unstable.
#
# To update: change `version` and `hash` below, then rebuild.
# Get the hash with:
#   nix-prefetch-url "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/<VERSION>/linux-x64/claude"
# Then convert to SRI:
#   nix hash convert --hash-algo sha256 --to sri <hash>
#
# NOTE: `claude-code-bin` was merged into `claude-code` in nixpkgs. The
# current `claude-code` derivation fetches a zstd-compressed artifact from
# downloads.claude.ai and decompresses it with `unzstd` in installPhase, but
# the GCS URL above still serves a plain ELF binary. installPhase below
# patches that one line back to a plain `install`, keeping the rest
# (wrapProgram flags etc.) inherited from nixpkgs unchanged.
{ pkgs-unstable }:
let
  version = "2.1.284";
  hash = "sha256-XNkKq9g/ihUTbDWqN7sdkrNImTVzMWZD3D/k4Er7+I8=";
in
pkgs-unstable.claude-code-bin.overrideAttrs (old: {
  inherit version;
  src = pkgs-unstable.fetchurl {
    url = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${version}/linux-x64/claude";
    inherit hash;
  };
  installPhase = builtins.replaceStrings [ "unzstd -q $src -o $out/bin/claude" ] [
    "install -m755 $src $out/bin/claude"
  ] old.installPhase;
})
