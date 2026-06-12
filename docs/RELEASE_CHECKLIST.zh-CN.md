# 发布检查清单

[English version](./RELEASE_CHECKLIST.md)

发布到 GitHub Releases 或 Nexus Mods 前，按这份清单复查。

## 文件

- `BalatroStepBack/manifest.json` 中的版本号和作者正确。
- `BalatroShopUndo/manifest.json` 中的版本号和作者正确。
- `BalatroScorePreview/manifest.json` 中的版本号和作者正确。
- `BalatroModifierWarning/manifest.json` 中的版本号和作者正确。
- 每个模组文件夹只包含用户需要的文件：`manifest.json`、`main.lua`、`README.md`、`README.zh-CN.md`。
- 不包含 Balatro 游戏文件、Lovely 文件、Steamodded 文件、生成 dump、日志、截图、存档或个人本机路径。

## 打包

- `BalatroStepBack-<version>.zip` 解压后第一层有 `BalatroStepBack/manifest.json`。
- `BalatroShopUndo-<version>.zip` 解压后第一层有 `BalatroShopUndo/manifest.json`。
- `BalatroScorePreview-<version>.zip` 解压后第一层有 `BalatroScorePreview/manifest.json`。
- `BalatroModifierWarning-<version>.zip` 解压后第一层有 `BalatroModifierWarning/manifest.json`。
- 解压后不会多出额外嵌套文件夹。

## 本地验证

- 使用 Lovely 和 Steamodded 启动 Balatro。
- 确认所有打包模组都出现在 Steamodded 模组列表中。
- 测试 Balatro Step Back / 对局回退：
  - 英文环境下确认按钮显示 `Back` 和 `History`。
  - 简体中文环境下确认按钮显示 `回退` 和 `记录`，历史列表显示类似 `回到第 1 次出牌前`。
  - 繁体中文环境下确认按钮显示 `回退` 和 `記錄`，历史列表显示类似 `回到第 1 次棄牌前`。
  - 出牌或弃牌一次。
  - 打开检查点列表，确认列表分页、记录默认折叠、“详情/收起”只展开单条记录，并且出牌/弃牌检查点显示缩小后的真实牌面预览。
  - 恢复到最近检查点。
  - 打开检查点列表并恢复到更早的检查点。
  - 回到主界面后继续同一局，确认当前盲注检查点列表仍然可用。
  - 从暂停菜单开始新的一局，进入小盲注后确认旧检查点已经清空。
- 测试 Balatro Shop Undo / 商店回退：
  - 在商店中确认重掷按钮下方出现 `回退 / 商店` 按钮。
  - 购买一张可见商店卡牌后回退，确认金钱、卡牌区域和商店内容恢复。
  - 在商店中出售小丑牌或可出售消耗牌后回退，确认卡牌和金钱恢复。
  - 兑换优惠券后回退，确认优惠券状态和金钱恢复。
  - 确认 1.0.0 不回退商店重掷和打开补充包。
- 测试 Balatro Score Preview / 分数预览：
  - 英文环境下选择手牌并确认出现 `Reference: ...`。
  - 简体中文环境下选择手牌并确认出现 `参考值：...`。
  - 繁体中文环境下选择手牌并确认出现 `參考值：...`。
  - 测试至少一种普通小丑牌计分情况。
  - 测试一种概率情况，例如 Lucky Card，并确认预览使用“不触发”的参考值。
- 测试 Balatro Modifier Warning / 覆盖提醒：
  - 选中一张增强塔罗牌，再选择一张已有不同增强牌的扑克牌，确认出现带“旧效果 → 新效果”和向右箭头的覆盖警告标签。
  - 选中一张原版蜡封幻灵牌，再选择一张已有不同蜡封的扑克牌，确认出现带“旧效果 → 新效果”和向右箭头的覆盖警告标签。
  - 如条件允许，检查窗口模式、无边框模式和至少一种高分辨率布局。
  - 选择普通牌或已有相同效果的目标牌，确认不会出现警告框。

## Nexus 页面

- 写明依赖：Lovely 和 Steamodded / SMODS。
- 写明安装路径：`%AppData%\Balatro\Mods`。
- 写明已知限制和兼容性风险。
- 附上 GitHub 仓库链接。
- 不要宣称兼容所有模组。
- 不要包含受版权保护的游戏文件或第三方资产。
