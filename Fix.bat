@echo off
pushd "%~dp0"
echo Starting Deep Repair...
powershell -NoProfile -ExecutionPolicy Bypass -File "Repair_Network.ps1"
pause
