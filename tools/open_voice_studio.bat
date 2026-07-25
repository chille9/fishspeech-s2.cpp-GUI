@echo off
:: ═══════════════════════════════════════════════════════════════
::  S2 Voice Studio Launcher
:: ═══════════════════════════════════════════════════════════════

echo.
echo    🔊 Launching S2 Voice Studio...
echo.

:: Get the directory where this batch file is located
set "SCRIPT_DIR=%~dp0"

:: Check if the HTA exists
if not exist "%SCRIPT_DIR%s2_voice_studio.hta" (
    echo    ERROR: s2_voice_studio.hta not found in:
    echo    %SCRIPT_DIR%
    echo.
    echo    Make sure this .bat file is in the same folder as the .hta file.
    pause
    exit /b 1
)

:: Launch the HTA
start "" "%SCRIPT_DIR%s2_voice_studio.hta"

echo    ✅ S2 Voice Studio opened!
echo.
echo    If Windows Security asks about running the HTA,
    echo    click "Allow" or "Yes" — it's your local voice tool.
echo.
timeout /t 3 /nobreak >nul
