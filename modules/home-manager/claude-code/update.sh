#!/usr/bin/env nix
#!nix shell --ignore-environment nixpkgs#bash nixpkgs#cacert nixpkgs#coreutils nixpkgs#curl nixpkgs#nix nixpkgs#gnused --command bash

set -euo pipefail

BASE_URL="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"
DEFAULT_NIX="$(dirname "$(readlink -f "$0")")/default.nix"

latest_version=$(curl -fsSL "$BASE_URL/latest")
current_version=$(sed -n 's/^  version = "\(.*\)";$/\1/p' "$DEFAULT_NIX")

if [ "$latest_version" = "$current_version" ]; then
  echo "claude-code is already at the latest version ($current_version)"
  exit 0
fi

echo "updating claude-code: $current_version -> $latest_version"

raw_hash=$(nix-prefetch-url "$BASE_URL/$latest_version/linux-x64/claude")
sri_hash=$(nix hash convert --hash-algo sha256 --to sri "$raw_hash")

sed -i "s|^  version = \".*\";$|  version = \"$latest_version\";|" "$DEFAULT_NIX"
sed -i "s|^  hash = \".*\";$|  hash = \"$sri_hash\";|" "$DEFAULT_NIX"

echo "updated $DEFAULT_NIX"
