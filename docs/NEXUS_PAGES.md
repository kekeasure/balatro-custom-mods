# Nexus Mods Page Drafts

[中文版本](./NEXUS_PAGES.zh-CN.md)

These drafts are copy-ready for Nexus Mods. Each short description and full description is bilingual, with the complete English version first and the complete Chinese version after it.

Shared links:

- Lovely: https://github.com/ethangreen-dev/lovely-injector
- Steamodded / SMODS: https://github.com/Steamodded/smods
- Steamodded install guide: https://www.nexusmods.com/balatro/articles/31
- GitHub repository: https://github.com/kekeasure/balatro-custom-mods

## Balatro Step Back / 对局回退

Suggested category: Gameplay or User Interface

Suggested tags: Quality of Life, Gameplay, User Interface

Upload file: `BalatroStepBack-1.2.1.zip`

### Short Description

```text
Balatro Step Back / 对局回退 adds localized in-blind checkpoints scoped to the current run and blind, so you can step back to the latest or an earlier play/discard checkpoint.

Balatro Step Back / 对局回退 会在当前对局和当前盲注内添加本地化检查点，可以回到最近一次或更早的出牌/弃牌前。
```

### Full Description

```text
Description

Balatro Step Back / 对局回退 adds checkpoint-based step-back support inside the current blind. It is designed for players who want to reconsider a play or discard during the same blind without restarting the whole run.

Main features

- Adds a Back button in English or a 回退 button in Chinese.
- Adds a History button in English, a 记录 button in Simplified Chinese, or a 記錄 button in Traditional Chinese.
- Creates a checkpoint before each played or discarded hand.
- Lets you return to the latest checkpoint.
- Lets you open the checkpoint list and return to an earlier checkpoint in the current blind.
- History entries use clearer labels, such as Go back before Play #1, 回到第 1 次出牌前, and 回到第 1 次棄牌前.
- The history list is paginated and collapsed by default; Details expands one entry to show the exact played/discarded cards.
- Play and discard entries show scaled real Balatro card previews in the Details panel, and play entries show the detected poker hand.
- Returning to an earlier checkpoint discards later checkpoint history.
- History is limited to the current blind.
- Current-blind checkpoint history is saved with the run, so returning to the main menu and continuing the same run keeps the available step-back points.

Installation

1. Install Lovely Injector.
2. Install Steamodded / SMODS.
3. Download BalatroStepBack-1.2.1.zip.
4. Extract the zip.
5. Move the `BalatroStepBack` folder into:

%AppData%\Balatro\Mods

Final layout:

%AppData%\Balatro\Mods\BalatroStepBack\manifest.json
%AppData%\Balatro\Mods\BalatroStepBack\main.lua

Requirements

- Balatro on PC
- Lovely Injector
- Steamodded / SMODS

Language support

- English game language: Back, History, and English history-menu text.
- Simplified Chinese game language: 回退, 记录, and Simplified Chinese history-menu text.
- Traditional Chinese game language: 回退, 記錄, and Traditional Chinese history-menu text.
- Other languages fall back to English UI text.

Compatibility and known limits

- This mod does not edit Balatro game files.
- Restoring a checkpoint briefly reloads the run state.
- The mod uses Balatro's run save/load table shape. Mods that store state outside normal save data may not restore perfectly.
- Conflicts are possible with mods that replace the same play/discard functions or the same in-run button UI.
- If you hit a crash, test again with only Lovely, Steamodded, and this mod enabled, then include your Lovely crash log when reporting.

Source

GitHub:
https://github.com/kekeasure/balatro-custom-mods

Credits

Code by ZhiSunian. No Balatro, Lovely, Steamodded, image, audio, or other third-party assets are included.

---

中文说明

Balatro Step Back / 对局回退 会在当前盲注内添加基于检查点的回退功能。它适合希望在同一盲注内反悔某次出牌或弃牌、但不想重新开始整局游戏的玩家。

主要功能

- 英文游戏语言下添加 Back 按钮；中文游戏语言下添加“回退”按钮。
- 英文游戏语言下添加 History 按钮；简体中文下添加“记录”按钮；繁体中文下添加“記錄”按钮。
- 每次出牌或弃牌前都会创建检查点。
- 可以回到最近的检查点。
- 可以打开检查点列表，回到当前盲注内更早的一步。
- 历史列表会显示为“回到第 1 次出牌前”、“回到第 1 次棄牌前”等更直观的格式。
- 历史记录列表采用分页和默认折叠；点击“详情”后展开单条记录，查看那次出牌/弃牌用了哪些牌。
- 出牌和弃牌记录会在“详情”里显示缩小后的真实 Balatro 牌面，出牌记录还会显示识别到的牌型。
- 回到更早检查点后，之后的检查点历史会被丢弃。
- 历史记录仅限当前盲注。
- 当前盲注检查点历史会随对局保存，回到主界面后继续同一局仍可回退。

安装方法

1. 安装 Lovely Injector。
2. 安装 Steamodded / SMODS。
3. 下载 BalatroStepBack-1.2.1.zip。
4. 解压压缩包。
5. 将 BalatroStepBack 文件夹放入：

%AppData%\Balatro\Mods

最终结构：

%AppData%\Balatro\Mods\BalatroStepBack\manifest.json
%AppData%\Balatro\Mods\BalatroStepBack\main.lua

依赖

- PC 版 Balatro
- Lovely Injector
- Steamodded / SMODS

语言支持

- 英文游戏语言：显示 Back、History 和英文历史菜单文本。
- 简体中文游戏语言：显示“回退”、“记录”和简体中文历史菜单文本。
- 繁体中文游戏语言：显示“回退”、“記錄”和繁体中文历史菜单文本。
- 其他语言默认使用英文 UI 文本。

兼容性与已知限制

- 本模组不会修改 Balatro 游戏文件。
- 恢复检查点时会短暂重新载入对局状态。
- 本模组使用 Balatro 的对局保存/读取数据结构。保存额外外部状态的其他模组可能无法被完全回退。
- 如果其他模组替换同一批出牌/弃牌函数或同一块对局按钮 UI，可能出现冲突。
- 如果发生崩溃，请先只启用 Lovely、Steamodded 和本模组复测，并在反馈时附上 Lovely 崩溃日志。

源码

GitHub:
https://github.com/kekeasure/balatro-custom-mods

鸣谢

代码作者：ZhiSunian。本模组不包含 Balatro、Lovely、Steamodded、图片、音频或其他第三方资产。
```

