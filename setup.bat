@echo off
:: Nextion Font Generator - Interactive Launcher
:: Double-click to start

cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Unblock-File -Path '.\run_generator.ps1' -ErrorAction SilentlyContinue; Unblock-File -Path '.\ZiLib.dll' -ErrorAction SilentlyContinue; Unblock-File -Path '.\launcher.ps1' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -File ".\launcher.ps1"
pause >nul
