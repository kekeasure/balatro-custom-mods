# Balatro Supernova Tracker

[中文说明](./README.zh-CN.md)

Version: 1.0.2

Balatro Supernova Tracker adds a small, localized tracker to the **Supernova** Joker tooltip.

Supernova gives Mult equal to how many times the current poker hand has been played in the run, but the base game does not show those counts on the Joker itself. This mod adds a compact table under Supernova's normal description so you can quickly see each hand's current bonus.

## Features

- Adds current Supernova hand counts directly to the Supernova tooltip, including hidden hands such as Flush Five, Flush House, and Five of a Kind.
- Shows English, Simplified Chinese, or Traditional Chinese text based on the game language.
- Uses Balatro's own localized poker hand names when available.
- Does not change scoring, randomness, saves, economy, or Joker behavior.

## Requirements

- Balatro on PC
- Lovely Injector
- Steamodded / SMODS

## Installation

Extract the zip and place the `BalatroSupernovaTracker` folder in:

```text
%AppData%\Balatro\Mods
```

The final layout should be:

```text
%AppData%\Balatro\Mods\BalatroSupernovaTracker\manifest.json
%AppData%\Balatro\Mods\BalatroSupernovaTracker\main.lua
```

## Compatibility

This mod only hooks the card tooltip generation path and only changes the tooltip for Supernova during a run. It should be compatible with most gameplay mods, but another mod that fully replaces Supernova's tooltip or the same card UI function may conflict.

## Changelog

### 1.0.2

- Shows all 12 Balatro poker hand types, including hidden hands.
- Changed the bonus numbers to a clearer gold colour instead of low-contrast grey.

### 1.0.1

- Fixed a crash when hovering cards in Collection screens with the tracker enabled.
- The tracker now only appears when current-run poker hand stats are available.

### 1.0.0

- Added the first Supernova tooltip tracker.

Balatro is owned by LocalThunk / Playstack. This mod is not affiliated with or endorsed by them.
