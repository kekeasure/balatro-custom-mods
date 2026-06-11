# Balatro 自制模组

[English README](./README.md)

作者：ZhiSunian

本仓库收录 ZhiSunian 自制的 Balatro / 小丑牌模组。所有模组都基于 Lovely 和 Steamodded/SMODS，不包含 Balatro、Lovely、Steamodded 的文件、游戏素材、音频、存档或其他第三方资产。

## 模组列表

| 模组 | 版本 | 用途 |
| --- | --- | --- |
| [Balatro Step Back / 对局回退](./BalatroStepBack) | 1.1.0 | 在当前盲注内记录出牌/弃牌/使用持有消耗牌前的检查点，可回到最近一次或更早的操作前，并按游戏语言显示英文、简体中文或繁体中文 UI；历史列表会显示为“回到第 1 次出牌前”“回到第 1 次使用消耗牌前”等更直观的格式。 |
| [Balatro Score Preview / 分数预览](./BalatroScorePreview) | 1.2.2 | 在出牌前显示所选手牌的参考分数，并按游戏语言显示英文、简体中文或繁体中文 UI；选中的牌处于逻辑背面状态时显示未知值；常规 SMODS 概率判定在预览中按“不触发”处理，原版 Boss Blind 的随机弃牌/翻面等出牌前副作用不会真实作用到手牌。 |

## 依赖

- PC 版 Balatro
- [Lovely Injector](https://github.com/ethangreen-dev/lovely-injector)
- [Steamodded / SMODS](https://github.com/Steamodded/smods)

## 安装

1. 安装 Lovely。
2. 安装 Steamodded / SMODS。
3. 从 GitHub Releases 或 Nexus Mods 下载模组压缩包。
4. 解压压缩包。
5. 将解压得到的模组文件夹放入 Balatro 的 Mods 目录：

```text
%AppData%\Balatro\Mods
```

最终结构应类似：

```text
%AppData%\Balatro\Mods\BalatroStepBack\manifest.json
%AppData%\Balatro\Mods\BalatroScorePreview\manifest.json
```

不要多套一层文件夹，例如不要变成：

```text
%AppData%\Balatro\Mods\BalatroStepBack-1.1.0\BalatroStepBack\manifest.json
```

## 兼容性与安全说明

- 这些模组不会修改 Balatro 的游戏安装文件。
- 这些模组不包含可执行二进制文件、DLL、游戏素材、贴图、音频或受版权保护的 Balatro 内容。
- 模组会根据游戏语言显示英文、简体中文或繁体中文 UI。
- 两个模组都会在运行时挂接 Lua 函数，因此仍可能与改写同一 UI 或计分函数的其他模组冲突。
- Balatro Step Back / 对局回退 使用 Balatro 的对局保存/读取数据结构来恢复检查点。保存额外外部状态的模组可能无法被完全回退。
- Balatro Score Preview / 分数预览 使用沙盒试算。它应能兼容原版和大多数按 SMODS 标准计分流程编写的模组，但如果其他模组有外部副作用、自定义随机逻辑、自定义 Boss Blind 出牌前事件或非标准计分全局状态，预览值仍可能与最终值不同。

反馈问题前，建议先只启用 Lovely、Steamodded 和出问题的单个模组进行复测。

## 打包

上传到 Nexus Mods 时，每个 zip 应只包含一个顶层模组文件夹：

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

英文 Nexus 页面草稿见 [docs/NEXUS_PAGES.md](./docs/NEXUS_PAGES.md)，中文草稿见 [docs/NEXUS_PAGES.zh-CN.md](./docs/NEXUS_PAGES.zh-CN.md)。

## 许可证

GPL-3.0。详见 [LICENSE](./LICENSE)。

Balatro 归 LocalThunk / Playstack 所有。Lovely 和 Steamodded/SMODS 归其各自作者所有。本仓库与上述作者或项目没有从属、授权或背书关系。
