@echo off
chcp 65001 >nul
cd /d "%~dp0"
title Jaram - Build installer
echo ============================================================
echo  Jaram installer builder (Windows)
echo  Makes dist\Jaram_Setup.exe and dist\Jaram_portable.zip
echo  Needs internet. Takes 5-15 minutes. Do not close this window.
echo ============================================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\build_installer.ps1"
if errorlevel 1 (
  echo.
  echo [ERROR] Build failed. Take a screenshot of this window and send it.
) else (
  echo.
  echo Opening the dist folder...
  start "" explorer "%~dp0dist"
)
pause
