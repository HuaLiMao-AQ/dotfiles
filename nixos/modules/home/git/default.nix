{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    
    # 启用 git-lfs
    lfs.enable = true;

    settings = {
      user = {
        name = "HuaLiMao-AQ";
        email = "hualimao_aq@163.com";
      };
    };
  };
}
