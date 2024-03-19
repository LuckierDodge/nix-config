{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./home.nix
  ];
  # nix.settings = {
  #   # Enable flakes and new 'nix' command
  #   experimental-features = "nix-command flakes";
  #   # Deduplicate and optimize nix store
  #   auto-optimise-store = true;
  # };
}