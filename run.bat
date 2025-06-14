
@echo off
echo Starting PiP Controller...

where autohotkey >nul 2>&1
if errorlevel 1 (
    echo AutoHotkey is not installed.
    echo Opening AutoHotkey download page...
    start https://www.autohotkey.com/download/ahk-install.exe
    pause
    exit
)

start "" PiPController.ahk
