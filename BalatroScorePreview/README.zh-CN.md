# Balatro Score Preview / 分数预览

[English README](./README.md)

作者：ZhiSunian

中文名：分数预览

版本：1.1.0

出牌前显示一个沙盒试算的参考分数。

## 功能

- 英文游戏语言下，选中手牌时显示 `Reference: XXXXX`。
- 简体中文游戏语言下，选中手牌时显示 `参考值：XXXXX`。
- 繁体中文游戏语言下，选中手牌时显示 `參考值：XXXXX`。
- 优先使用完整试算：临时模拟真实出牌结算链，再恢复对局状态。
- 试算覆盖常规牌型、计分牌、手牌区效果、小丑牌、增强牌、蜡封、牌背最终结算步骤等真实结算路径。
- 在沙盒中处理原版 Boss Blind 的计分条件。像钩子这种随机弃牌/翻面的出牌前效果不会真实作用到当前手牌；像牙齿这种确定性扣钱效果会在沙盒里临时模拟，并在结束后恢复。
- 标准 SMODS 概率判定在预览中固定按“不触发”处理，避免提前知道 Lucky Card、Bloodstone、Space Joker 等概率效果是否触发。
- 如果完整试算被某个模组的特殊逻辑打断，会自动退回基础估算。

## 依赖

- PC 版 Balatro
- Lovely
- Steamodded / SMODS

本压缩包不包含 Balatro、Lovely、Steamodded 或任何游戏文件。

## 安装

1. 先安装 Lovely 和 Steamodded / SMODS。
2. 解压下载的压缩包。
3. 将 `BalatroScorePreview` 文件夹放入：

```text
%AppData%\Balatro\Mods
```

最终结构应为：

```text
%AppData%\Balatro\Mods\BalatroScorePreview\manifest.json
%AppData%\Balatro\Mods\BalatroScorePreview\main.lua
%AppData%\Balatro\Mods\BalatroScorePreview\README.md
%AppData%\Balatro\Mods\BalatroScorePreview\README.zh-CN.md
```

4. 启动游戏，在 Steamodded 的模组列表中启用 `Balatro Score Preview` 或 `Score Preview / 分数预览`。

## 当前限制

完整试算通过状态快照和回滚来保持对局不变。它应该能匹配原版和大多数按 SMODS 标准上下文写的模组，但不能承诺兼容所有任意模组代码。为了避免副作用，预览不会执行任意自定义 Boss Blind 的 `press_play` 事件。如果其他模组在计分阶段写文件、改全局外部状态、依赖真实动画事件、绕过 SMODS 的概率函数，或绕过 SMODS 的计分参数系统，预览可能退回基础估算或与最终值存在差异。

## 发布说明

本压缩包只包含原创 Lua 模组代码和元数据，不包含 Balatro、Lovely、Steamodded、游戏文件、图片、音频或其他第三方资产。

## 更新日志

### 1.1.0

- 修复 Boss Blind“钩子”下的预览副作用：选择手牌时不再翻面或影响真实手牌。
- 修复 Acrobat、Dusk 等“最后一次出牌”效果：预览会临时模拟真实计分前消耗一次出牌次数。
- 改进 Boss Blind 沙盒隔离，以及手牌区、出牌区、翻面状态、金钱状态和盲注状态的恢复。
- 改进沙盒效果后的牌组列表和牌区上限恢复，例如 DNA 这类可能临时新增卡牌的效果。
- 防止预览计算写入手牌使用统计或保存设置。

### 1.0.0

- 公开版本提升到 1.0.0。
- 添加按游戏语言切换的 UI 文本。
- 英文游戏语言下显示 `Reference: XXXXX`。
- 简体中文游戏语言下显示 `参考值：XXXXX`。
- 繁体中文游戏语言下显示 `參考值：XXXXX`。
- 改进 Boss Blind 沙盒隔离，钩子不再在预览时翻面或弃掉真实手牌。
