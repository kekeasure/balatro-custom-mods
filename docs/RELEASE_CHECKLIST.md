# Release Checklist

[中文版本](./RELEASE_CHECKLIST.zh-CN.md)

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
  - In English, confirm the buttons show `Back` and `History`.
  - In Chinese, confirm the buttons show `回退` and `记录`.
  - Play or discard once.
  - Restore the latest checkpoint.
  - Open the checkpoint list and restore an earlier checkpoint.
- Test Balatro Score Preview:
  - In English, select cards and check `Reference: ...` appears.
  - In Chinese, select cards and check `参考值：...` appears.
  - Test at least one normal Joker scoring case.
  - Test one probability case, such as Lucky Card, and confirm the preview uses the non-trigger reference value.

## Nexus Page

- State dependencies: Lovely and Steamodded / SMODS.
- State install path: `%AppData%\Balatro\Mods`.
- State known limits and compatibility warnings.
- Include the GitHub repository link.
- Do not claim perfect compatibility with all mods.
- Do not include copyrighted game files or third-party assets.
