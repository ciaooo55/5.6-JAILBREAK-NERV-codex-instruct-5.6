@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0\.."

mode con: cols=120 lines=40 >nul 2>nul
title NERV-BREAK-5.6 // zxwn Lab
color 0B
for /F "delims=" %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set "UI=%~dp0lab_ui.ps1"

call :splash
call :load_panel
goto menu

:menu
cls
call :header
echo.
echo   !ESC![90m------------------------------------------------------------------------!ESC![0m
echo   !ESC![96m[1]!ESC![0m  start    Auto-detect + auto-config + launch
echo   !ESC![96m[2]!ESC![0m  stop     Kill proxy + restore config
echo   !ESC![96m[3]!ESC![0m  status   Check state
echo   !ESC![96m[4]!ESC![0m  tools    Install missing hacking tools
echo   !ESC![90m[0]!ESC![0m  quit     Exit console
echo   !ESC![90m------------------------------------------------------------------------!ESC![0m
echo.
set "choice="
set /p "choice=  > "
if errorlevel 1 goto end

if /i "!choice!"=="1" goto start
if /i "!choice!"=="start" goto start
if /i "!choice!"=="2" goto stop
if /i "!choice!"=="stop" goto stop
if /i "!choice!"=="3" goto status
if /i "!choice!"=="status" goto status
if /i "!choice!"=="4" goto tools
if /i "!choice!"=="tools" goto tools
if /i "!choice!"=="0" goto end
if /i "!choice!"=="q" goto end
if /i "!choice!"=="quit" goto end

echo.
echo   !ESC![91mInvalid choice.!ESC![0m
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Sleep -Milliseconds 800" >nul 2>nul
goto menu

:start
cls
call :header
echo.
call :progress "Starting NERV-BREAK-5.6"
echo   !ESC![90m(auto-detect relay, auto-config Codex, auto-inject bridge)!ESC![0m
start "nerv-proxy" /MIN python proxy_relay.py
timeout /t 3 /nobreak >nul
call :progress "Checking local endpoints"
echo.
echo   Proxy: !ESC![96mhttp://127.0.0.1:8080!ESC![0m !ESC![90m(health check)!ESC![0m
echo   Panel: !ESC![96mhttp://localhost:8090!ESC![0m
echo.
echo   Restart Codex CLI, type: !ESC![96mzxwn!ESC![0m
goto end

:stop
cls
call :header
echo.
call :progress "Stopping proxy"
taskkill /FI "WINDOWTITLE eq nerv-proxy*" /F 2>nul
call :progress "Restoring config"
python proxy_relay.py --restore 2>nul
echo.
echo   !ESC![92mDone.!ESC![0m
goto end

:status
cls
call :header
echo.
call :progress "Checking state"
netstat -ano 2>nul | findstr ":8080" >nul && echo   proxy: !ESC![92mRUNNING!ESC![0m || echo   proxy: !ESC![91mSTOPPED!ESC![0m
curl -s http://127.0.0.1:8080 2>nul || echo   !ESC![90m(proxy not responding)!ESC![0m
goto end

:tools
cls
call :header
echo.
echo   !ESC![93mInstalling missing hacking tools...!ESC![0m
echo.
echo   !ESC![90m[WSL Kali]!ESC![0m 60+ tools (~2GB download)
echo   !ESC![90m[Python]!ESC![0m pip install portable tools
echo   !ESC![90m[Windows]!ESC![0m chocolatey + manual downloads
echo.
echo   !ESC![96m[1]!ESC![0m WSL Kali (recommended)
echo   !ESC![96m[2]!ESC![0m Python tools (sqlmap, pwntools, angr...)
echo   !ESC![96m[3]!ESC![0m Check available tools
echo   !ESC![96m[4]!ESC![0m All (WSL + Python + Go)
echo   !ESC![90m[0]!ESC![0m Back
echo.
set "tchoice="
set /p "tchoice=  > "
if "!tchoice!"=="1" goto tools_wsl
if "!tchoice!"=="2" goto tools_python
if "!tchoice!"=="3" goto tools_check
if "!tchoice!"=="4" goto tools_all
goto menu

:tools_wsl
echo.
echo   Installing WSL Kali Linux...
wsl --install -d kali-linux 2>nul
echo.
echo   After WSL restarts, run:
echo     wsl -d kali-linux
echo     sudo apt update
echo     sudo apt install -y kali-linux-headless
echo.
echo   Then: python mcp_server.py --wsl
pause >nul
goto menu

:tools_python
echo.
echo   Installing Python tools...
python tools/setup.py 2>nul || (
    pip install sqlmap pwntools angr binwalk peframe 2>nul
    echo   Done - check with: python tools/check_tools.py
)
pause >nul
goto menu

:tools_check
echo.
python tools/check_tools.py 2>nul || echo   !ESC![91mcheck_tools.py not found!ESC![0m
pause >nul
goto menu

:tools_all
echo.
echo   [1/2] WSL Kali...
wsl --install -d kali-linux 2>nul
echo   [2/2] Python tools...
python tools/setup.py 2>nul
echo.
echo   Done - run 'tools/check_tools.py' to verify
pause >nul
goto menu

:end
echo.
echo   !ESC![90mPress any key to exit...!ESC![0m
pause >nul
endlocal
exit /b

:splash
if exist "%UI%" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%UI%" splash
) else (
    echo   !ESC![96m5.6-JAILBREAK-NERV!ESC![0m
    timeout /t 2 /nobreak >nul
)
exit /b

:load_panel
cls
call :header
echo.
call :progress "Loading function area"
exit /b

:header
echo   !ESC![96mNERV-BREAK-5.6!ESC![0m !ESC![90m//!ESC![0m !ESC![94m5.6-JAILBREAK-NERV!ESC![0m
echo   !ESC![90mOperational console!ESC![0m
exit /b

:progress
if exist "%UI%" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%UI%" progress "%~1"
) else (
    echo.
    echo   %~1
    echo   /------------------------------------------\
    echo   ^|##########################################^| 100%%
    echo   \------------------------------------------/
)
exit /b
