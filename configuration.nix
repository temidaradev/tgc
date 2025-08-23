{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables=false;

  boot.loader = {
    timeout = 10;

    efi = {
      efiSysMountPoint = "/boot";
    };

    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true; # Otherwise /boot/EFI/BOOT/BOOTX64.EFI isn't generated
      devices = ["nodev"];
      useOSProber = true;
      extraEntriesBeforeNixOS = false;
      extraEntries = ''
        menuentry "Reboot" {
          reboot
        }
        menuentry "Poweroff" {
          halt
        }
      '';
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.cloudflare-warp.enable = true;
  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Istanbul";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "tr";
    variant = "";
  };

  console.keyMap = "trq";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users.temidaradev = {
    isNormalUser = true;
    description = "temidaradev";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      thunderbird
    ];
    shell = pkgs.zsh;
  };


  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "temidaradev";

  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    zsh
    neovim
    rustc
    cargo
    zig
    go
    gcc
    btop
    lua
    uv
    python312
    zlib
    stdenv.cc.cc.lib
    git
    wine
    glfw
    odin
    gnumake
    ghostty
    kitty
    mesa
    discord
    blender
    godot
    helix
    pkgs.lunar-client
    pkgs.cloudflare-warp
    pkgs.vmware-workstation
    pkgs.telegram-desktop
    pkgs.youtube-music
    pkgs.jetbrains.rust-rover
    pkgs.jetbrains.goland
    pkgs.jetbrains.clion
    pkgs.zed-editor
    pkgs.vscode
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.openssh.enable = true;

  system.stateVersion = "25.05";
}
