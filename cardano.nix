{ config, pkgs, lib, ... }:
{

  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
 
  # !!! If your board is a Raspberry Pi 1, select this:
  # boot.kernelPackages = pkgs.linuxPackages_rpi;
  # !!! Otherwise (even if you have a Raspberry Pi 2 or 3), pick this:
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # !!! This is only for ARMv6 / ARMv7. Don't enable this on AArch64, cache.nixos.org works there.
  # nix.binaryCaches = lib.mkForce [ "http://nixos-arm.dezgeg.me/channel" ];
  # nix.binaryCachePublicKeys = [ "nixos-arm.dezgeg.me-1:xBaUKS3n17BZPKeyxL4JfbTqECsT+ysbDJz29kLFRW0=%" ];

  # !!! Needed for the virtual console to work on the RPi 3, as the default of 16M doesn't seem to be enough.
  boot.kernelParams = ["cma=128M"];

  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
    };
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
  # services.jormungandr.enable = true;
  # services.jormungandr.genesisBlockFile = "/var/lib/jormungandr/block-0.bin";
  # services.jormungandr.secretFile = "/etc/secrets/jormungandr.yaml";


  # Preserve space by sacrificing documentation and history
  services.nixosManual.enable = false;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";
  boot.cleanTmpDir = true;

  # Configure basic SSH access
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
 

  # if you use pulseaudio
  nixpkgs.config.pulseaudio = true;

  environment.systemPackages = with pkgs; [
    raspberrypi-tools
    wget
    binutils
    mc
    nix
    gitAndTools.gitFull
    vim
    #firefox-bin
    #chromium
    tmux
    #haskellPackages.xmonad
    #haskellPackages.xmobar
    xfontsel
    xlsfonts
    xscreensaver
    awesome
    dmenu
    xclip
    lilyterm
  ];
 
  services.xserver = {
    enable = true;
    layout = "us";
    
    videoDrivers = ["modesetting"];

  #  #windowManager.xmonad = {
  #  #  enable = true;
  #  #  enableContribAndExtras = true;
  #  #};
    
    windowManager.awesome = {
       enable = true;
    };

    windowManager.default = "awesome";

    displayManager = {
      slim = {
        enable = true;
        defaultUser = "alex";
      };
    };
  };

  programs.ssh.startAgent = true;

  users.extraUsers.alex = {
    isNormalUser = true;
    uid = 1000;
  };  

  system.stateVersion = "unstable";

  # Use 1GB of additional swap memory in order to not run out of memory
  # when installing lots of things while running other things at the same time.
  swapDevices = [ { device = "/swapfile"; size = 2048; } ];
}