## Balatro Shop Undo / 商店回退

Suggested category: User Interface or Gameplay

Suggested tags: Quality of Life, Gameplay, User Interface

Upload file: `BalatroShopUndo-1.0.0.zip`

### Short Description

```text
Balatro Shop Undo / 商店回退 adds a small localized shop undo button for accidental purchases, buy-and-use actions, sales, and voucher redemptions. Rerolls and booster openings are excluded to avoid free previews.

Balatro Shop Undo / 商店回退 会在商店界面添加一个本地化回退按钮，用于撤回误购买、购买并使用、出售和兑换优惠券；暂不回退重掷商店和打开补充包，避免免费预览。
```

### Full Description

```text
Description

Balatro Shop Undo / 商店回退 adds a small checkpoint-based undo button to the shop screen. It is designed for common shop misclicks, such as buying the wrong card or accidentally selling something, without turning shop rerolls or booster packs into free previews.

Main features

- Adds an Undo / Shop button under the shop reroll button.
- Creates a checkpoint before buying a shop card.
- Creates a checkpoint before Buy and Use actions.
- Creates a checkpoint before selling a card while in the shop.
- Creates a checkpoint before redeeming a voucher.
- Supports English, Simplified Chinese, and Traditional Chinese UI text.

Not included in 1.0.0

- Shop reroll undo, because it would let players preview rerolls for free.
- Booster pack opening undo, because it would let players preview pack contents for free.

Installation

1. Install Lovely Injector.
2. Install Steamodded / SMODS.
3. Download BalatroShopUndo-1.0.0.zip.
4. Extract the zip.
5. Move the `BalatroShopUndo` folder into:

%AppData%\Balatro\Mods

Final layout:

%AppData%\Balatro\Mods\BalatroShopUndo\manifest.json
%AppData%\Balatro\Mods\BalatroShopUndo\main.lua

Requirements

- Balatro on PC
- Lovely Injector
- Steamodded / SMODS

Compatibility and known limits

- This mod does not edit Balatro game files.
- Restoring a checkpoint briefly reloads the run state.
- The mod uses Balatro's run save/load table shape. Mods that store state outside normal save data may not restore perfectly.
- Conflicts are possible with mods that replace the same buy, sell, use-card, or shop UI functions.
- If you hit a crash, test again with only Lovely, Steamodded, and this mod enabled, then include your Lovely crash log when reporting.

Source

GitHub:
https://github.com/kekeasure/balatro-custom-mods

Credits

Code by ZhiSunian. No Balatro, Lovely, Steamodded, image, audio, or other third-party assets are included.

---

中文说明

Balatro Shop Undo / 商店回退 会在商店界面添加一个基于检查点的小型回退按钮。它主要用于处理常见商店误操作，例如买错卡牌或误卖卡牌，而不是把商店重掷或补充包变成免费预览。

主要功能

- 在商店重掷按钮下方添加 Undo / Shop 或 回退 / 商店 按钮。
- 购买商店卡牌前创建检查点。
- 点击购买并使用前创建检查点。
- 在商店里出售卡牌前创建检查点。
- 兑换优惠券前创建检查点。
- 支持英文、简体中文、繁体中文 UI 文本。

1.0.0 暂不包含

- 重掷商店回退，因为这会让玩家免费预览重掷结果。
- 打开补充包回退，因为这会让玩家免费预览补充包内容。

安装方法

1. 安装 Lovely Injector。
2. 安装 Steamodded / SMODS。
3. 下载 BalatroShopUndo-1.0.0.zip。
4. 解压压缩包。
5. 将 BalatroShopUndo 文件夹放入：

%AppData%\Balatro\Mods

最终结构：

%AppData%\Balatro\Mods\BalatroShopUndo\manifest.json
%AppData%\Balatro\Mods\BalatroShopUndo\main.lua

依赖

- PC 版 Balatro
- Lovely Injector
- Steamodded / SMODS

兼容性与已知限制

- 本模组不会修改 Balatro 游戏文件。
- 恢复检查点时会短暂重新载入对局状态。
- 本模组使用 Balatro 的对局保存/读取数据结构。保存额外外部状态的其他模组可能无法被完全回退。
- 如果其他模组替换同一批购买、出售、用牌或商店 UI 函数，可能出现冲突。
- 如果发生崩溃，请先只启用 Lovely、Steamodded 和本模组复测，并在反馈时附上 Lovely 崩溃日志。

源码

GitHub:
https://github.com/kekeasure/balatro-custom-mods

鸣谢

代码作者：ZhiSunian。本模组不包含 Balatro、Lovely、Steamodded、图片、音频或其他第三方资产。
```

