@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0\.."

mode con: cols=120 lines=40 >nul 2>nul
title NERV-BREAK-5.6 // Kali BlackIce Setup
color 0A
for /F "delims=" %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"

call :splash
goto menu

:menu
cls
call :header
echo.
echo   %ESC%[90m------------------------------------------------------------------------%ESC%[0m
echo   %ESC%[92m[1]%ESC%[0m  wsl      Install Kali via Windows Subsystem for Linux
echo   %ESC%[92m[2]%ESC%[0m  docker   Deploy Kali tool container
echo   %ESC%[92m[3]%ESC%[0m  remote   Bind existing Kali VM over SSH
echo   %ESC%[92m[4]%ESC%[0m  test     Verify Kali tool links
echo   %ESC%[90m[0]%ESC%[0m  back     Exit setup console
echo   %ESC%[90m------------------------------------------------------------------------%ESC%[0m
echo.
set "choice="
set /p "choice=  > "
if errorlevel 1 goto end

if /i "!choice!"=="1" goto wsl
if /i "!choice!"=="wsl" goto wsl
if /i "!choice!"=="2" goto docker
if /i "!choice!"=="docker" goto docker
if /i "!choice!"=="3" goto remote
if /i "!choice!"=="remote" goto remote
if /i "!choice!"=="4" goto test
if /i "!choice!"=="test" goto test
if /i "!choice!"=="0" goto end
if /i "!choice!"=="q" goto end
if /i "!choice!"=="quit" goto end
if /i "!choice!"=="back" goto end

echo.
echo   %ESC%[91mInvalid choice.%ESC%[0m
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Sleep -Milliseconds 800" >nul 2>nul
goto menu

:wsl
cls
call :header
echo.
call :progress "Opening WSL Kali channel"
echo   %ESC%[90m[target]%ESC%[0m kali-linux
echo   %ESC%[90m[state ]%ESC%[0m installer handoff
echo.
wsl --install -d kali-linux
echo.
echo   %ESC%[92mAfter install, run inside Kali:%ESC%[0m
echo     sudo apt update ^&^& sudo apt install -y kali-linux-headless
echo     sudo apt install -y nmap sqlmap hydra metasploit-framework john hashcat
echo     sudo apt install -y radare2 binwalk exiftool foremost tcpdump netcat
echo     sudo apt install -y dirb nikto wpscan ffuf searchsploit
echo.
goto end

:docker
cls
call :header
echo.
call :progress "Spawning Kali Docker node"
echo   %ESC%[90m[image]%ESC%[0m kalilinux/kali-rolling
echo   %ESC%[90m[name ]%ESC%[0m kali-tools
echo.
docker pull kalilinux/kali-rolling
docker run -d --name kali-tools kalilinux/kali-rolling sleep infinity
docker exec kali-tools apt update
docker exec kali-tools apt install -y kali-linux-headless
echo.
echo   %ESC%[92mKali Docker ready.%ESC%[0m
echo   Use: %ESC%[96mdocker exec kali-tools [command]%ESC%[0m
goto end

:remote
cls
call :header
echo.
echo   %ESC%[90mRemote Kali uplink parameters%ESC%[0m
echo.
set "ssh_host="
set "ssh_port="
set /p "ssh_host=  Kali SSH (user@host): "
set /p "ssh_port=  SSH port (default 22): "
if "!ssh_port!"=="" set "ssh_port=22"
echo.
call :progress "Testing SSH uplink"
ssh -o StrictHostKeyChecking=no -p !ssh_port! !ssh_host! "echo OK"
if errorlevel 1 (
    echo.
    echo   %ESC%[91mSSH failed. Check host, port, key, or firewall.%ESC%[0m
) else (
    echo.
    echo   %ESC%[92mSSH OK.%ESC%[0m Start proxy with:
    echo     %ESC%[96mpython mcp_server.py --kali !ssh_host!%ESC%[0m
)
goto end

:test
cls
call :header
echo.
call :progress "Scanning local tool surface"
echo.
where nmap >nul 2>&1 && echo   %ESC%[92m[OK]%ESC%[0m nmap || echo   %ESC%[90m[--]%ESC%[0m nmap
where sqlmap >nul 2>&1 && echo   %ESC%[92m[OK]%ESC%[0m sqlmap || echo   %ESC%[90m[--]%ESC%[0m sqlmap
where msfconsole >nul 2>&1 && echo   %ESC%[92m[OK]%ESC%[0m msfconsole || echo   %ESC%[90m[--]%ESC%[0m msfconsole
where hydra >nul 2>&1 && echo   %ESC%[92m[OK]%ESC%[0m hydra || echo   %ESC%[90m[--]%ESC%[0m hydra
wsl nmap --version >nul 2>&1 && echo   %ESC%[92m[OK]%ESC%[0m Kali WSL nmap || echo   %ESC%[90m[--]%ESC%[0m Kali WSL
docker exec kali-tools nmap --version >nul 2>&1 && echo   %ESC%[92m[OK]%ESC%[0m Kali Docker nmap || echo   %ESC%[90m[--]%ESC%[0m Kali Docker
echo.
goto end

:end
echo.
echo   %ESC%[90mPress any key to exit...%ESC%[0m
pause >nul
endlocal
exit /b

:splash
cls
echo.
echo   %ESC%[92m __    _  _____  ____   _   _ %ESC%[0m
echo   %ESC%[92m^|  \  ^| ^|^| ____^|^|  _ \ ^| ^| ^| ^|%ESC%[0m
echo   %ESC%[92m^|   \ ^| ^|^|  _^|  ^| ^|_) ^|^| ^| ^| ^|%ESC%[0m
echo   %ESC%[32m^| ^|\ \^| ^|^| ^|___ ^|  _ ^< ^| ^|_^| ^|%ESC%[0m
echo   %ESC%[32m^|_^| \___^|^|_____^|^|_^| \_\ \___/ %ESC%[0m
echo.
echo   %ESC%[90mKALI BLACKICE SETUP // terminal bridge loader%ESC%[0m
echo   %ESC%[90m[ascii-safe render mode]%ESC%[0m
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Sleep -Milliseconds 900" >nul 2>nul
exit /b

:header
echo   %ESC%[92mNERV-BREAK-5.6%ESC%[0m %ESC%[90m//%ESC%[0m %ESC%[32mKALI BLACKICE SETUP%ESC%[0m
echo   %ESC%[90mKali integration console%ESC%[0m
exit /b

:progress
echo.
echo   %ESC%[92m%~1%ESC%[0m
echo   %ESC%[90m/------------------------------------------\%ESC%[0m
echo   %ESC%[32m^|##########################################^|%ESC%[0m %ESC%[92m100%%%ESC%[0m
echo   %ESC%[90m\------------------------------------------/%ESC%[0m
exit /b
