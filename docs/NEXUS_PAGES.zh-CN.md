# Nexus Mods 页面草稿

[English version](./NEXUS_PAGES.md)

这些草稿可以复制到 Nexus Mods 页面中。正式发布前请确认版本号、下载文件名和实际功能描述保持一致。

## 通用依赖

- 需要 PC 版 Balatro。
- 需要 Lovely Injector。
- 需要 Steamodded / SMODS。
- 上传文件不包含 Balatro、Lovely、Steamodded、游戏文件、游戏美术素材或其他受版权保护的第三方资产。

常用链接：

- Lovely: https://github.com/ethangreen-dev/lovely-injector
- Steamodded / SMODS: https://github.com/Steamodded/smods
- Steamodded 安装指南: https://www.nexusmods.com/balatro/articles/31
- GitHub 仓库: https://github.com/kekeasure/balatro-custom-mods

## Balatro Step Back

### 简短描述

在当前盲注内添加检查点，可以回到最近一次或更早的出牌/弃牌前。

### 模组介绍

Balatro Step Back 会在对局界面添加两个按钮：

- `回退`：恢复到最近的检查点。
- `记录`：打开当前盲注内可用的出牌/弃牌检查点列表。

模组会在每次出牌或弃牌前创建检查点。你可以回到最近的检查点，也可以从当前盲注内选择更早的检查点。回到更早检查点后，之后的检查点历史会被丢弃。

### 安装

1. 安装 Lovely。
2. 安装 Steamodded / SMODS。
3. 下载 `BalatroStepBack-0.2.0.zip`。
4. 解压压缩包。
5. 将 `BalatroStepBack` 文件夹移动到：

```text
%AppData%\Balatro\Mods
```

最终结构：

```text
%AppData%\Balatro\Mods\BalatroStepBack\manifest.json
%AppData%\Balatro\Mods\BalatroStepBack\main.lua
```

启动 Balatro，并在 Steamodded 模组列表中确认/启用 `Balatro Step Back`。

### 兼容性与已知限制

- 本模组不会修改游戏文件。
- 历史记录仅限当前盲注。
- 恢复检查点时会短暂重新载入对局状态。
- 本模组使用 Balatro 的对局保存/读取数据结构。保存额外外部状态的模组可能无法被完全回退。
- 如果发生崩溃，请先只启用 Lovely、Steamodded 和本模组复测，并在反馈时附上 Lovely 崩溃日志。

### 权限与鸣谢

代码作者：ZhiSunian。本模组不包含 Balatro、Lovely、Steamodded、图片、音频或其他第三方资产。

## Balatro Score Preview

### 简短描述

在出牌前显示所选手牌的参考分数；标准概率效果在预览中按“不触发”处理。

### 模组介绍

Balatro Score Preview 会添加一行紧凑的界面提示：

```text
参考值：XXXXXX
```

选中手牌时，模组会进行一次沙盒计分试算，并在试算后恢复对局状态。这个数值是确定性计分的参考值。为了避免提前泄露概率结果、影响游戏平衡，标准 SMODS 概率判定会在预览中固定为“不触发”。真实出牌时仍使用正常随机概率。

在预览中按“不触发”处理的概率效果包括 Lucky Card、Bloodstone、Space Joker，以及类似的 SMODS 概率效果。

### 安装

1. 安装 Lovely。
2. 安装 Steamodded / SMODS。
3. 下载 `BalatroScorePreview-0.3.0.zip`。
4. 解压压缩包。
5. 将 `BalatroScorePreview` 文件夹移动到：

```text
%AppData%\Balatro\Mods
```

最终结构：

```text
%AppData%\Balatro\Mods\BalatroScorePreview\manifest.json
%AppData%\Balatro\Mods\BalatroScorePreview\main.lua
```

启动 Balatro，并在 Steamodded 模组列表中确认/启用 `Balatro Score Preview`。

### 兼容性与已知限制

- 本模组不会修改游戏文件。
- 预览是沙盒试算，不会替代真实结算动画。
- 它应能匹配原版和大多数 SMODS 风格的确定性计分。
- 它故意不会预测概率效果是否触发。
- 如果其他模组会写文件、改变外部全局状态、绕过 SMODS 概率函数，或在计分阶段绕过 SMODS 计分参数，预览值可能与最终分数不同。
- 如果发生崩溃，请先只启用 Lovely、Steamodded 和本模组复测，并在反馈时附上 Lovely 崩溃日志。

### 权限与鸣谢

代码作者：ZhiSunian。本模组不包含 Balatro、Lovely、Steamodded、图片、音频或其他第三方资产。
