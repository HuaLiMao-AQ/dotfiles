-- WezTerm 模块化配置入口。
-- 显式固定加载顺序，确保跨平台配置行为可预测：
-- utils -> platform -> colors -> base -> visual -> keys -> events。
local wezterm = require("wezterm")

local config = wezterm.config_builder()

local utils = require("config.utils")
local platform = require("config.platform")(wezterm, utils)
local colors = require("config.colors")(wezterm, platform, utils)

require("config.base")(config, wezterm, platform, colors, utils)
require("config.visual")(config, wezterm, platform, colors, utils)
require("config.keys")(config, wezterm, platform, colors, utils)
require("config.events")(config, wezterm, platform, colors, utils)

return config
