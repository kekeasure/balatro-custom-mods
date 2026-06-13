# Balatro Comfort Pack / 小丑牌舒适包

[English README](./README.md)

作者：ZhiSunian

Balatro Comfort Pack 是一个整合型 Balatro 辅助模组。本仓库现在以这个整合包为核心：它目前包含六个可选模块，玩家可以在模组配置面板里单独开关。

仓库里仍然保留早期的单独版模块文件夹，因为 Comfort Pack 的各模块基于它们整合而来，而且有些玩家可能只想单独使用其中一个功能。推荐的一体化下载是 `BalatroComfortPack-1.0.0.zip`。

本仓库不包含 Balatro 游戏文件、游戏素材、音频、存档、Lovely 文件、Steamodded 文件、DLL 或其他第三方资产。

## 当前版本

Balatro Comfort Pack：`1.0.0`

当前整合的单独模块基线：

| 模块 | 基线版本 | 分类 | 功能 |
| --- | --- | --- | --- |
| Modifier Warning / 覆盖提醒 | 1.1.2 | 体验优化 | 当消耗牌会替换扑克牌已有的增强牌或蜡封时显示警告。 |
| Run History / 历史战绩 | 0.1.2 | 体验优化 | 记录历史对局、最终小丑牌、最终牌组、优惠券、基础结果、筛选和统计。 |
| Supernova Tracker / 超新星追踪 | 1.0.2 | 体验优化 | 在超新星小丑牌说明里显示各牌型当前能提供多少倍率，包括隐藏牌型。 |
| Score Preview / 分数预览 | 1.3.0 | 影响平衡 | 出牌前显示参考分数；如果当前分数加预览分数已经足够通过盲注，会高亮提示达标。 |
| Shop Undo / 商店回退 | 1.0.1 | 影响平衡 | 在商店里撤回误买、误卖、购买优惠券等常见失误。 |
| Step Back / 对局回退 | 1.2.1 | 影响平衡 | 在盲注内出牌或弃牌前创建检查点，并提供历史菜单和牌面预览。 |

## 功能说明

### 1. Modifier Warning / 覆盖提醒

当选中的消耗牌会替换扑克牌已有的增强牌或蜡封时，提前给出提示。这个功能只用于防止误操作，不会改变实际结果。

### 2. Run History / 历史战绩

添加历史战绩页面，用于查看过去的对局。它会记录卡组、难度、Seed、结果、最终状态、最终小丑牌、牌组、优惠券、筛选和基础统计信息。

### 3. Supernova Tracker / 超新星追踪

改进超新星小丑牌的说明，在 tooltip 里显示每种牌型当前能提供多少倍率，包括同花葫芦、五条等隐藏牌型。

### 4. Score Preview / 分数预览

出牌前显示所选手牌的参考分数。如果当前回合分数加预览分数已经足够通过盲注，参考值条会高亮并提示达标。

分数预览是沙盒试算。概率效果会保守处理，其他模组如果有特殊外部副作用，真实得分仍可能与预览不同。

### 5. Shop Undo / 商店回退

在商店界面添加回退按钮，用于撤回买错牌、误卖、误买优惠券等常见失误。

这个功能会降低误操作成本，因此归类为影响平衡。

### 6. Step Back / 对局回退

在盲注内出牌和弃牌前创建检查点。历史菜单可以查看最近的检查点和牌面预览，并回到指定的更早状态。

这个功能对游戏影响更大，因此归类为影响平衡。

## 配置面板

在 Steamodded 的 Balatro Comfort Pack 配置页里，可以单独开关每个模块。

体验优化类模块默认开启。影响平衡类模块默认关闭，可以手动开启。

面板会区分：

- `当前`：本次游戏会话里实际加载的状态。
- `设置`：已经保存的开关设置。

开关会立刻保存，但已经加载的模块需要重启游戏后才会真正变化。这样可以避免游戏运行中强行卸载 hook，减少不稳定情况。

## 与单独版模组的兼容

Comfort Pack 会尽量避免和单独版模组冲突。

如果检测到对应单独版 mod 已安装并可加载，Comfort Pack 会跳过内部同名模块，把状态标记为 `单独版`，让单独版负责运行。

配置面板只控制 Comfort Pack 内部模块，不能开关单独版 mod。如果想干净使用整合包，请禁用或移除对应单独版模组，只启用 Comfort Pack。

## 语言支持

UI 文本支持：

- 英文
- 简体中文
- 繁体中文

模组会根据 Balatro 当前语言自动选择文本。

## 依赖

- PC 版 Balatro
- [Lovely Injector](https://github.com/ethangreen-dev/lovely-injector)
- [Steamodded / SMODS](https://github.com/Steamodded/smods)

## 安装

1. 安装 Lovely。
2. 安装 Steamodded / SMODS。
3. 从 GitHub Releases 下载 `BalatroComfortPack-1.0.0.zip`。
4. 解压压缩包。
5. 将 `BalatroComfortPack` 文件夹放入 Balatro 的 Mods 目录：

```text
%AppData%\Balatro\Mods
```

最终结构应类似：

```text
%AppData%\Balatro\Mods\BalatroComfortPack\manifest.json
%AppData%\Balatro\Mods\BalatroComfortPack\main.lua
%AppData%\Balatro\Mods\BalatroComfortPack\modules\
```

不要多套一层文件夹，例如不要变成：

```text
%AppData%\Balatro\Mods\BalatroComfortPack-1.0.0\BalatroComfortPack\manifest.json
```

## 安全说明

- Comfort Pack 不会修改 Balatro 的游戏安装文件。
- Comfort Pack 不包含可执行二进制文件、DLL、游戏素材、贴图、音频或受版权保护的 Balatro 内容。
- 历史战绩会把对局记录写入 Balatro 当前配置档案，并限制记录数量，避免配置档案无限变大。
- 分数预览是参考计算，不能完全替代真实计分动画。
- 对局回退和商店回退通过 Balatro 的对局保存/读取数据结构恢复检查点。保存额外外部状态的模组可能无法完全回退。
- 如果其他模组替换同一批 UI、计分、抽牌、商店、存读档或 tooltip 函数，仍然可能出现冲突。

反馈问题前，建议先只启用 Lovely、Steamodded 和 Balatro Comfort Pack 进行复测。

## 打包

发布 zip 应只包含一个顶层模组文件夹：

```text
BalatroComfortPack/
  manifest.json
  main.lua
  config.lua
  README.md
  README.zh-CN.md
  modules/
```

## 许可证

GPL-3.0。详见 [LICENSE](./LICENSE)。

Balatro 归 LocalThunk / Playstack 所有。Lovely 和 Steamodded/SMODS 归其各自作者所有。本仓库与上述作者或项目没有从属、授权或背书关系。
