$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$dist = Join-Path $root "dist"
New-Item -ItemType Directory -Force -Path $dist | Out-Null

$mods = @(
    @{ Name = "BalatroComfortPack"; Version = "1.0.0" },
    @{ Name = "BalatroStepBack"; Version = "1.2.1" },
    @{ Name = "BalatroShopUndo"; Version = "1.0.1" },
    @{ Name = "BalatroRunArchive"; Version = "0.1.2" },
    @{ Name = "BalatroSupernovaTracker"; Version = "1.0.2" },
    @{ Name = "BalatroScorePreview"; Version = "1.3.0" },
    @{ Name = "BalatroModifierWarning"; Version = "1.1.2" }
)

foreach ($mod in $mods) {
    $modPath = Join-Path $root $mod.Name
    $zipPath = Join-Path $dist ("{0}-{1}.zip" -f $mod.Name, $mod.Version)
    if (Test-Path -LiteralPath $zipPath) {
        Remove-Item -LiteralPath $zipPath -Force
    }
    Compress-Archive -LiteralPath $modPath -DestinationPath $zipPath -Force
    Write-Host $zipPath
}
