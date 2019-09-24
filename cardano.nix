{ config, pkgs, lib, ... }:
{
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;

  # if you have a Raspberry Pi 2 or 3, pick this:
  boot.kernelPackages = pkgs.linuxPackages;

  # A bunch of boot parameters needed for optimal runtime on RPi 3b+
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 3;
  boot.loader.raspberryPi.uboot.enable = true;

  # Extra packages
  environment.systemPackages = with pkgs; [
    vim
  ];

  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  # Wireless dongle
  networking.wireless.enable = true;
  networking.enableB43Firmware = true;
  nixpkgs.config.allowUnfree = true;

  # Jormungandr blochchain node
  services.jormungandr.enable = true;
  services.jormungandr.genesisBlockFile = "/var/lib/jormungandr/block-0.bin";
  services.jormungandr.secretFile = "/etc/secrets/jormungandr.yaml";

  # Configure basic SSH access
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  # Use 1GB of additional swap memory in order to not run out of memory
  # when installing lots of things while running other things at the same time.
  swapDevices = [ { device = "/swapfile"; size = 2048; } ];
}