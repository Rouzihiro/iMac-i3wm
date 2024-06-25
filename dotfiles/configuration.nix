{ config, pkgs, ... }:

{
  imports = [
    ./applications.nix
    #./fritz.nix
    ./hardware-configuration.nix
    #./AMD2.nix
    ./AMD-Radeon.nix
    ./sound.nix
    ./zram.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    hostName = "rey";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "de_DE.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
    LC_CTYPE = "en_US.utf8"; # Required by dmenu, don't change this
  };

  sound.enable = true;

  services = {
    xserver = {
      xkb.layout = "de";
      xkb.variant = "";
      enable = true;
      windowManager.i3.enable = true;
      windowManager.i3.extraPackages = with pkgs; [ i3status ];
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      displayManager.defaultSession = "none+i3";
      displayManager.lightdm.enable = true;
    };
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
  };

  users.users.rey = {
    isNormalUser = true;
    description = "rey";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      thunderbird
      firefox
      xarchiver
    ];
  };

  environment.systemPackages = with pkgs; [
    alacritty
    dmenu
    git
    gnome.gnome-keyring
    nerdfonts
    networkmanagerapplet
    nitrogen
    pasystray
    picom
    polkit_gnome
    pulseaudioFull
    rofi
    vim
    unrar
    unzip
  ];

  programs = {
    thunar.enable = true;
    dconf.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  systemd.user.services."polkit-gnome-authentication-agent-1" = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  
  hardware.bluetooth.enable = true;

  system.stateVersion = "23.11";
}
