{ pkgs-unstable }:
pkgs-unstable.buildGoModule rec {
  pname = "claudeline";
  version = "0.23.0";

  src = pkgs-unstable.fetchFromGitHub {
    owner = "fredrikaverpil";
    repo = "claudeline";
    rev = "v${version}";
    hash = "sha256-VogE3MAc/EGdokvm/bThqH/gJ/sJXV9FR8JBWjgF7LE=";
  };

  subPackages = ".";

  vendorHash = null;

  # nixpkgs-unstable currently ships Go 1.26.1, but upstream go.mod requires
  # 1.26.2. The project has no dependencies, so relaxing the directive is safe.
  postPatch = ''
    substituteInPlace go.mod --replace-fail "go 1.26.2" "go 1.26.1"
  '';

  ldflags = [ "-s" ];
}
