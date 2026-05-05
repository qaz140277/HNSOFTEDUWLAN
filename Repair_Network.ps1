# 1. Admin Check
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "   HNSOFTEDU Deep Repair and Reset Tool" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

# 2. Kill Processes
Write-Host "[1/5] Cleaning background processes..." -ForegroundColor Yellow
$proc = Get-Process -Name "HNSOFTEDUAuth" -ErrorAction SilentlyContinue
if ($proc) { $proc | Stop-Process -Force }

# 3. Reset WLAN to DHCP
Write-Host "[2/5] Resetting WLAN to DHCP..." -ForegroundColor Yellow
netsh interface ip set address name="WLAN" source=dhcp
netsh interface ip set dns name="WLAN" source=dhcp
ipconfig /release WLAN
ipconfig /renew WLAN

# 4. Clean Routes
Write-Host "[3/5] Cleaning residual routes..." -ForegroundColor Yellow
route delete 10.160.153.254 2>$null
route delete 10.199.199.199 2>$null
route delete 0.0.0.0 mask 0.0.0.0 10.160.153.254 2>$null

# 5. Rebuild
Write-Host "[4/5] Rebuilding application..." -ForegroundColor Yellow
if (Test-Path "dist") { Remove-Item -Path "dist" -Recurse -Force }
dotnet publish HNSOFTEDUAuth\HNSOFTEDUAuth.csproj -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -p:PublishReadyToRun=true -p:IncludeNativeLibrariesForSelfExtract=true -p:DebugType=None -p:DebugSymbols=false -o "dist"

Write-Host ""
Write-Host "[5/5] Success! Environment has been restored." -ForegroundColor Green
Write-Host "------------------------------------------------"
Write-Host "Now you can run dist\HNSOFTEDUAuth.exe" -ForegroundColor Green
Read-Host "Press Enter to exit..."
