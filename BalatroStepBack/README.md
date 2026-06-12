# Balatro Step Back / 对局回退

[中文说明](./README.zh-CN.md)

Author: ZhiSunian

Chinese name: 对局回退

Version: 1.2.1

## What It Does

Balatro Step Back / 对局回退 adds checkpoints inside the current blind.

- English UI: `Back` returns to the latest play/discard checkpoint, and `History` opens the checkpoint list.
- Simplified Chinese UI: `回退` returns to the latest play/discard checkpoint, and `记录` opens the checkpoint list.
- Traditional Chinese UI: `回退` returns to the latest play/discard checkpoint, and `記錄` opens the checkpoint list.
- History entries use clearer labels, such as `Go back before Play #1`, `Go back before Consumable #1`, `回到第 1 次出牌前`, and `回到第 1 次使用消耗牌前`.
- The History menu is paginated and entries stay collapsed by default; open `Details` to view the exact cards for that checkpoint.
- Played and discarded hand checkpoints show scaled real Balatro card previews in the History details panel. Played hand checkpoints also show the detected poker hand.
- History is limited to the current run and blind. Choosing an earlier checkpoint discards later checkpoint history.
- Current-blind checkpoint history is saved with the run, so returning to the main menu and continuing the same run keeps the available step-back points.
- Using a held consumable during a blind now creates a checkpoint first, so stepping back can restore Tarot, Planet, and Spectral cards to the consumable area.

## Requirements

- Balatro on PC
- Lovely
- Steamodded / SMODS

This archive does not include Balatro, Lovely, Steamodded, or any game files.

## Installation

1. Install Lovely.
2. Install Steamodded / SMODS.
3. Extract this archive.
4. Put the `BalatroStepBack` folder into:

```text
%AppData%\Balatro\Mods
```

The final layout should be:

```text
%AppData%\Balatro\Mods\BalatroStepBack\manifest.json
%AppData%\Balatro\Mods\BalatroStepBack\main.lua
%AppData%\Balatro\Mods\BalatroStepBack\README.md
```

5. Start Balatro and confirm `Balatro Step Back` or `Step Back / 对局回退` appears in the Steamodded mod list.

## Compatibility Notes

The mod wraps Balatro's existing play/discard functions and reuses Balatro's run save/load table shape. It does not edit Balatro's game files, Steamodded files, or Lovely files.

It has been tested locally with Lovely 0.9.0 and Steamodded 1.0.0 beta.

Known limits:

- History is limited to the current run and blind.
- Restoring a checkpoint briefly reloads the run state.
- Mods that store unsaved external state may not restore perfectly.
- If a crash happens, test again with only Lovely, Steamodded, and this mod enabled.

## Publishing Notes

This archive contains only original Lua mod code and metadata. It does not include Balatro, Lovely, Steamodded, game files, images, audio, or other third-party assets.

## Changelog

### 1.2.1

- Fixed mixed-language poker hand labels in the History list by resolving played-hand names from the current game language at display time.
- Added fallback English, Simplified Chinese, and Traditional Chinese poker hand names for vanilla hand types if Balatro localization lookup is unavailable.

### 1.2.0

- Replaced the text-only checkpoint record with scaled real Balatro card previews for play/discard checkpoint details.
- Changed the History menu to paginated, collapsed entries with `Details` / `Hide` controls so long checkpoint lists stay within the screen.
- Added a fallback compact card-badge renderer for unusual cards that cannot be reconstructed as a real preview card.
- Played hand checkpoints now show the detected poker hand beside the checkpoint label.
- Current-blind checkpoint history now persists when returning to the main menu and continuing the same run.

### 1.1.1

- Fixed checkpoint history carrying over after starting a new run from the pause menu.
- Added run identity to the blind checkpoint key so a new run cannot reuse checkpoints from an older run with the same blind state.

### 1.1.0

- Added checkpoints before using held consumables during a blind.
- Fixed used held consumables, such as Tarot cards, not returning to the consumable area after stepping back.
- Updated the public version to 1.1.0.

### 1.0.0

- Bumped the public version to 1.0.0.
- Added language-aware UI labels.
- English game language now shows `Back`, `History`, and English history-menu text.
- Simplified Chinese game language shows `回退`, `记录`, and Simplified Chinese history-menu text.
- Traditional Chinese game language shows `回退`, `記錄`, and Traditional Chinese history-menu text.
- History entries now use clearer "go back before..." labels.

### 0.2.0

- Changed displayed author to ZhiSunian.
- Added Chinese in-game buttons: `回退` and `记录`.
- Added a checkpoint history menu for returning to earlier play/discard checkpoints.
- Removed the extra screen-wipe restore path used in 0.1.0.

### 0.1.0

- Added latest-checkpoint Undo support.
