@echo off
:: Set current directory
pushd "%~dp0"

echo ---------------------------------------------------
echo   HNSOFTEDU Build Launcher
echo ---------------------------------------------------
echo.

:: Check for powershell
where powershell >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] PowerShell not found in PATH.
    pause
    exit /b
)

echo Starting PowerShell Build Engine...
echo.

:: Run PowerShell script with bypass policy
powershell -NoProfile -ExecutionPolicy Bypass -File "Build.ps1"

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Build script failed with exit code %errorlevel%
    pause
)

popd
