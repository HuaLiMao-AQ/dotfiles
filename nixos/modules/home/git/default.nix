{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "HuaLiMao-AQ";
        email = "hualimao_aq@163.com";
      };
    };
  };
}
