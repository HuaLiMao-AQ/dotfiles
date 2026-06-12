# modules/zsh/default.nix
{ pkgs, lib, config, ... }:
with lib;

{
  options.modules.zsh.enable = mkEnableOption "zsh";

  config = mkIf config.modules.zsh.enable {
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
