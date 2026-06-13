# Balatro Custom Mods

[中文说明](./README.zh-CN.md)

Author: ZhiSunian

This repository contains small Balatro mods built for the Lovely + Steamodded/SMODS mod stack.

No Balatro, Lovely, Steamodded, game files, game art, audio, save files, or other third-party assets are included.

## Mods

| Mod | Version | Purpose |
| --- | --- | --- |
| [Balatro Step Back / 对局回退](./BalatroStepBack) | 1.2.1 | Adds localized in-blind checkpoints and lets you step back to the latest or an earlier play/discard/held-consumable checkpoint. The history menu is paginated with expandable details and scaled real card previews for play/discard checkpoints. |
| [Balatro Shop Undo / 商店回退](./BalatroShopUndo) | 1.0.1 | Adds a localized shop undo button for accidental purchases, buy-and-use actions, sales, and voucher redemptions. Rerolls and booster openings are not rewound; after opening a booster, safe earlier buy/sell checkpoints can still be undone while pack results stay unchanged. |
| [Balatro Run History / 历史战绩](./BalatroRunArchive) | 0.1.2 | Adds an Options-menu run history that records deck, stake, seed, result, final state, and expandable card previews for final Jokers, deck, and vouchers. |
| [Balatro Supernova Tracker / 超新星追踪](./BalatroSupernovaTracker) | 1.0.2 | Adds a compact localized tracker to Supernova's Joker tooltip so you can see how much Mult each poker hand currently gives, including hidden hands. |
| [Balatro Score Preview / 分数预览](./BalatroScorePreview) | 1.2.2 | Shows a localized pre-play reference score for the selected hand. Selected logically face-down cards show an unknown value. Standard SMODS probability checks are treated as not triggering, and disruptive vanilla Boss Blind pre-play effects are isolated from the live hand. |
| [Balatro Modifier Warning / 覆盖提醒](./BalatroModifierWarning) | 1.1.2 | Adds a clear language-aware replacement warning badge with old-to-new modifier text when a selected consumable would replace an existing playing-card enhancement or seal. |

## Requirements

- Balatro on PC
- [Lovely Injector](https://github.com/ethangreen-dev/lovely-injector)
- [Steamodded / SMODS](https://github.com/Steamodded/smods)

## Installation

1. Install Lovely.
2. Install Steamodded / SMODS.
3. Download the mod zip from GitHub Releases or Nexus Mods.
4. Extract the zip.
5. Move the mod folder into your Balatro Mods directory:

```text
%AppData%\Balatro\Mods
```

The final layout should look like this:

```text
%AppData%\Balatro\Mods\BalatroStepBack\manifest.json
%AppData%\Balatro\Mods\BalatroShopUndo\manifest.json
%AppData%\Balatro\Mods\BalatroRunArchive\manifest.json
%AppData%\Balatro\Mods\BalatroSupernovaTracker\manifest.json
%AppData%\Balatro\Mods\BalatroScorePreview\manifest.json
%AppData%\Balatro\Mods\BalatroModifierWarning\manifest.json
```

Do not place the mod inside an extra nested folder such as:

```text
%AppData%\Balatro\Mods\BalatroStepBack-1.2.1\BalatroStepBack\manifest.json
```

## Compatibility And Safety

- These mods do not edit Balatro's installed game files.
- These mods do not include executable binaries, DLLs, game assets, textures, sounds, or copyrighted Balatro content.
- Mods with UI text show English, Simplified Chinese, or Traditional Chinese UI based on the game language.
- These mods hook runtime Lua functions or draw steps, so conflicts are still possible with mods that replace the same UI, scoring, or card drawing functions.
- Balatro Step Back / 对局回退 restores checkpoints by using Balatro's run save/load shape. Mods that keep unsaved external state may not restore perfectly.
- Balatro Run History / 历史战绩 stores run records inside Balatro's profile/settings data. The record list is capped so profile data does not grow without limit.
- Balatro Score Preview / 分数预览 uses a sandboxed scoring simulation. It should work with vanilla and most SMODS-style scoring mods, but mods with external side effects, custom random logic outside SMODS probability helpers, custom Boss Blind pre-play events, or nonstandard scoring globals can still differ.

Before reporting an issue, test with only Lovely, Steamodded, and the affected mod enabled.

## Packaging

For Nexus Mods, each upload zip should contain exactly one top-level mod folder:

```text
BalatroStepBack/
  manifest.json
  main.lua
  README.md
  README.zh-CN.md
```

```text
BalatroShopUndo/
  manifest.json
  main.lua
  README.md
  README.zh-CN.md
```

```text
BalatroRunArchive/
  manifest.json
  main.lua
  README.md
  README.zh-CN.md
```

```text
BalatroSupernovaTracker/
  manifest.json
  main.lua
  README.md
  README.zh-CN.md
```

```text
BalatroScorePreview/
  manifest.json
  main.lua
  README.md
  README.zh-CN.md
```

```text
BalatroModifierWarning/
  manifest.json
  main.lua
  README.md
  README.zh-CN.md
```

See [docs/NEXUS_PAGES.md](./docs/NEXUS_PAGES.md) for English Nexus description drafts, and [docs/NEXUS_PAGES.zh-CN.md](./docs/NEXUS_PAGES.zh-CN.md) for Chinese drafts.

## License

GPL-3.0. See [LICENSE](./LICENSE).

Balatro is owned by LocalThunk / Playstack. Lovely and Steamodded/SMODS belong to their respective authors. This repository is not affiliated with or endorsed by them.
