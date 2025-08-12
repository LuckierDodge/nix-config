# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration-bigbox.nix
    ./configuration.nix
    #    <sops-nix/modules/sops>
  ];

  environment.systemPackages = with pkgs; [
    samba
  ];

  # Set hostname
  networking.hostName = "bigbox";

  #sops.defaultSopsFile = ../secrets/samba.yaml;
  sops.age.keyFile = "/home/luckierdodge/.config/sops/age/keys.txt";
  sops.age.generateKey = false;
  sops.secrets.samba_password = {
    format = "yaml";
    sopsFile = ../secrets/samba.yaml;
  };

  fileSystems."/home/luckierdodge/storage" = {
    device = "/dev/raid-vg/storage";
    fsType = "ext4";
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "server string" = "bigbox";
        "server role" = "standalone server";
        "netbios name" = "bigbox";
        "security" = "user";
      };
      "havoc-data" = {
        "path" = "/home/luckierdodge/storage/havoc-data";
        "read only" = false;
        "guest ok" = "no";
        "browseable" = "yes";
      };
      "media-storage" = {
        "path" = "/home/luckierdodge/storage/media-storage";
        "read only" = false;
        "guest ok" = "no";
        "browseable" = "yes";
      };
      "killingtime-backup" = {
        "path" = "/home/luckierdodge/storage/killingtime-backup";
        "read only" = false;
        "guest ok" = "no";
        "browseable" = "yes";
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
