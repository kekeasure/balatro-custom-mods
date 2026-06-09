# Balatro Rewind / 对局回退

[English README](./README.md)

作者：ZhiSunian

中文名：对局回退

版本：1.0.0

## 功能

Balatro Rewind / 对局回退 会在当前盲注内添加出牌/弃牌检查点。

- 英文 UI：`Back` 回到最近一次出牌或弃牌前，`History` 打开检查点列表。
- 中文 UI：`回退` 回到最近一次出牌或弃牌前，`记录` 打开检查点列表。
- 历史记录仅限当前盲注。选择更早的检查点后，之后的检查点历史会被丢弃。

## 依赖

- PC 版 Balatro
- Lovely
- Steamodded / SMODS

本压缩包不包含 Balatro、Lovely、Steamodded 或任何游戏文件。

## 安装

1. 安装 Lovely。
2. 安装 Steamodded / SMODS。
3. 解压本压缩包。
4. 将 `BalatroRewind` 文件夹放入：

```text
%AppData%\Balatro\Mods
```

最终结构应为：

```text
%AppData%\Balatro\Mods\BalatroRewind\manifest.json
%AppData%\Balatro\Mods\BalatroRewind\main.lua
%AppData%\Balatro\Mods\BalatroRewind\README.md
%AppData%\Balatro\Mods\BalatroRewind\README.zh-CN.md
```

5. 启动 Balatro，并确认 Steamodded 模组列表中出现 `Balatro Rewind` 或 `Rewind / 对局回退`。

## 兼容性说明

本模组包装 Balatro 原有的出牌/弃牌函数，并复用 Balatro 的对局保存/读取数据结构。它不会修改 Balatro、Steamodded 或 Lovely 的安装文件。

本地测试环境包括 Lovely 0.9.0 和 Steamodded 1.0.0 beta。

已知限制：

- 历史记录仅限当前盲注。
- 恢复检查点时会短暂重新载入对局状态。
- 保存额外外部状态的其他模组可能无法被完全回退。
- 如果发生崩溃，请先只启用 Lovely、Steamodded 和本模组复测。

## 发布说明

本压缩包只包含原创 Lua 模组代码和元数据，不包含 Balatro、Lovely、Steamodded、游戏文件、图片、音频或其他第三方资产。

## 更新日志

### 1.0.0

- 公开版本提升到 1.0.0。
- 添加按游戏语言切换的 UI 文本。
- 英文游戏语言下显示 `Back`、`History` 和英文历史菜单文本。
- 中文游戏语言下保持 `回退`、`记录` 和中文历史菜单文本。

### 0.2.0

- 作者显示改为 ZhiSunian。
- 添加中文游戏内按钮：`回退` 和 `记录`。
- 添加检查点历史菜单，可以回到更早的出牌/弃牌前。
- 移除 0.1.0 中额外的屏幕擦除恢复路径。

### 0.1.0

- 添加回到最近检查点的 Undo 功能。
