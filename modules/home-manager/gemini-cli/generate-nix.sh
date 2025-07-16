#!/usr/bin/env bash

nix-shell -p nodePackages.npm -p nodePackages.node2nix --run "node2nix"
