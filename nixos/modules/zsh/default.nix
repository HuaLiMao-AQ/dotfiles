# modules/zsh/default.nix
{ pkgs, lib, config, ... }:
with lib;

let
  cfg = config.modules.zsh;

  # 仓库内 zsh/config 真实路径（与 nvim 模块同口径）
  # 用 mkOutOfStoreSymlink：改完模块文件无需 rebuild 即生效
  # 跨机部署时确保 dotfiles 克隆到同一路径
  dotfilesZshConfig = "${config.home.homeDirectory}/Configure/dotfiles/zsh/config";
in
{
  options.modules.zsh.enable = mkEnableOption "zsh";

  config = mkIf cfg.enable {
    # 工具链：与 aliases.zsh / zi.zsh 的降级判定保持一致
    home.packages = with pkgs; [
      git
      curl
      fzf
      eza
      bat
      ripgrep
      fd
    ];

    # 把仓库的 zsh/config 部署到 ~/.config/zsh/config（可写软链）
    xdg.configFile."zsh/config".source =
      config.lib.file.mkOutOfStoreSymlink dotfilesZshConfig;

    programs.zsh = {
      enable = true;

      # 这些功能由我们的模块（completion.zsh / plugins.zsh）通过 zi 提供，
      # 关闭 HM 内置版本，避免重复 compinit 与重复加载插件
      enableCompletion = false;
      autosuggestion.enable = false;
      syntaxHighlighting.enable = false;
      historySubstringSearch.enable = false;

      # NixOS 入口：直接指向 HM 部署的 config 目录，不依赖 %x 自动解析
      initContent = ''
        export ZSH_CONFIG_HOME="$HOME/.config/zsh/config"
        if [[ -r "$ZSH_CONFIG_HOME/init.zsh" ]]; then
          source "$ZSH_CONFIG_HOME/init.zsh"
        fi
      '';
    };
  };
}
