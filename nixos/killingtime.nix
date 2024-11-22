# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
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
    ./hardware-configuration-killingtime.nix
    ./configuration.nix
#    <sops-nix/modules/sops>
  ];

  environment.systemPackages = with pkgs; [
    # openjdk17_headless
  ];

  # Set hostname
  networking.hostName = "killingtime";

  #sops.defaultSopsFile = ../secrets/samba.yaml;
 sops.age.keyFile = "/home/luckierdodge/.config/sops/age/keys.txt";
 sops.age.generateKey = false;
 sops.secrets.samba_password = {
   format = "yaml";
   sopsFile = ../secrets/samba.yaml;
 };

  # TODO: Filesystems
  fileSystems = {
    "/home/luckierdodge/havoc-data" = {
      device = "//bigbox/havoc-data";
      fsType = "cifs";
      options = [
        "vers=3.0"
        "username=luckierdodge"
        "password=${builtins.readFile /run/secrets/samba_password}"
        "uid=1000"
        "gid=100"
        "iocharset=utf8"
        "forceuid"
        "forcegid"
        "file_mode=0777"
        "dir_mode=0777"
        "noperm"
      ];
    };
    "/home/luckierdodge/media-storage" = {
      device = "//bigbox/media-storage";
      fsType = "cifs";
      options = [
        "vers=3.0"
        "username=luckierdodge"
        "password=${builtins.readFile /run/secrets/samba_password}"
        "uid=1000"
        "gid=100"
        "iocharset=utf8"
        "forceuid"
        "forcegid"
        "file_mode=0777"
        "dir_mode=0777"
        "noperm"
      ];
    };
    "/home/luckierdodge/killingtime-backup" = {
      device = "//bigbox/killingtime-backup";
      fsType = "cifs";
      options = [
        "vers=3.0"
        "username=luckierdodge"
        "password=${builtins.readFile /run/secrets/samba_password}"
        "uid=1000"
        "gid=100"
        "iocharset=utf8"
        "forceuid"
        "forcegid"
        "file_mode=0777"
        "dir_mode=0777"
        "noperm"
      ];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

}
