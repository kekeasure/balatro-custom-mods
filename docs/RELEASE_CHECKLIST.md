# Release Checklist

Use this before publishing to GitHub Releases or Nexus Mods.

## Files

- `BalatroStepBack/manifest.json` has the correct version and author.
- `BalatroScorePreview/manifest.json` has the correct version and author.
- Each mod folder contains only files needed by users: `manifest.json`, `main.lua`, `README.md`.
- No Balatro game files, Lovely files, Steamodded files, generated dumps, logs, screenshots, save files, or user paths are included.

## Packaging

- `BalatroStepBack-<version>.zip` contains `BalatroStepBack/manifest.json` at the first folder level.
- `BalatroScorePreview-<version>.zip` contains `BalatroScorePreview/manifest.json` at the first folder level.
- Extracting the zip does not create an extra nested folder.

## Local Validation

- Launch Balatro with Lovely and Steamodded.
- Confirm both mods appear in the Steamodded mod list.
- Test Balatro Step Back:
  - Play or discard once.
  - Click `回退`.
  - Open `记录` and restore an earlier checkpoint.
- Test Balatro Score Preview:
  - Select cards and check `参考值：...` appears.
  - Test at least one normal Joker scoring case.
  - Test one probability case, such as Lucky Card, and confirm the preview uses the non-trigger reference value.

## Nexus Page

- State dependencies: Lovely and Steamodded / SMODS.
- State install path: `%AppData%\Balatro\Mods`.
- State known limits and compatibility warnings.
- Include the GitHub repository link.
- Do not claim perfect compatibility with all mods.
- Do not include copyrighted game files or third-party assets.

