{ ... }:

{
  # openssh 配置
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "hualimao" ];
      MaxAuthTries = 3;
    };
  };
}
