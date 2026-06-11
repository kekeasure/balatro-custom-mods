# Balatro Modifier Warning

Author: ZhiSunian

Chinese name: 覆盖提醒

Version: 1.1.0

Shows a clear replacement warning badge on selected playing cards when the currently selected consumable would replace an existing modifier in the same slot. The badge shows `REPLACE!` and the old-to-new modifier relationship, such as `Gold > Glass`.

## What It Warns About

- Enhancement replacement, such as using The Devil on an already Steel, Gold, Lucky, Glass, Wild, Bonus, Mult, or Stone card.
- Seal replacement, such as using Talisman, Deja Vu, Trance, or Medium on a card that already has a different seal.

The mod does not block the action and does not change game rules. It only adds a visual warning badge near the selected target card.

## What It Does Not Warn About

- Suit conversion cards such as The Star, The Moon, The Sun, and The World.
- Rank conversion, card copying, card destruction, Joker edition effects, or unrelated dangerous actions.
- Face-down or hidden cards, to avoid revealing information the player should not have.

## Installation

1. Install Lovely and Steamodded.
2. Copy the `BalatroModifierWarning` folder into your Balatro `Mods` folder.
3. Restart the game.

## Compatibility

This mod uses a Steamodded draw step and only reads current card state. It should be compatible with most mods. Modded consumables that use the standard `mod_conv` enhancement field are covered automatically; custom scripted modifier changes may need explicit support later.

This archive contains only original Lua mod code and metadata. It does not include Balatro, Lovely, Steamodded, game files, game art, audio, save files, or other third-party assets.

## Changelog

### 1.1.0

- Replaced the subtle orange frame with a clearer red-orange replacement badge.
- The warning now explicitly shows the overwrite relationship, such as `Gold > Glass` or `Red > Gold`.
- The badge is drawn as a readable horizontal label near the target card instead of trying to outline the tilted card.

### 1.0.1

- Fixed the warning frame scale. The orange overlay now uses card-local draw units instead of screen-pixel units, so it stays attached to the selected card instead of covering the screen.

### 1.0.0

- Initial release.
- Added orange warning frames for selected cards whose enhancement would be replaced.
- Added orange warning frames for selected cards whose seal would be replaced by vanilla seal Spectral cards.
