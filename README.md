# Balatro Comfort Pack

[中文说明](./README.zh-CN.md)

Author: ZhiSunian

Balatro Comfort Pack is an all-in-one helper mod for Balatro. The repository is centered on this combined pack: it currently includes six optional modules that can be enabled or disabled from the mod's config panel.

The older standalone module folders are kept in the repository because the Comfort Pack modules are based on them and the standalone releases may still be useful for players who only want one feature. The recommended all-in-one download is `BalatroComfortPack-1.0.0.zip`.

No Balatro game files, game art, audio, save files, Lovely files, Steamodded files, DLLs, or other third-party assets are included.

## Current Version

Balatro Comfort Pack: `1.0.0`

Included standalone-module baselines:

| Module | Baseline | Category | What It Does |
| --- | --- | --- | --- |
| Modifier Warning / 覆盖提醒 | 1.1.2 | Quality of life | Shows a warning when a consumable would replace an existing playing-card enhancement or seal. |
| Run History / 历史战绩 | 0.1.2 | Quality of life | Records past runs, final Jokers, final deck, vouchers, basic results, filters, and statistics. |
| Supernova Tracker / 超新星追踪 | 1.0.2 | Quality of life | Adds Supernova's current per-hand Mult bonuses to the Joker tooltip, including hidden hands. |
| Score Preview / 分数预览 | 1.3.0 | Balance-affecting | Shows a pre-play reference score and highlights the row when the current score plus the preview is enough to clear the blind. |
| Shop Undo / 商店回退 | 1.0.1 | Balance-affecting | Adds a shop undo button for accidental buys, sales, voucher purchases, and similar shop mistakes. |
| Step Back / 对局回退 | 1.2.1 | Balance-affecting | Adds in-blind checkpoints before plays and discards, with a history menu and card previews. |

## Feature Details

### 1. Modifier Warning

Warns before a selected consumable replaces an existing playing-card enhancement or seal. The warning is designed to prevent accidental overwrites without changing the result of the action.

### 2. Run History

Adds a run history screen for reviewing previous runs. It records deck, stake, seed, result, final state, final Jokers, deck cards, vouchers, filters, and basic statistics.

### 3. Supernova Tracker

Improves the Supernova Joker tooltip by showing the current Mult bonus for each poker hand, including hidden hands such as Flush House and Five of a Kind.

### 4. Score Preview

Shows a reference score before playing the selected hand. If the current round score plus the previewed score is enough to clear the blind, the reference row is highlighted and marked as enough.

The preview is a sandboxed estimate. Probability effects are treated conservatively, and unusual external side effects from other mods may still make the real score differ.

### 5. Shop Undo

Adds an undo button in the shop for common mistakes, such as buying the wrong card, selling something accidentally, or purchasing a voucher by mistake.

This feature can reduce the cost of mistakes, so it is grouped as balance-affecting.

### 6. Step Back

Creates checkpoints during a blind before plays and discards. The history menu can show recent checkpoints and card previews, then restore to a selected earlier point.

This feature has a larger gameplay impact than the other modules, so it is grouped as balance-affecting.

## Config Panel

Open Balatro Comfort Pack's config page in Steamodded to turn each module on or off.

Quality-of-life modules are enabled by default. Balance-affecting modules are disabled by default and can be enabled manually.

The panel separates:

- `Current`: what is loaded in the current game session.
- `Setting`: the saved on/off setting.

Settings are saved immediately. Loaded modules only change after restarting the game, which avoids partially removing hooks while Balatro is already running.

## Compatibility With Standalone Mods

Comfort Pack tries to avoid conflicts with the standalone versions.

If a matching standalone mod is installed and available, Comfort Pack skips its internal copy of that module, marks it as `Standalone`, and lets the standalone mod handle it.

The config panel only controls Comfort Pack's internal modules. It cannot enable or disable standalone mods. For a clean all-in-one setup, disable or remove the standalone helper mods and use Comfort Pack by itself.

## Language Support

UI text supports:

- English
- Simplified Chinese
- Traditional Chinese

The mod chooses text based on Balatro's current language setting.

## Requirements

- Balatro on PC
- [Lovely Injector](https://github.com/ethangreen-dev/lovely-injector)
- [Steamodded / SMODS](https://github.com/Steamodded/smods)

## Installation

1. Install Lovely.
2. Install Steamodded / SMODS.
3. Download `BalatroComfortPack-1.0.0.zip` from GitHub Releases.
4. Extract the zip.
5. Move the `BalatroComfortPack` folder into your Balatro Mods directory:

```text
%AppData%\Balatro\Mods
```

The final layout should look like this:

```text
%AppData%\Balatro\Mods\BalatroComfortPack\manifest.json
%AppData%\Balatro\Mods\BalatroComfortPack\main.lua
%AppData%\Balatro\Mods\BalatroComfortPack\modules\
```

Do not place the mod inside an extra nested folder such as:

```text
%AppData%\Balatro\Mods\BalatroComfortPack-1.0.0\BalatroComfortPack\manifest.json
```

## Safety Notes

- Comfort Pack does not edit Balatro's installed game files.
- Comfort Pack does not include executable binaries, DLLs, game assets, textures, sounds, or copyrighted Balatro content.
- Run History stores records in Balatro's profile/settings data and caps the record list so profile data does not grow without limit.
- Score Preview is a reference calculation, not a replacement for the real scoring animation.
- Step Back and Shop Undo restore checkpoints through Balatro's run save/load data shape. Mods that keep unsaved external state may not restore perfectly.
- Conflicts are possible with mods that replace the same UI, scoring, card draw, shop, save/load, or tooltip functions.

Before reporting an issue, test with only Lovely, Steamodded, and Balatro Comfort Pack enabled.

## Packaging

The release zip should contain exactly one top-level mod folder:

```text
BalatroComfortPack/
  manifest.json
  main.lua
  config.lua
  README.md
  README.zh-CN.md
  modules/
```

## License

GPL-3.0. See [LICENSE](./LICENSE).

Balatro is owned by LocalThunk / Playstack. Lovely and Steamodded/SMODS belong to their respective authors. This repository is not affiliated with or endorsed by them.
