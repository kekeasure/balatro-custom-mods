# Balatro Step Back

[中文说明](./README.zh-CN.md)

Author: ZhiSunian

Version: 1.0.0

## What It Does

Balatro Step Back adds checkpoints inside the current blind.

- English UI: `Back` returns to the latest play/discard checkpoint, and `History` opens the checkpoint list.
- Chinese UI: `回退` returns to the latest play/discard checkpoint, and `记录` opens the checkpoint list.
- History is limited to the current blind. Choosing an earlier checkpoint discards later checkpoint history.

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

5. Start Balatro and confirm `Balatro Step Back` appears in the Steamodded mod list.

## Compatibility Notes

The mod wraps Balatro's existing play/discard functions and reuses Balatro's run save/load table shape. It does not edit Balatro's game files, Steamodded files, or Lovely files.

It has been tested locally with Lovely 0.9.0 and Steamodded 1.0.0 beta.

Known limits:

- History is limited to the current blind.
- Restoring a checkpoint briefly reloads the run state.
- Mods that store unsaved external state may not rewind perfectly.
- If a crash happens, test again with only Lovely, Steamodded, and this mod enabled.

## Publishing Notes

This archive contains only original Lua mod code and metadata. It does not include Balatro, Lovely, Steamodded, game files, images, audio, or other third-party assets.

## Changelog

### 1.0.0

- Bumped the public version to 1.0.0.
- Added language-aware UI labels.
- English game language now shows `Back`, `History`, and English history-menu text.
- Chinese game language keeps `回退`, `记录`, and Chinese history-menu text.

### 0.2.0

- Changed displayed author to ZhiSunian.
- Added Chinese in-game buttons: `回退` and `记录`.
- Added a checkpoint history menu for returning to earlier play/discard checkpoints.
- Removed the extra screen-wipe restore path used in 0.1.0.

### 0.1.0

- Added latest-checkpoint Undo support.
