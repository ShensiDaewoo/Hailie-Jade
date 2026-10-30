@echo off
chcp 65001 >nul
cd /d "%~dp0"
title Jaram - AI Learning Agent

rem ---- 1. Python: use this folder's .venv, or create one ----
if exist ".venv\Scripts\python.exe" goto venv_ok
echo [1/4] Creating virtual environment (.venv)...
set BASEPY=python
where python >nul 2>nul || set BASEPY=py
%BASEPY% -m venv .venv || (
  echo [ERROR] Python not found. Install from python.org and check "Add Python to PATH".
  pause & exit /b
)
:venv_ok
set PY=.venv\Scripts\python.exe
echo [1/4] Python: %PY%

rem ---- 2. Modules ----
rem   first run only: install once, then leave a marker so later runs skip the slow check
if exist ".venv\jaram_ready.txt" goto mods_ok
echo [2/4] First run: installing streamlit, anthropic, pandas (1-3 minutes, only once)...
%PY% -m pip install -q --disable-pip-version-check streamlit anthropic httpx pandas segno || (
  echo [ERROR] Install failed. Check internet connection.
  pause & exit /b
)
echo ok> ".venv\jaram_ready.txt"
:mods_ok
%PY% -c "import segno" 2>nul || %PY% -m pip install -q --disable-pip-version-check segno
echo [2/4] Modules ready.
rem   skip Streamlit's one-time e-mail question (it silently waits for input)
if not exist "%USERPROFILE%\.streamlit" mkdir "%USERPROFILE%\.streamlit"
if not exist "%USERPROFILE%\.streamlit\credentials.toml" (
  > "%USERPROFILE%\.streamlit\credentials.toml" echo [general]
  >> "%USERPROFILE%\.streamlit\credentials.toml" echo email = ""
)

rem ---- 3. Settings: no questions. Edit config.txt (Notepad) to add an API key ----
if not exist "tools\setup_config.py" (
  echo [ERROR] tools folder is missing. Copy the whole jaram folder here.
  pause & exit /b
)
%PY% tools\setup_config.py
echo       To use AI: open config.txt with Notepad, fill API_KEY (and BASE_URL, MODEL), save, run again.

rem ---- 4. Run ----
if not exist "agent\engine.py" (
  echo [ERROR] agent, core, data folders are missing. Copy the whole jaram folder here.
  pause & exit /b
)
echo [4/4] Opening Jaram in your browser. Keep this window open (this laptop is the class server).
echo       Students on the same Wi-Fi: open the "Network URL" shown below and log in with their 5-digit student number.
echo       If Windows Firewall asks, click Allow.
%PY% -m streamlit run app.py --browser.gatherUsageStats false --server.fileWatcherType none
pause