## Balatro Score Preview / 分数预览

Suggested category: User Interface or Gameplay

Suggested tags: Quality of Life, Gameplay, User Interface

Upload file: `BalatroScorePreview-1.2.2.zip`

### Short Description

```text
Balatro Score Preview / 分数预览 shows a localized pre-play reference score for the selected hand. Selected face-down or flipping cards show an unknown value. Probability effects are treated as not triggering, and disruptive vanilla Boss Blind pre-play effects are isolated from the live hand. Supports English, Simplified Chinese, and Traditional Chinese UI.

Balatro Score Preview / 分数预览 会在出牌前显示本地化的所选手牌参考分数，选中背面牌或正在翻面的牌时显示未知值，概率效果在预览中按“不触发”处理，原版 Boss Blind 的随机弃牌/翻面等出牌前副作用不会真实作用到手牌，并支持英文、简体中文和繁体中文 UI。
```

### Full Description

```text
Description

Balatro Score Preview / 分数预览 shows a pre-play reference score for the selected hand. It is intended to show a deterministic reference value before the real scoring animation runs.

Main features

- Shows Reference: XXXXX in English, 参考值：XXXXX in Simplified Chinese, or 參考值：XXXXX in Traditional Chinese.
- Shows Reference: ???, 参考值：？？？, or 參考值：？？？ when any selected card is face-down or currently flipping.
- Updates when cards are selected.
- Uses a sandboxed scoring simulation, then restores the run state.
- Covers normal hands, scoring cards, held-card effects, Jokers, enhancements, seals, and deck final scoring steps.
- Handles vanilla Boss Blind scoring conditions in the sandbox. Random or disruptive pre-play effects such as The Hook are not executed on the live hand; deterministic effects such as The Tooth are simulated and then restored.
- Standard SMODS probability checks are treated as not triggering during preview.
- Real play still uses normal random probability.

Important note

The preview intentionally does not predict whether probability effects will trigger. Examples include Lucky Card, Bloodstone, Space Joker, and similar SMODS probability-based effects. This keeps the preview useful without revealing random outcomes before the hand is played.

When the selected cards include a face-down or flipping card, the preview intentionally shows an unknown value instead of calculating with hidden information. Face-down cards that are still in hand but not selected do not block the preview.

Installation

1. Install Lovely Injector.
2. Install Steamodded / SMODS.
3. Download BalatroScorePreview-1.2.2.zip.
4. Extract the zip.
5. Move the `BalatroScorePreview` folder into:

%AppData%\Balatro\Mods

Final layout:

%AppData%\Balatro\Mods\BalatroScorePreview\manifest.json
%AppData%\Balatro\Mods\BalatroScorePreview\main.lua

Requirements

- Balatro on PC
- Lovely Injector
- Steamodded / SMODS

Language support

- English game language: Reference: XXXXX.
- Simplified Chinese game language: 参考值：XXXXX.
- Traditional Chinese game language: 參考值：XXXXX.
- Other languages fall back to English UI text.

Compatibility and known limits

- This mod does not edit Balatro game files.
- The preview is a sandboxed simulation, not a replacement for the real scoring animation.
- It should match vanilla and most SMODS-style deterministic scoring.
- For safety, arbitrary custom Boss Blind pre-play events are not executed during preview.
- Mods that write files, change external global state, bypass SMODS probability helpers, bypass SMODS scoring parameters, or depend on custom Boss Blind pre-play events may show a different final score.
- If the full simulation is interrupted by unusual mod logic, the preview may fall back to a basic estimate.
- If you hit a crash, test again with only Lovely, Steamodded, and this mod enabled, then include your Lovely crash log when reporting.

Source

GitHub:
https://github.com/kekeasure/balatro-custom-mods

Credits

Code by ZhiSunian. No Balatro, Lovely, Steamodded, image, audio, or other third-party assets are included.

This mod is still being tested, so bugs may occur. If you encounter any bug during play, please report it to me immediately. Thank you very much.

---

中文说明

Balatro Score Preview / 分数预览 会在出牌前显示所选手牌的参考分数。它的目标是在真实结算动画开始前，给出一个确定性参考值。

主要功能

- 英文游戏语言下显示 Reference: XXXXX；简体中文下显示“参考值：XXXXX”；繁体中文下显示“參考值：XXXXX”。
- 选中的牌存在背面牌或正在翻面时，显示 Reference: ???、“参考值：？？？”或“參考值：？？？”。
- 选中手牌时自动更新。
- 使用沙盒计分试算，然后恢复对局状态。
- 覆盖常规牌型、计分牌、手牌区效果、小丑牌、增强牌、蜡封、牌背最终结算步骤等路径。
- 在沙盒中处理原版 Boss Blind 的计分条件。像钩子这种随机弃牌/翻面的出牌前效果不会真实作用到当前手牌；像牙齿这种确定性扣钱效果会在沙盒里临时模拟，并在结束后恢复。
- 标准 SMODS 概率判定在预览中按“不触发”处理。
- 真实出牌时仍使用正常随机概率。

重要说明

本模组故意不会预测概率效果是否触发。例如 Lucky Card、Bloodstone、Space Joker，以及类似的 SMODS 概率效果。这样可以让预览值保持有用，同时不会在出牌前泄露随机结果。

当选中的牌包含背面牌或正在翻面的牌时，预览会故意显示未知值，而不是用隐藏牌信息计算真实分数。仍在手牌区但没有被选中的背面牌不会阻止预览。

安装方法

1. 安装 Lovely Injector。
2. 安装 Steamodded / SMODS。
3. 下载 BalatroScorePreview-1.2.2.zip。
4. 解压压缩包。
5. 将 BalatroScorePreview 文件夹放入：

%AppData%\Balatro\Mods

最终结构：

%AppData%\Balatro\Mods\BalatroScorePreview\manifest.json
%AppData%\Balatro\Mods\BalatroScorePreview\main.lua

依赖

- PC 版 Balatro
- Lovely Injector
- Steamodded / SMODS

语言支持

- 英文游戏语言：显示 Reference: XXXXX。
- 简体中文游戏语言：显示“参考值：XXXXX”。
- 繁体中文游戏语言：显示“參考值：XXXXX”。
- 其他语言默认使用英文 UI 文本。

兼容性与已知限制

- 本模组不会修改 Balatro 游戏文件。
- 预览是沙盒试算，不会替代真实结算动画。
- 它应能匹配原版和大多数 SMODS 风格的确定性计分。
- 为避免副作用，预览不会执行任意自定义 Boss Blind 的出牌前事件。
- 如果其他模组会写文件、改变外部全局状态、绕过 SMODS 概率函数、绕过 SMODS 计分参数，或依赖自定义 Boss Blind 出牌前事件，预览值可能与最终分数不同。
- 如果完整试算被某些特殊模组逻辑打断，预览可能退回基础估算。
- 如果发生崩溃，请先只启用 Lovely、Steamodded 和本模组复测，并在反馈时附上 Lovely 崩溃日志。

源码

GitHub:
https://github.com/kekeasure/balatro-custom-mods

鸣谢

代码作者：ZhiSunian。本模组不包含 Balatro、Lovely、Steamodded、图片、音频或其他第三方资产。

本模组仍在测试中，因此可能会出现 bug。如果你在游玩过程中遇到任何 bug，请立即反馈给我，非常感谢。
```

