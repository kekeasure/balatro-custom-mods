# Balatro Score Preview

Author: ZhiSunian

Version: 0.3.0

出牌前显示一个沙盒试算的参考分数。

## 功能

- 选中手牌时显示 `参考值：XXXXXX`。
- 优先使用完整试算：临时模拟真实出牌结算链，再恢复对局状态。
- 试算覆盖常规牌型、计分牌、手牌区效果、小丑牌、增强牌、蜡封、牌背最终结算步骤等真实结算路径。
- 标准 SMODS 概率判定在预览中固定按“不触发”处理，避免提前知道 Lucky Card、Bloodstone、Space Joker 等概率效果是否触发。
- 如果完整试算被某个模组的特殊逻辑打断，会自动退回基础估算。

## 安装

1. 先安装 Lovely 和 Steamodded。
2. 解压下载的压缩包。
3. 将 `BalatroScorePreview` 文件夹放入 Balatro 的 `Mods` 文件夹。
4. 启动游戏，在 Steamodded 的模组列表中启用 `Balatro Score Preview`。

最终结构应为：

```text
%AppData%\Balatro\Mods\BalatroScorePreview\manifest.json
%AppData%\Balatro\Mods\BalatroScorePreview\main.lua
%AppData%\Balatro\Mods\BalatroScorePreview\README.md
```

## 当前限制

完整试算通过状态快照和回滚来保持对局不变。它应该能匹配原版和大多数按 SMODS 标准上下文写的模组，但不能承诺兼容所有任意模组代码：如果其他模组在计分阶段写文件、改全局外部状态、依赖真实动画事件，绕过 SMODS 的概率函数，或绕过 SMODS 的计分参数系统，预览可能退回基础估算或与最终值存在差异。

## Publishing Notes

This archive contains only original Lua mod code and metadata. It does not include Balatro, Lovely, Steamodded, game files, images, audio, or other third-party assets.
