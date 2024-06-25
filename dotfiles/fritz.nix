{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  fileSystems."/mnt/smb" = {
    device = "//192.168.178.1/FRITZ.NAS";
    fsType = "cifs";
    options = [ "credentials=/etc/samba/creds" "rw" "uid=1000" "gid=100" ]; 
  };
}
