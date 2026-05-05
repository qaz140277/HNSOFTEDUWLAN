# 自动化生成单文件 EXE 脚本
Write-Host "正在清理旧的生成文件..." -ForegroundColor Cyan
if (Test-Path "dist") { Remove-Item -Recurse -Force "dist" }

Write-Host "正在发布单文件客户端 (Release x64)..." -ForegroundColor Cyan

dotnet publish -c Release -r win-x64 --self-contained true `
    -p:PublishSingleFile=true `
    -p:PublishReadyToRun=true `
    -p:IncludeNativeLibrariesForSelfExtract=true `
    -p:DebugType=None `
    -p:DebugSymbols=false `
    -o "dist"

if ($?) {
    Write-Host "`n[成功] 您的单文件客户端已生成！" -ForegroundColor Green
    Write-Host "文件位置: $(Get-Location)\dist\HNSOFTEDUAuth.exe" -ForegroundColor Yellow
    explorer.exe "dist"
} else {
    Write-Host "`n[错误] 发布失败，请确保已安装 .NET SDK 且没有程序正在运行。" -ForegroundColor Red
}

pause
