# Release Checklist

[中文版本](./RELEASE_CHECKLIST.zh-CN.md)

Use this before publishing to GitHub Releases or Nexus Mods.

## Files

- `BalatroStepBack/manifest.json` has the correct version and author.
- `BalatroShopUndo/manifest.json` has the correct version and author.
- `BalatroRunArchive/manifest.json` has the correct version and author.
- `BalatroSupernovaTracker/manifest.json` has the correct version and author.
- `BalatroScorePreview/manifest.json` has the correct version and author.
- `BalatroModifierWarning/manifest.json` has the correct version and author.
- Each mod folder contains only files needed by users: `manifest.json`, `main.lua`, `README.md`, `README.zh-CN.md`.
- No Balatro game files, Lovely files, Steamodded files, generated dumps, logs, screenshots, save files, or user paths are included.

## Packaging

- `BalatroStepBack-<version>.zip` contains `BalatroStepBack/manifest.json` at the first folder level.
- `BalatroShopUndo-<version>.zip` contains `BalatroShopUndo/manifest.json` at the first folder level.
- `BalatroRunArchive-<version>.zip` contains `BalatroRunArchive/manifest.json` at the first folder level.
- `BalatroSupernovaTracker-<version>.zip` contains `BalatroSupernovaTracker/manifest.json` at the first folder level.
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
  - Open the checkpoint list and confirm it is paginated, entries are collapsed by default, Details/Hide expands a single entry, and played/discarded checkpoints show scaled real card previews.
  - Restore the latest checkpoint.
  - Open the checkpoint list and restore an earlier checkpoint.
  - Return to the main menu, continue the same run, and confirm the current-blind checkpoint list is still available.
  - From the pause menu, start a new run, enter the Small Blind, and confirm old checkpoints are cleared.
- Test Balatro Shop Undo / 商店回退:
  - In the shop, confirm the `Undo / Shop` button appears under reroll.
  - Buy a visible shop card, then undo and confirm money, card areas, and shop contents return.
  - Sell a Joker or sellable consumable in the shop, then undo and confirm the card and money return.
  - Redeem a voucher, then undo and confirm voucher state and money return.
  - Confirm shop reroll and booster opening are not undoable.
  - Confirm opening a booster keeps safe earlier buy/sell undo points, while the opened pack and pack results are not rewound.
- Test Balatro Run History / 历史战绩:
  - Confirm the Options menu shows `Run History`, `历史战绩`, or `歷史戰績` based on the game language.
  - Start a new run, buy or redeem at least one visible card if possible, then finish or lose the run.
  - Open the archive list and confirm the run appears with deck, stake, seed, result, ante, and best-hand score.
  - Open Details and confirm Overview and Final State tabs contain reasonable data.
  - In Final State, expand Jokers, Deck cards, and Vouchers and confirm small card previews appear when data is available.
  - Confirm old runs remain available after restarting Balatro.
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
