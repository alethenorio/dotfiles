#!/usr/bin/env bash
# Update pi-coding-agent to the latest version
#
# This script fetches the latest version from GitHub and updates package.nix
# with the correct hashes from nixpkgs master (if available there).
#
# Usage: ./update.sh [version]
#   version: Optional specific version to update to (e.g., "0.75.3")
#            If not provided, fetches the latest release from GitHub.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_NIX="$SCRIPT_DIR/package.nix"

# Get target version
if [[ $# -ge 1 ]]; then
    VERSION="$1"
else
    echo "Fetching latest version from GitHub..."
    VERSION=$(curl -s "https://api.github.com/repos/earendil-works/pi/releases/latest" | jq -r '.tag_name' | sed 's/^v//')
fi

echo "Target version: $VERSION"

# Get current version
CURRENT_VERSION=$(grep -oP 'version = "\K[^"]+' "$PACKAGE_NIX" | head -1)
echo "Current version: $CURRENT_VERSION"

if [[ "$VERSION" == "$CURRENT_VERSION" ]]; then
    echo "Already at version $VERSION"
    exit 0
fi

# Try to get hashes from nixpkgs master first
echo "Checking nixpkgs master for hashes..."
NIXPKGS_PACKAGE=$(curl -s "https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/by-name/pi/pi-coding-agent/package.nix")
NIXPKGS_VERSION=$(echo "$NIXPKGS_PACKAGE" | grep -oP 'version = "\K[^"]+' | head -1)

if [[ "$NIXPKGS_VERSION" == "$VERSION" ]]; then
    echo "Found matching version in nixpkgs master, extracting hashes..."
    HASH=$(echo "$NIXPKGS_PACKAGE" | grep -oP 'hash = "\K[^"]+' | head -1)
    NPM_DEPS_HASH=$(echo "$NIXPKGS_PACKAGE" | grep -oP 'npmDepsHash = "\K[^"]+' | head -1)
else
    echo "Version $VERSION not in nixpkgs master (has $NIXPKGS_VERSION)"
    echo "Computing hashes manually..."
    
    # Get source hash
    echo "Fetching source hash..."
    HASH=$(nix-prefetch-github earendil-works pi --rev "v$VERSION" 2>/dev/null | jq -r '.hash')
    
    # Get npm deps hash - this is trickier, need to download and compute
    echo "Computing npm deps hash (this may take a while)..."
    TMPDIR=$(mktemp -d)
    trap "rm -rf $TMPDIR" EXIT
    
    git clone --depth 1 --branch "v$VERSION" https://github.com/earendil-works/pi.git "$TMPDIR/pi" 2>/dev/null
    NPM_DEPS_HASH=$(nix-prefetch-npm-deps "$TMPDIR/pi/package-lock.json" 2>/dev/null)
fi

echo ""
echo "Updating package.nix..."
echo "  version: $VERSION"
echo "  hash: $HASH"
echo "  npmDepsHash: $NPM_DEPS_HASH"

# Update the file
sed -i \
    -e "s/version = \"[^\"]*\"/version = \"$VERSION\"/" \
    -e "s/hash = \"[^\"]*\"/hash = \"$HASH\"/" \
    -e "s/npmDepsHash = \"[^\"]*\"/npmDepsHash = \"$NPM_DEPS_HASH\"/" \
    "$PACKAGE_NIX"

echo ""
echo "Done! Run 'home-manager switch' to apply the update."
