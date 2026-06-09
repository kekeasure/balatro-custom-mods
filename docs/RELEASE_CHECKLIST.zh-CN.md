# 发布检查清单

[English version](./RELEASE_CHECKLIST.md)

发布到 GitHub Releases 或 Nexus Mods 前，按这份清单复查。

## 文件

- `BalatroStepBack/manifest.json` 中的版本号和作者正确。
- `BalatroScorePreview/manifest.json` 中的版本号和作者正确。
- 每个模组文件夹只包含用户需要的文件：`manifest.json`、`main.lua`、`README.md`、`README.zh-CN.md`。
- 不包含 Balatro 游戏文件、Lovely 文件、Steamodded 文件、生成 dump、日志、截图、存档或个人本机路径。

## 打包

- `BalatroStepBack-<version>.zip` 解压后第一层有 `BalatroStepBack/manifest.json`。
- `BalatroScorePreview-<version>.zip` 解压后第一层有 `BalatroScorePreview/manifest.json`。
- 解压后不会多出额外嵌套文件夹。

## 本地验证

- 使用 Lovely 和 Steamodded 启动 Balatro。
- 确认两个模组都出现在 Steamodded 模组列表中。
- 测试 Balatro Step Back：
  - 出牌或弃牌一次。
  - 点击 `回退`。
  - 打开 `记录` 并恢复到更早的检查点。
- 测试 Balatro Score Preview：
  - 选择手牌并确认出现 `参考值：...`。
  - 测试至少一种普通小丑牌计分情况。
  - 测试一种概率情况，例如 Lucky Card，并确认预览使用“不触发”的参考值。

## Nexus 页面

- 写明依赖：Lovely 和 Steamodded / SMODS。
- 写明安装路径：`%AppData%\Balatro\Mods`。
- 写明已知限制和兼容性风险。
- 附上 GitHub 仓库链接。
- 不要宣称兼容所有模组。
- 不要包含受版权保护的游戏文件或第三方资产。
