{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

{
  options.modules.nvim = {
    enable = mkEnableOption "nvim";
  };

  config = mkIf config.modules.nvim.enable {
    home.packages = with pkgs; [
      # lazy.nvim / 插件管理
      git
      curl
      wget
      unzip
      gnutar
      gzip

      # treesitter 编译
      tree-sitter
      gcc
      gnumake
      pkg-config

      # 常用外部工具
      ripgrep
      fd
      fzf
      bat
      eza
      lazygit

      # 语言运行时 / Mason 常用
      nodejs
      python3
      go
      rustup
      jdk21

      # 剪贴板
      xclip
      wl-clipboard
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

  };
}
