# Balatro Score Preview

[中文说明](./README.zh-CN.md)

Author: ZhiSunian

Version: 0.3.0

Shows a sandboxed reference score before playing the selected hand.

## What It Does

- Shows `参考值：XXXXXX` when cards are selected.
- Prefers a full sandbox simulation: temporarily runs the real scoring path, then restores the run state.
- Covers normal poker hands, scoring cards, held-card effects, Jokers, enhancements, seals, deck final scoring steps, and other real scoring paths.
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

5. Start Balatro and confirm `Balatro Score Preview` appears in the Steamodded mod list.

## Compatibility Notes

The full simulation keeps the run unchanged by snapshotting and restoring state. It should match vanilla scoring and most mods written against standard SMODS scoring context, but it cannot promise compatibility with arbitrary mod code. If another mod writes files during scoring, mutates external global state, depends on real animation events, bypasses SMODS probability helpers, or bypasses SMODS scoring parameters, the preview may fall back to a basic estimate or differ from the final score.

## Publishing Notes

This archive contains only original Lua mod code and metadata. It does not include Balatro, Lovely, Steamodded, game files, images, audio, or other third-party assets.
