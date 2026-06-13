# Balatro Score Preview / 分数预览

[中文说明](./README.zh-CN.md)

Author: ZhiSunian

Chinese name: 分数预览

Version: 1.3.0

Shows a sandboxed reference score before playing the selected hand.

## What It Does

- Shows `Reference: XXXXX` in English, `参考值：XXXXX` in Simplified Chinese, and `參考值：XXXXX` in Traditional Chinese when cards are selected.
- If the current round score plus the previewed score reaches the blind requirement, the reference row turns green and adds `Enough`, `达标`, or `達標`.
- Shows `Reference: ???`, `参考值：？？？`, or `參考值：？？？` when any selected card is logically face-down, so selected hidden card information is not revealed.
- Prefers a full sandbox simulation: temporarily runs the real scoring path, then restores the run state.
- Covers normal poker hands, scoring cards, held-card effects, Jokers, enhancements, seals, deck final scoring steps, and other real scoring paths.
- Handles vanilla Boss Blind scoring conditions in the sandbox. Random or disruptive pre-play effects such as The Hook are not executed on the live hand; deterministic effects such as The Tooth are simulated and then restored.
- Standard SMODS probability checks are forced to "not triggered" during preview, so it does not reveal whether effects such as Lucky Card, Bloodstone, or Space Joker will trigger.
- If another mod interrupts the full simulation with unusual logic, the preview falls back to a basic estimate.

## Requirements

- Balatro on PC
- Lovely
- Steamodded / SMODS

This archive does not include Balatro, Lovely, Steamodded, or any game files.

## Installation

1. Install Lovely.
2. Install Steamodded / SMODS.
3. Extract this archive.
4. Put the `BalatroScorePreview` folder into:

```text
%AppData%\Balatro\Mods
```

The final layout should be:

```text
%AppData%\Balatro\Mods\BalatroScorePreview\manifest.json
%AppData%\Balatro\Mods\BalatroScorePreview\main.lua
%AppData%\Balatro\Mods\BalatroScorePreview\README.md
%AppData%\Balatro\Mods\BalatroScorePreview\README.zh-CN.md
```

5. Start Balatro and confirm `Balatro Score Preview` or `Score Preview / 分数预览` appears in the Steamodded mod list.

## Compatibility Notes

The full simulation keeps the run unchanged by snapshotting and restoring state. It should match vanilla scoring and most mods written against standard SMODS scoring context, but it cannot promise compatibility with arbitrary mod code. For safety, arbitrary custom Boss Blind `press_play` events are not executed during preview. If another mod writes files during scoring, mutates external global state, depends on real animation events, bypasses SMODS probability helpers, or bypasses SMODS scoring parameters, the preview may fall back to a basic estimate or differ from the final score.

## Publishing Notes

This archive contains only original Lua mod code and metadata. It does not include Balatro, Lovely, Steamodded, game files, images, audio, or other third-party assets.

## Changelog

### 1.3.0

- Added a target-reached highlight: when current round score plus the previewed score is enough to clear the blind, the preview row turns green and shows `Enough`, `达标`, or `達標`.
- Updated the public version to 1.3.0.

### 1.2.2

- Fixed sandbox restoration for card centers after previewed scoring effects such as Vampire remove an enhancement.
- Prevented preview calculations from leaving enhanced playing cards with a base-card center, which could make the card tooltip show `ERROR`.
- Added a narrow repair pass for saves already affected by this issue, restoring vanilla enhancement centers such as Gold or Lucky Card when their ability data is intact.
- Updated the public version to 1.2.2.

### 1.2.1

- Fixed a false unknown preview caused by treating internal render/animation fields as hidden-card state.
- Tightened hidden-card detection to logical face-down state only.
- Updated the public version to 1.2.1.

### 1.2.0

- Changed hidden-card handling: only selected face-down or flipping cards show an unknown preview value.
- Updated the public version to 1.2.0.

### 1.1.0

- Fixed The Hook Boss Blind preview side effect: selecting cards no longer flips or affects real hand cards.
- Fixed final-hand effects such as Acrobat and Dusk by simulating the real pre-scoring hand spend during preview.
- Selected hidden hand cards now show an unknown preview value instead of revealing the real score.
- Improved Boss Blind sandboxing and state restoration for hand/play areas, card facing, money, and blind state.
- Improved restoration for the playing-card list and card-area limits after sandboxed effects such as DNA.
- Prevented preview calculations from writing hand usage statistics or saving settings.

### 1.0.0

- Bumped the public version to 1.0.0.
- Added language-aware UI text.
- English game language now shows `Reference: XXXXX`.
- Simplified Chinese game language shows `参考值：XXXXX`.
- Traditional Chinese game language shows `參考值：XXXXX`.
- Improved Boss Blind sandboxing so The Hook no longer flips or discards real hand cards during preview.