## Balatro Modifier Warning / 覆盖提醒

Suggested category: User Interface or Gameplay

Suggested tags: Quality of Life, User Interface, Gameplay

Upload file: `BalatroModifierWarning-1.1.2.zip`

### Short Description

```text
Balatro Modifier Warning / 覆盖提醒 adds a clear, language-aware replacement warning badge when a selected consumable would overwrite an existing playing-card enhancement or seal.

Balatro Modifier Warning / 覆盖提醒 会在当前选中的消耗牌将要替换目标扑克牌已有增强牌或蜡封时，在目标牌附近显示醒目的覆盖警告标签。
```

### Full Description

```text
Description

Balatro Modifier Warning / 覆盖提醒 is a lightweight visual warning mod for modifier replacement. When you select a consumable and then select a playing card that already has a modifier in the same slot, the target card gets a compact dark replacement badge with a warning accent. The badge explicitly shows the old-to-new relationship, such as Gold → Glass or Red → Gold.

Main features

- Warns when a selected enhancement Tarot would replace an existing enhancement, such as Gold, Steel, Lucky, Glass, Wild, Bonus, Mult, or Stone Card.
- Warns when Talisman, Deja Vu, Trance, or Medium would replace an existing different seal.
- Shows REPLACE plus old-to-new modifier text near the target card instead of drawing a card outline.
- Uses game-coordinate positioning so the badge stays comfortable in windowed, borderless, and common high-resolution layouts.
- Uses separate text sizing for Simplified Chinese, Traditional Chinese, and English.
- Does not block the action and does not change game rules.
- Does not warn on face-down or hidden cards, so it does not reveal hidden information.
- Modded consumables using the standard `mod_conv` enhancement field are covered automatically.

Installation

1. Install Lovely Injector.
2. Install Steamodded / SMODS.
3. Download BalatroModifierWarning-1.1.2.zip.
4. Extract the zip.
5. Move the `BalatroModifierWarning` folder into:

%AppData%\Balatro\Mods

Final layout:

%AppData%\Balatro\Mods\BalatroModifierWarning\manifest.json
%AppData%\Balatro\Mods\BalatroModifierWarning\main.lua

Compatibility and known limits

- This mod does not edit Balatro game files.
- The mod only reads card state and adds a Steamodded draw step.
- It does not cover suit conversion, rank conversion, card copying, card destruction, Joker edition effects, or fully custom scripted consumable effects.
- If you hit a crash, test again with only Lovely, Steamodded, and this mod enabled, then include your Lovely crash log when reporting.

Source

GitHub:
https://github.com/kekeasure/balatro-custom-mods

Credits

Code by ZhiSunian. No Balatro, Lovely, Steamodded, image, audio, or other third-party assets are included.

---

中文说明

Balatro Modifier Warning / 覆盖提醒 是一个轻量视觉提示模组，用来提醒同槽位效果会被替换。当你选中一张消耗牌，并选择一张已经有同槽位效果的扑克牌时，目标牌附近会出现一个带警示条的深色覆盖警告标签。标签会明确显示覆盖关系，例如“黄金牌 → 玻璃牌”或“红蜡封 → 金蜡封”。

主要功能

- 当增强塔罗牌会替换已有增强牌时提示，例如黄金牌、钢铁牌、幸运牌、玻璃牌、万能牌、奖励牌、倍率牌或石头牌。
- 当 Talisman、Deja Vu、Trance、Medium 会替换已有不同蜡封时提示。
- 在目标牌附近显示“覆盖提醒”以及“旧效果 → 新效果”，不再绘制整张牌外框。
- 使用游戏坐标定位，窗口模式、无边框模式和常见高分辨率布局下显示更稳定。
- 为简体中文、繁体中文和英文分别设置文本尺寸。
- 不会阻止操作，也不会修改游戏规则。
- 背面牌或隐藏牌不会提示，避免泄露隐藏信息。
- 使用标准 `mod_conv` 字段转换增强牌的自定义消耗牌会自动被识别。

安装方法

1. 安装 Lovely Injector。
2. 安装 Steamodded / SMODS。
3. 下载 BalatroModifierWarning-1.1.2.zip。
4. 解压压缩包。
5. 将 BalatroModifierWarning 文件夹放入：

%AppData%\Balatro\Mods

最终结构：

%AppData%\Balatro\Mods\BalatroModifierWarning\manifest.json
%AppData%\Balatro\Mods\BalatroModifierWarning\main.lua

兼容性与已知限制

- 本模组不会修改 Balatro 游戏文件。
- 本模组只读取牌状态，并添加一个 Steamodded 绘制步骤。
- 不覆盖改花色、改点数、复制牌、摧毁牌、小丑牌版本效果或完全自定义脚本消耗牌效果。
- 如果发生崩溃，请先只启用 Lovely、Steamodded 和本模组复测，并在反馈时附上 Lovely 崩溃日志。

源码

GitHub:
https://github.com/kekeasure/balatro-custom-mods

鸣谢

代码作者：ZhiSunian。本模组不包含 Balatro、Lovely、Steamodded、图片、音频或其他第三方资产。
```
