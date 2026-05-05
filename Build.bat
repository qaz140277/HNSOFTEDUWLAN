@echo off
echo ========================================
echo   HNSOFTEDU 一键单文件生成工具
echo ========================================
echo.

:: 检查是否安装了 dotnet
where dotnet >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] 未检测到 .NET SDK，请确保已安装！
    pause
    exit /b
)

echo 正在清理旧文件...
if exist "dist" rd /s /q "dist"

echo 正在编译并打包 (可能需要 1-2 分钟)...
dotnet publish HNSOFTEDUAuth\HNSOFTEDUAuth.csproj -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -p:PublishReadyToRun=true -p:IncludeNativeLibrariesForSelfExtract=true -p:DebugType=None -p:DebugSymbols=false -o "dist"

if %errorlevel% equ 0 (
    echo.
    echo [成功] 生成完毕！
    echo 成品位置: %cd%\dist\HNSOFTEDUAuth.exe
    start explorer "dist"
) else (
    echo.
    echo [失败] 编译过程中出现错误，请查看上方输出。
)

echo.
echo 按任意键退出...
pause >nul
