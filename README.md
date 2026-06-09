# Balatro Custom Mods

Author: ZhiSunian

This repository contains small Balatro mods built for the Lovely + Steamodded/SMODS mod stack.

本仓库收录 ZhiSunian 自制的 Balatro / 小丑牌模组。所有模组都基于 Lovely 和 Steamodded/SMODS，不包含 Balatro、Lovely、Steamodded 的文件或游戏素材。

## Mods

| Mod | Version | Purpose |
| --- | --- | --- |
| [Balatro Step Back](./BalatroStepBack) | 0.2.0 | Adds in-blind checkpoints and lets you step back to the latest or an earlier play/discard checkpoint. |
| [Balatro Score Preview](./BalatroScorePreview) | 0.3.0 | Shows a pre-play reference score for the selected hand. Standard SMODS probability checks are treated as not triggering in the preview. |

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
%AppData%\Balatro\Mods\BalatroStepBack-0.2.0\BalatroStepBack\manifest.json
```

## Compatibility And Safety

- These mods do not edit Balatro's installed game files.
- These mods do not include executable binaries, DLLs, game assets, textures, sounds, or copyrighted Balatro content.
- Both mods hook runtime Lua functions, so conflicts are still possible with mods that replace the same UI or scoring functions.
- Balatro Step Back restores checkpoints by using Balatro's run save/load shape. Mods that keep unsaved external state may not rewind perfectly.
- Balatro Score Preview uses a sandboxed scoring simulation. It should work with vanilla and most SMODS-style scoring mods, but mods with external side effects, custom random logic outside SMODS probability helpers, or nonstandard scoring globals can still differ.

Before reporting an issue, test with only Lovely, Steamodded, and the affected mod enabled.

## Packaging

For Nexus Mods, each upload zip should contain exactly one top-level mod folder:

```text
BalatroStepBack/
  manifest.json
  main.lua
  README.md
```

```text
BalatroScorePreview/
  manifest.json
  main.lua
  README.md
```

See [docs/NEXUS_PAGES.md](./docs/NEXUS_PAGES.md) for Nexus description drafts.

## License

GPL-3.0. See [LICENSE](./LICENSE).

Balatro is owned by LocalThunk / Playstack. Lovely and Steamodded/SMODS belong to their respective authors. This repository is not affiliated with or endorsed by them.

