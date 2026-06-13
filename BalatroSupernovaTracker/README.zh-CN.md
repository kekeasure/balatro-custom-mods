# Balatro Supernova Tracker / 超新星追踪

[English README](./README.md)

版本：1.0.2

这个模组会在 **超新星** 小丑牌的说明里追加一个小型追踪面板。

超新星的实际效果是：当前打出的牌型在本赛局内打出过多少次，就给多少倍率。原版说明只解释机制，但不直接告诉你每个牌型目前已经累计了多少次。这个模组会在说明底部显示各牌型当前对应的 `+倍率`，方便你判断超新星现在到底能给多少加成。

## 功能

- 在超新星小丑牌说明中显示各牌型当前累计次数，包括同花五条、同花葫芦、五条等隐藏牌型。
- 支持英文、简体中文、繁体中文。
- 牌型名称优先使用游戏自带本地化文本。
- 不改变计分、不改变随机、不改变存档、不改变经济和小丑牌实际效果。

## 依赖

- PC 版 Balatro
- Lovely Injector
- Steamodded / SMODS

## 安装

解压压缩包，将 `BalatroSupernovaTracker` 文件夹放入：

```text
%AppData%\Balatro\Mods
```

最终结构应为：

```text
%AppData%\Balatro\Mods\BalatroSupernovaTracker\manifest.json
%AppData%\Balatro\Mods\BalatroSupernovaTracker\main.lua
```

## 兼容性

这个模组只挂接卡牌说明生成逻辑，并且只会在对局中给超新星追加说明区域。通常不影响其他玩法模组，但如果其他模组完全替换超新星说明或同一个卡牌 UI 函数，仍可能发生显示冲突。

## 更新日志

### 1.0.2

- 显示 Balatro 的 12 种牌型，包括隐藏牌型。
- 将倍率数字改成更清晰的金色，不再使用低对比度灰色。

### 1.0.1

- 修复启用追踪器后，在收藏页面悬停卡牌可能导致游戏崩溃的问题。
- 追踪面板现在只会在当前对局牌型统计可用时显示。

### 1.0.0

- 添加首版超新星说明追踪面板。

Balatro 归 LocalThunk / Playstack 所有。本模组与其没有从属、授权或背书关系。
