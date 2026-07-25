@echo off
:: NERV-BREAK-5.6 — Complete Tool Installer
:: Installs security tools via WSL Kali (recommended) or pip/go/choco

echo.
echo   ========================================
echo     NERV-BREAK-5.6 工具安装器
echo   ========================================
echo.
echo   [推荐] WSL Kali Linux — 一键装好80%工具
echo   wsl --install -d kali-linux
echo   wsl -d kali-linux
echo   sudo apt update
echo   sudo apt install -y kali-linux-headless
echo.
echo   [可选] 补充安装 WSL 里没有的 Windows 工具
echo.
echo   1. 安装 WSL Kali (推荐, ~2GB)
echo   2. 补充 Windows 工具 (python/go/choco)
echo   3. 检查工具可用性
echo   4. 退出
echo.
set /p "choice=  choice: "

if "%choice%"=="1" goto wsl
if "%choice%"=="2" goto win_tools
if "%choice%"=="3" goto check
if "%choice%"=="4" goto end

:wsl
echo.
echo 正在安装 WSL Kali Linux...
wsl --install -d kali-linux
echo.
echo 安装完成后运行:
echo   wsl -d kali-linux
echo   sudo apt update
echo   sudo apt install -y kali-linux-headless
echo.
echo 然后启动 MCP: python mcp_server.py --wsl
goto end

:win_tools
echo.
echo 安装 Windows 本地工具...

:: Python tools
echo [1/5] Python tools...
pip install sqlmap 2>nul && echo   [OK] sqlmap
pip install pwntools 2>nul && echo   [OK] pwntools
pip install angr 2>nul && echo   [OK] angr
pip install peframe 2>nul && echo   [OK] peframe
pip install binwalk 2>nul && echo   [OK] binwalk
pip install yara-python 2>nul && echo   [OK] yara

:: Go tools
echo [2/5] Go tools...
where go >nul 2>&1 && (
    go install github.com/ffuf/ffuf/v2@latest 2>nul && echo   [OK] ffuf
    go install github.com/OJ/gobuster/v3@latest 2>nul && echo   [OK] gobuster
    go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest 2>nul && echo   [OK] subfinder
    go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest 2>nul && echo   [OK] nuclei
) || echo   [--] Go not installed (skip go tools)

:: Chocolatey tools
echo [3/5] Chocolatey tools...
where choco >nul 2>&1 && (
    choco install nmap -y 2>nul && echo   [OK] nmap
    choco install wireshark -y 2>nul && echo   [OK] wireshark
    choco install processhacker -y 2>nul && echo   [OK] processhacker
) || echo   [--] Chocolatey not installed (skip)

:: Manual downloads
echo [4/5] Manual downloads...
echo   IDA Free:    https://hex-rays.com/ida-free/
echo   Ghidra:      https://github.com/NationalSecurityAgency/ghidra/releases
echo   x64dbg:      https://x64dbg.com/
echo   dnSpy:       https://github.com/dnSpy/dnSpy/releases
echo   Cheat Engine: https://www.cheatengine.org/
echo   DetectItEasy: https://github.com/horsicq/Detect-It-Easy/releases

echo [5/5] Done.
goto end

:check
echo.
echo 检查已安装工具...
python "%~dp0\check_tools.py"
goto end

:end
echo.
pause
