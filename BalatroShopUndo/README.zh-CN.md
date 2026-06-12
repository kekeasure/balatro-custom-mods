# Balatro Shop Undo / 商店回退

[English README](./README.md)

作者：ZhiSunian

版本：1.0.0

## 功能

Balatro Shop Undo / 商店回退会在商店界面添加一个小型回退按钮。它主要用于处理常见商店误操作，而不是用来免费预览重掷或补充包。

- 在商店重掷按钮下方添加 `回退 / 商店` 按钮。
- 购买商店卡牌前创建检查点。
- 点击 `购买并使用` 前创建检查点。
- 在商店里出售卡牌前创建检查点。
- 兑换优惠券前创建检查点。
- 点击按钮会恢复最近一次商店检查点。
- 已包含英文、简体中文、繁体中文 UI 文本。

1.0.0 暂不包含：

- 重掷商店回退，因为这会让玩家免费预览重掷结果。
- 打开补充包回退，因为这会让玩家免费预览补充包内容。

## 依赖

- PC 版 Balatro
- Lovely
- Steamodded / SMODS

本压缩包不包含 Balatro、Lovely、Steamodded 或任何游戏文件。

## 安装

1. 安装 Lovely。
2. 安装 Steamodded / SMODS。
3. 解压本压缩包。
4. 将 `BalatroShopUndo` 文件夹放入：

```text
%AppData%\Balatro\Mods
```

最终结构应为：

```text
%AppData%\Balatro\Mods\BalatroShopUndo\manifest.json
%AppData%\Balatro\Mods\BalatroShopUndo\main.lua
%AppData%\Balatro\Mods\BalatroShopUndo\README.md
%AppData%\Balatro\Mods\BalatroShopUndo\README.zh-CN.md
```

5. 启动 Balatro，并确认 Steamodded 模组列表中出现 `Balatro Shop Undo` 或 `Shop Undo / 商店回退`。

## 兼容性说明

本模组包装 Balatro 原有的购买、出售和用牌函数，并复用 Balatro 自身的对局保存/读取数据结构。它不会修改 Balatro、Steamodded 或 Lovely 的安装文件。

已知限制：

- 商店回退仅限当前商店状态。
- 恢复检查点时会短暂重新载入对局状态。
- 如果其他模组把额外状态保存在 Balatro 常规对局存档之外，这些外部状态可能无法被完整回退。
- 如果发生崩溃，请先只启用 Lovely、Steamodded 和本模组复测。

## 发布说明

本压缩包只包含原创 Lua 模组代码和元数据，不包含 Balatro、Lovely、Steamodded、游戏文件、图片、音频或其他第三方资产。

## 更新日志

### 1.0.0

- 初始发布。
- 新增购买、购买并使用、出售、兑换优惠券前的商店检查点。
- 添加英文、简体中文、繁体中文 UI 文本。
