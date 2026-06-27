<#
.SYNOPSIS
    ShareMe — Production Release Build Script (Windows PowerShell)
.DESCRIPTION
    Executes pre-build analysis and generates optimized, split-ABI release APKs
    with ProGuard code shrinking and debug info separation (TRD §9.2).
#>

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   ShareMe Production Release Builder   " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host "`n[1/3] Cleaning workspace..." -ForegroundColor Yellow
flutter clean

Write-Host "`n[2/3] Running static analysis..." -ForegroundColor Yellow
flutter analyze
if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[ERROR] flutter analyze failed! Aborting release build." -ForegroundColor Red
    exit 1
}

Write-Host "`n[3/3] Compiling optimized Release APKs (split-ABI + obfuscation)..." -ForegroundColor Yellow
if (-not (Test-Path "build/debug_info")) {
    New-Item -ItemType Directory -Path "build/debug_info" | Out-Null
}

flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/debug_info

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n==========================================" -ForegroundColor Green
    Write-Host "   Release Build Successfully Generated!  " -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Green
    Write-Host "Output files located in: build\app\outputs\flutter-apk\" -ForegroundColor Cyan
} else {
    Write-Host "`n[ERROR] Release build failed." -ForegroundColor Red
    exit 1
}
