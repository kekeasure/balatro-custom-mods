$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$dist = Join-Path $root "dist"
New-Item -ItemType Directory -Force -Path $dist | Out-Null

$mods = @(
    @{ Name = "BalatroStepBack"; Version = "1.0.0" },
    @{ Name = "BalatroScorePreview"; Version = "1.2.1" }
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
