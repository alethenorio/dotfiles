# Gaming Setup - ThinkPad X1 Gen 13

## Validate the flake

```bash
cd /home/alethenorio/code/dotfiles
nix flake check 'git+file:///home/alethenorio/code/dotfiles?dir=configs/thinkpad-x1-gen13-gaming&submodules=1'
```

## Build and switch NixOS

```bash
cd /home/alethenorio/code/dotfiles
sudo nixos-rebuild switch --flake 'git+file:///home/alethenorio/code/dotfiles?dir=configs/thinkpad-x1-gen13-gaming&submodules=1'
```

## Build and switch Home Manager

```bash
cd /home/alethenorio/code/dotfiles
home-manager switch --flake 'git+file:///home/alethenorio/code/dotfiles?dir=configs/thinkpad-x1-gen13-gaming&submodules=1'
```

### 6. Update flake inputs (optional)

To update all pinned dependencies to latest:

```bash
nix flake update 'git+file:///home/alethenorio/code/dotfiles?dir=configs/thinkpad-x1-gen13-gaming&submodules=1'
```

## Rollback: Reverting from Flakes to Channels

If something goes wrong after switching to flakes and you need to go back to the channel-based setup:

1. Reboot and select a previous NixOS generation from the boot menu
2. After booting into the old generation, NixOS will still think it's using flakes and won't find `nixos-config`. Run:

```bash
sudo nixos-rebuild switch -I nixos-config=/etc/nixos/configuration.nix
```

This explicitly tells `nixos-rebuild` where the channel-based configuration is, bypassing the flake lookup.

See https://discourse.nixos.org/t/revert-from-flakes-to-channels/46179/11 for details.
