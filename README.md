# Balatro Custom Mods

[中文说明](./README.zh-CN.md)

Author: ZhiSunian

This repository contains small Balatro mods built for the Lovely + Steamodded/SMODS mod stack.

No Balatro, Lovely, Steamodded, game files, game art, audio, save files, or other third-party assets are included.

## Mods

| Mod | Version | Purpose |
| --- | --- | --- |
| [Balatro Step Back / 对局回退](./BalatroStepBack) | 1.1.0 | Adds localized in-blind checkpoints and lets you step back to the latest or an earlier play/discard/held-consumable checkpoint. The history menu uses clearer labels such as `Go back before Play #1` and `Go back before Consumable #1`. |
| [Balatro Score Preview / 分数预览](./BalatroScorePreview) | 1.2.2 | Shows a localized pre-play reference score for the selected hand. Selected logically face-down cards show an unknown value. Standard SMODS probability checks are treated as not triggering, and disruptive vanilla Boss Blind pre-play effects are isolated from the live hand. |

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
%AppData%\Balatro\Mods\BalatroScorePreview\manifest.json
```

Do not place the mod inside an extra nested folder such as:

```text
%AppData%\Balatro\Mods\BalatroStepBack-1.1.0\BalatroStepBack\manifest.json
```

## Compatibility And Safety

- These mods do not edit Balatro's installed game files.
- These mods do not include executable binaries, DLLs, game assets, textures, sounds, or copyrighted Balatro content.
- Both mods show English, Simplified Chinese, or Traditional Chinese UI based on the game language.
- Both mods hook runtime Lua functions, so conflicts are still possible with mods that replace the same UI or scoring functions.
- Balatro Step Back / 对局回退 restores checkpoints by using Balatro's run save/load shape. Mods that keep unsaved external state may not restore perfectly.
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
BalatroScorePreview/
  manifest.json
  main.lua
  README.md
  README.zh-CN.md
```

See [docs/NEXUS_PAGES.md](./docs/NEXUS_PAGES.md) for English Nexus description drafts, and [docs/NEXUS_PAGES.zh-CN.md](./docs/NEXUS_PAGES.zh-CN.md) for Chinese drafts.

## License

GPL-3.0. See [LICENSE](./LICENSE).

Balatro is owned by LocalThunk / Playstack. Lovely and Steamodded/SMODS belong to their respective authors. This repository is not affiliated with or endorsed by them.
