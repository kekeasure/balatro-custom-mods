# Balatro Comfort Pack 1.0.0

This is the first stable all-in-one release of Balatro Comfort Pack.

Balatro Comfort Pack combines six helper modules into one mod folder. Each module can be enabled or disabled from the Steamodded mod config panel.

## Included Modules

1. Modifier Warning / 覆盖提醒
   Warns before a consumable replaces an existing enhancement or seal.

2. Run History / 历史战绩
   Records previous runs, final Jokers, final deck, vouchers, filters, and basic statistics.

3. Supernova Tracker / 超新星追踪
   Shows Supernova's current per-hand Mult bonuses in the Joker tooltip.

4. Score Preview / 分数预览
   Shows a pre-play reference score and highlights the row when the preview is enough to clear the blind together with the current round score.

5. Shop Undo / 商店回退
   Adds a shop undo button for common buy, sell, and voucher mistakes.

6. Step Back / 对局回退
   Adds in-blind checkpoints before plays and discards, with history and card previews.

## Important Notes

- English, Simplified Chinese, and Traditional Chinese UI are supported.
- Quality-of-life modules are enabled by default. Balance-affecting modules are disabled by default and can be enabled manually.
- The config panel separates `Current` loaded status from saved `Setting`.
- If a matching standalone mod is installed, Comfort Pack skips that internal module and lets the standalone mod handle it.
- For a clean all-in-one setup, disable the standalone helper mods and use only Comfort Pack.
- The balance-affecting modules are Score Preview, Shop Undo, and Step Back.

## Installation

1. Install Lovely.
2. Install Steamodded / SMODS.
3. Download `BalatroComfortPack-1.0.0.zip`.
4. Extract it.
5. Move the `BalatroComfortPack` folder to:

```text
%AppData%\Balatro\Mods
```

Final layout:

```text
%AppData%\Balatro\Mods\BalatroComfortPack\manifest.json
```

Do not install it as:

```text
%AppData%\Balatro\Mods\BalatroComfortPack-1.0.0\BalatroComfortPack\manifest.json
```

## 中文说明

这是 Balatro Comfort Pack 的第一个稳定整合版。它把六个辅助功能合并到一个 mod 文件夹里，并可在 Steamodded 的配置面板中单独开关。

包含功能：覆盖提醒、历史战绩、超新星追踪、分数预览、商店回退、对局回退。

支持英文、简体中文、繁体中文。若检测到对应单独版 mod，Comfort Pack 会跳过内部同名功能，避免重复挂接导致冲突。
