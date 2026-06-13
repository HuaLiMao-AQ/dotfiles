{ pkgs, ... }:

{
  # 时区
  time.timeZone = "Asia/Shanghai";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
  };

  fonts = {
    packages = with pkgs; [
      # 拉丁字符及通用 Unicode
      noto-fonts

      # 中日韩字体
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # 彩色 Emoji
      noto-fonts-color-emoji

      # 终端、编辑器与图标
      maple-mono.NF-CN
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];

    fontconfig = {
      enable = true;

      defaultFonts = {
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK SC"
        ];

        serif = [
          "Noto Serif"
          "Noto Serif CJK SC"
        ];

        monospace = [
          "Maple Mono NF CN"
          "JetBrainsMono Nerd Font"
          "Noto Sans CJK SC"
        ];

        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };

  # Linux 虚拟控制台
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
}
