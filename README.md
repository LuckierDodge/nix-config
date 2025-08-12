# nix-configs

System configurations using nix.

## Update Commands

```
# Nix OS
sudo nixos-rebuild switch --impure --flake .#killingtime
# Home Manager
home-manager --flake .#luckierdodge@cerberus switch
# Darwin
sudo darwin-rebuild switch --flake .#primemover
```
