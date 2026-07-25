@echo off
setlocal enabledelayedexpansion

:: ═══════════════════════════════════════════════════════════════
::  S2.CPP Voice Creator — Save a voice profile for reuse
:: ═══════════════════════════════════════════════════════════════

:: ── CONFIG: Adjust only if you moved files after install ──
set "MODEL=G:\AI\s2.cpp\models\s2-pro-q8_0.gguf"
set "TOKENIZER=G:\AI\s2.cpp\models\tokenizer.json"
set "S2=G:\AI\s2.cpp\build\s2.exe"
set "OUTPUT_DIR=G:\AI\s2.cpp\output"

:: ── Create output folder if missing ──
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

cls
echo.
echo    ╔═══════════════════════════════════════════════════════╗
echo    ║           🔊  S2.CPP VOICE CREATOR                  ║
echo    ╚═══════════════════════════════════════════════════════╝
echo.
echo    This wizard clones a voice from reference audio and
echo    saves it to the default voices folder for instant reuse.
echo.
echo    ─────────────────────────────────────────────────────
echo.

:: ── Get voice name ──
set /p VOICE_NAME="    Voice name (e.g. erik, sarah, narrator): "
if "%VOICE_NAME%"=="" (
    echo    [ERROR] Voice name cannot be empty.
    pause
    exit /b 1
)

:: ── Get reference audio path ──
set /p AUDIO_PATH="    Full path to reference audio (.wav or .mp3): "
if not exist "%AUDIO_PATH%" (
    echo    [ERROR] File not found: %AUDIO_PATH%
    pause
    exit /b 1
)

:: ── Get transcript ──
echo.
echo    ── Enter the EXACT transcript of the reference audio ──
set /p PROMPT_TEXT="    Transcript: "
if "%PROMPT_TEXT%"=="" (
    echo    [ERROR] Transcript cannot be empty. Accuracy matters!
    pause
    exit /b 1
)

:: ── GPU preference ──
echo.
set /p USE_GPU="    Use NVIDIA GPU? (Y/n): "
if /i "%USE_GPU%"=="n" (
    set "GPU_FLAG="
    set "GPU_MSG=CPU"
) else (
    set "GPU_FLAG=--cuda 0"
    set "GPU_MSG=NVIDIA GPU"
)

echo.
echo    ═══════════════════════════════════════════════════════
echo    [+] Cloning voice  : %VOICE_NAME%
echo    [+] Reference      : %AUDIO_PATH%
echo    [+] Backend        : %GPU_MSG%
echo    [+] Saving to      : default voices folder
echo    ═══════════════════════════════════════════════════════
echo.
echo    Building and saving profile... Please wait.
echo.

:: ── Run s2.cpp ──
"%S2%" ^
  --model "%MODEL%" ^
  --tokenizer "%TOKENIZER%" ^
  --prompt-audio "%AUDIO_PATH%" ^
  --prompt-text "%PROMPT_TEXT%" ^
  --voice %VOICE_NAME% ^
  --save-voice ^
  --text "Voice profile initialization complete." ^
  %GPU_FLAG% ^
  --output "%OUTPUT_DIR%\%VOICE_NAME%_init.wav"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo    ❌ ERROR: Voice creation failed. Check the error above.
) else (
    echo.
    echo    ✅ SUCCESS! Voice '%VOICE_NAME%' saved.
    echo.
    echo    ── How to use it ──
    echo    Just add: --voice %VOICE_NAME%
    echo    No need to pass reference audio again!
    echo.
    echo    Example:
    echo    s2.exe --voice %VOICE_NAME% --text "Hello world"
)

echo.
pause
