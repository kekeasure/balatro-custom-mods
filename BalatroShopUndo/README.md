# Balatro Shop Undo / 商店回退

[中文说明](./README.zh-CN.md)

Author: ZhiSunian

Version: 1.0.0

## What It Does

Balatro Shop Undo adds a small undo button to the shop screen. It is meant for common shop misclicks, not for free reroll or booster previewing.

- Adds an `Undo / Shop` button under the shop reroll button.
- Creates a checkpoint before buying a shop card.
- Creates a checkpoint before using `Buy and Use`.
- Creates a checkpoint before selling a card while in the shop.
- Creates a checkpoint before redeeming a voucher.
- Pressing the button restores the latest shop checkpoint.
- English, Simplified Chinese, and Traditional Chinese UI text are included.

Intentionally not included in 1.0.0:

- Shop reroll undo, because it would let players preview rerolls for free.
- Booster pack opening undo, because it would let players preview pack contents for free.

## Requirements

- Balatro on PC
- Lovely
- Steamodded / SMODS

This archive does not include Balatro, Lovely, Steamodded, or any game files.

## Installation

1. Install Lovely.
2. Install Steamodded / SMODS.
3. Extract this archive.
4. Put the `BalatroShopUndo` folder into:

```text
%AppData%\Balatro\Mods
```

The final layout should be:

```text
%AppData%\Balatro\Mods\BalatroShopUndo\manifest.json
%AppData%\Balatro\Mods\BalatroShopUndo\main.lua
%AppData%\Balatro\Mods\BalatroShopUndo\README.md
%AppData%\Balatro\Mods\BalatroShopUndo\README.zh-CN.md
```

5. Start Balatro and confirm `Balatro Shop Undo` or `Shop Undo / 商店回退` appears in the Steamodded mod list.

## Compatibility Notes

The mod wraps Balatro's existing buy, sell, and use-card functions, and reuses Balatro's own run save/load table shape. It does not edit Balatro's game files, Steamodded files, or Lovely files.

Known limits:

- Shop undo is scoped to the current shop state.
- Restoring a checkpoint briefly reloads the run state.
- Mods that store extra state outside Balatro's normal run save may not restore perfectly.
- If a crash happens, test again with only Lovely, Steamodded, and this mod enabled.

## Publishing Notes

This archive contains only original Lua mod code and metadata. It does not include Balatro, Lovely, Steamodded, game files, images, audio, or other third-party assets.

## Changelog

### 1.0.0

- Initial release.
- Added shop checkpoints before purchases, buy-and-use actions, sales, and voucher redemptions.
- Added localized English, Simplified Chinese, and Traditional Chinese UI text.
