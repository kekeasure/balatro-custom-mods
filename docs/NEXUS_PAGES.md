# Nexus Mods Page Drafts

These drafts are written to be copied into Nexus Mods pages. Keep the final Nexus page truthful and update version numbers before uploading.

## Shared Requirements

- Requires Balatro on PC.
- Requires Lovely Injector.
- Requires Steamodded / SMODS.
- The upload does not include Balatro, Lovely, Steamodded, game files, game art, or copyrighted assets.

Useful links:

- Lovely: https://github.com/ethangreen-dev/lovely-injector
- Steamodded / SMODS: https://github.com/Steamodded/smods
- Steamodded install guide: https://www.nexusmods.com/balatro/articles/31
- GitHub repository: https://github.com/kekeasure/balatro-custom-mods

## Balatro Step Back

### Short Description

Adds current-blind checkpoints and lets you step back to the latest or an earlier play/discard checkpoint.

### About This Mod

Balatro Step Back adds two in-run buttons:

- `回退`: restore the latest checkpoint.
- `记录`: open a list of available play/discard checkpoints from the current blind.

The mod creates a checkpoint before each played or discarded hand. You can return to the latest checkpoint or choose an earlier checkpoint from the current blind. Returning to an earlier checkpoint discards later checkpoint history.

### Installation

1. Install Lovely.
2. Install Steamodded / SMODS.
3. Download `BalatroStepBack-0.2.0.zip`.
4. Extract the zip.
5. Move the `BalatroStepBack` folder into:

```text
%AppData%\Balatro\Mods
```

Final layout:

```text
%AppData%\Balatro\Mods\BalatroStepBack\manifest.json
%AppData%\Balatro\Mods\BalatroStepBack\main.lua
```

Start Balatro and enable/check `Balatro Step Back` in the Steamodded mod list.

### Compatibility And Known Limits

- This mod does not edit game files.
- History is limited to the current blind.
- Restoring a checkpoint briefly reloads the run state.
- The mod uses Balatro's run save/load table shape. Mods that store state outside normal save data may not rewind perfectly.
- If you hit a crash, test again with only Lovely, Steamodded, and this mod enabled, then include your Lovely crash log when reporting.

### Permissions And Credits

Code by ZhiSunian. No Balatro, Lovely, Steamodded, image, audio, or other third-party assets are included.

## Balatro Score Preview

### Short Description

Shows a pre-play reference score for the selected hand. Standard probability effects are treated as not triggering.

### About This Mod

Balatro Score Preview adds a compact HUD line:

```text
参考值：XXXXXX
```

When cards are selected, the mod performs a sandboxed scoring simulation and restores the game state afterward. The preview is intended as a reference value for deterministic scoring. To avoid spoiling probability outcomes and affecting game balance, standard SMODS probability checks are fixed to "not triggered" during the preview. Real play still uses normal random probability.

Examples of probability effects treated as not triggering in the preview include Lucky Card, Bloodstone, Space Joker, and similar SMODS probability-based effects.

### Installation

1. Install Lovely.
2. Install Steamodded / SMODS.
3. Download `BalatroScorePreview-0.3.0.zip`.
4. Extract the zip.
5. Move the `BalatroScorePreview` folder into:

```text
%AppData%\Balatro\Mods
```

Final layout:

```text
%AppData%\Balatro\Mods\BalatroScorePreview\manifest.json
%AppData%\Balatro\Mods\BalatroScorePreview\main.lua
```

Start Balatro and enable/check `Balatro Score Preview` in the Steamodded mod list.

### Compatibility And Known Limits

- This mod does not edit game files.
- The preview is a sandboxed simulation, not a replacement for the real scoring animation.
- It should match vanilla and most SMODS-style deterministic scoring.
- It intentionally does not predict whether probability effects will trigger.
- Mods that write files, change external global state, bypass SMODS probability helpers, or bypass SMODS scoring parameters during scoring may show a different final score.
- If you hit a crash, test again with only Lovely, Steamodded, and this mod enabled, then include your Lovely crash log when reporting.

### Permissions And Credits

Code by ZhiSunian. No Balatro, Lovely, Steamodded, image, audio, or other third-party assets are included.
