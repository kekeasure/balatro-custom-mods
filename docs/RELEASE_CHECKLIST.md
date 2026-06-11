# Release Checklist

[中文版本](./RELEASE_CHECKLIST.zh-CN.md)

Use this before publishing to GitHub Releases or Nexus Mods.

## Files

- `BalatroStepBack/manifest.json` has the correct version and author.
- `BalatroScorePreview/manifest.json` has the correct version and author.
- `BalatroModifierWarning/manifest.json` has the correct version and author.
- Each mod folder contains only files needed by users: `manifest.json`, `main.lua`, `README.md`, `README.zh-CN.md`.
- No Balatro game files, Lovely files, Steamodded files, generated dumps, logs, screenshots, save files, or user paths are included.

## Packaging

- `BalatroStepBack-<version>.zip` contains `BalatroStepBack/manifest.json` at the first folder level.
- `BalatroScorePreview-<version>.zip` contains `BalatroScorePreview/manifest.json` at the first folder level.
- `BalatroModifierWarning-<version>.zip` contains `BalatroModifierWarning/manifest.json` at the first folder level.
- Extracting the zip does not create an extra nested folder.

## Local Validation

- Launch Balatro with Lovely and Steamodded.
- Confirm all packaged mods appear in the Steamodded mod list.
- Test Balatro Step Back / 对局回退:
  - In English, confirm the buttons show `Back` and `History`.
  - In Simplified Chinese, confirm the buttons show `回退` and `记录`, and the history list uses labels like `回到第 1 次出牌前`.
  - In Traditional Chinese, confirm the buttons show `回退` and `記錄`, and the history list uses labels like `回到第 1 次棄牌前`.
  - Play or discard once.
  - Restore the latest checkpoint.
  - Open the checkpoint list and restore an earlier checkpoint.
- Test Balatro Score Preview / 分数预览:
  - In English, select cards and check `Reference: ...` appears.
  - In Simplified Chinese, select cards and check `参考值：...` appears.
  - In Traditional Chinese, select cards and check `參考值：...` appears.
  - Test at least one normal Joker scoring case.
  - Test one probability case, such as Lucky Card, and confirm the preview uses the non-trigger reference value.
- Test Balatro Modifier Warning / 覆盖提醒:
  - Select an enhancement Tarot, then select a playing card that already has a different enhancement and confirm the replacement badge appears with old-to-new modifier text and a right arrow.
  - Select a vanilla seal Spectral card, then select a playing card that already has a different seal and confirm the replacement badge appears with old-to-new modifier text and a right arrow.
  - Check windowed, borderless, and at least one high-resolution layout if available.
  - Select a base card or same-modifier target and confirm no replacement badge appears.

## Nexus Page

- State dependencies: Lovely and Steamodded / SMODS.
- State install path: `%AppData%\Balatro\Mods`.
- State known limits and compatibility warnings.
- Include the GitHub repository link.
- Do not claim perfect compatibility with all mods.
- Do not include copyrighted game files or third-party assets.
