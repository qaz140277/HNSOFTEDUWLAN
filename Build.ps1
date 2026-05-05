Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "   HNSOFTEDU Auth - Auto Build Script" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/3] Cleaning old files..." -ForegroundColor Yellow
if (Test-Path "dist") { Remove-Item -Path "dist" -Recurse -Force }

Write-Host "[2/3] Publishing and Packaging..." -ForegroundColor Yellow
Write-Host "(ReadyToRun mode enabled. Please wait 1-2 minutes...)"

dotnet publish HNSOFTEDUAuth\HNSOFTEDUAuth.csproj -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -p:PublishReadyToRun=true -p:IncludeNativeLibrariesForSelfExtract=true -p:DebugType=None -p:DebugSymbols=false -o "dist"

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[!] BUILD FAILED! Please check if the app is already running." -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit
}

Write-Host ""
Write-Host "[3/3] BUILD SUCCESSFUL!" -ForegroundColor Green
Write-Host "Result: dist\HNSOFTEDUAuth.exe" -ForegroundColor Green
Write-Host ""
Write-Host "Press Enter to open the output folder..."
Read-Host
start dist
