/**
  Git 配置模块。

  Git 基础配置默认开启；
  git-ext 开启后额外启用 Git LFS、repo 和 Commitizen。
*/
{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.modules.git-ext.enable = lib.mkEnableOption "extended Git tools and configuration";

  config = {
    programs.git = {
      enable = true;
      lfs.enable = config.modules.git-ext.enable;

      settings = {
        user = {
          name = "HuaLiMao-AQ";
          email = "hualimao_aq@163.com";
        };
      };
    };

    home.packages = lib.mkIf config.modules.git-ext.enable (
      with pkgs;
      [
        git-repo
        commitizen
      ]
    );
  };
}
