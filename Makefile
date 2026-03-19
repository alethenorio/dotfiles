REPO := $(CURDIR)

FLAKE_BASE := git+file://$(REPO)

FLAKE_THINKPAD_X1_GEN13 := $(FLAKE_BASE)?dir=configs/thinkpad-x1-gen13&submodules=1
FLAKE_HARKNESS := $(FLAKE_BASE)?dir=configs/harkness-asus-maximus&submodules=1
FLAKE_GAMING := $(FLAKE_BASE)?dir=configs/thinkpad-x1-gen13-gaming&submodules=1

.PHONY: help
help:
	@echo "Available targets:"
	@echo ""
	@echo "  thinkpad-x1-gen13:"
	@echo "    nixos-build-thinkpad-x1-gen13"
	@echo "    nixos-switch-thinkpad-x1-gen13"
	@echo "    home-manager-build-thinkpad-x1-gen13"
	@echo "    home-manager-switch-thinkpad-x1-gen13"
	@echo "    flake-check-thinkpad-x1-gen13"
	@echo "    flake-update-thinkpad-x1-gen13"
	@echo ""
	@echo "  harkness-asus-maximus:"
	@echo "    nixos-build-harkness-asus-maximus"
	@echo "    nixos-switch-harkness-asus-maximus"
	@echo "    home-manager-build-harkness-asus-maximus"
	@echo "    home-manager-switch-harkness-asus-maximus"
	@echo "    flake-check-harkness-asus-maximus"
	@echo "    flake-update-harkness-asus-maximus"
	@echo ""
	@echo "  thinkpad-x1-gen13-gaming:"
	@echo "    nixos-build-thinkpad-x1-gen13-gaming"
	@echo "    nixos-switch-thinkpad-x1-gen13-gaming"
	@echo "    home-manager-build-thinkpad-x1-gen13-gaming"
	@echo "    home-manager-switch-thinkpad-x1-gen13-gaming"
	@echo "    flake-check-thinkpad-x1-gen13-gaming"
	@echo "    flake-update-thinkpad-x1-gen13-gaming"

# =============================================================================
# thinkpad-x1-gen13 (--impure needed for crowdstrike)
# =============================================================================

.PHONY: nixos-build-thinkpad-x1-gen13
nixos-build-thinkpad-x1-gen13:
	sudo nixos-rebuild build --flake '$(FLAKE_THINKPAD_X1_GEN13)' --impure

.PHONY: nixos-switch-thinkpad-x1-gen13
nixos-switch-thinkpad-x1-gen13:
	sudo nixos-rebuild switch --flake '$(FLAKE_THINKPAD_X1_GEN13)' --impure

.PHONY: home-manager-build-thinkpad-x1-gen13
home-manager-build-thinkpad-x1-gen13:
	home-manager build --flake '$(FLAKE_THINKPAD_X1_GEN13)'

.PHONY: home-manager-switch-thinkpad-x1-gen13
home-manager-switch-thinkpad-x1-gen13:
	home-manager switch --flake '$(FLAKE_THINKPAD_X1_GEN13)'

.PHONY: flake-check-thinkpad-x1-gen13
flake-check-thinkpad-x1-gen13:
	nix flake check '$(FLAKE_THINKPAD_X1_GEN13)' --impure

.PHONY: flake-update-thinkpad-x1-gen13
flake-update-thinkpad-x1-gen13:
	nix flake update --flake '$(FLAKE_THINKPAD_X1_GEN13)'

# =============================================================================
# harkness-asus-maximus
# =============================================================================

.PHONY: nixos-build-harkness-asus-maximus
nixos-build-harkness-asus-maximus:
	sudo nixos-rebuild build --flake '$(FLAKE_HARKNESS)'

.PHONY: nixos-switch-harkness-asus-maximus
nixos-switch-harkness-asus-maximus:
	sudo nixos-rebuild switch --flake '$(FLAKE_HARKNESS)'

.PHONY: home-manager-build-harkness-asus-maximus
home-manager-build-harkness-asus-maximus:
	home-manager build --flake '$(FLAKE_HARKNESS)'

.PHONY: home-manager-switch-harkness-asus-maximus
home-manager-switch-harkness-asus-maximus:
	home-manager switch --flake '$(FLAKE_HARKNESS)'

.PHONY: flake-check-harkness-asus-maximus
flake-check-harkness-asus-maximus:
	nix flake check '$(FLAKE_HARKNESS)'

.PHONY: flake-update-harkness-asus-maximus
flake-update-harkness-asus-maximus:
	nix flake update --flake '$(FLAKE_HARKNESS)'

# =============================================================================
# thinkpad-x1-gen13-gaming
# =============================================================================

.PHONY: nixos-build-thinkpad-x1-gen13-gaming
nixos-build-thinkpad-x1-gen13-gaming:
	sudo nixos-rebuild build --flake '$(FLAKE_GAMING)'

.PHONY: nixos-switch-thinkpad-x1-gen13-gaming
nixos-switch-thinkpad-x1-gen13-gaming:
	sudo nixos-rebuild switch --flake '$(FLAKE_GAMING)'

.PHONY: home-manager-build-thinkpad-x1-gen13-gaming
home-manager-build-thinkpad-x1-gen13-gaming:
	home-manager build --flake '$(FLAKE_GAMING)'

.PHONY: home-manager-switch-thinkpad-x1-gen13-gaming
home-manager-switch-thinkpad-x1-gen13-gaming:
	home-manager switch --flake '$(FLAKE_GAMING)'

.PHONY: flake-check-thinkpad-x1-gen13-gaming
flake-check-thinkpad-x1-gen13-gaming:
	nix flake check '$(FLAKE_GAMING)'

.PHONY: flake-update-thinkpad-x1-gen13-gaming
flake-update-thinkpad-x1-gen13-gaming:
	nix flake update --flake '$(FLAKE_GAMING)'
