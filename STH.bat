@echo off
REM MFS Powered
REM Write by Cartethyia

SET "STREPO=https://github.com/SillyTavern/SillyTavern.git"
SET "STREPO_MIRROR=https://bgithub.xyz/SillyTavern/SillyTavern.git"

:fatal
    echo [FATAL] %~1
    pause
    exit /b 1

:warn
    echo [WARN] %~1
    goto :EOF

:ST_installDeps
    echo Checking for required dependencies...
    
    REM Check for Git
    where git >nul 2>&1
    if %errorlevel% neq 0 (
        echo Git is not installed. Please install Git from https://git-scm.com/download/win and run this script again.
        call :fatal "Git not found."
    )

    REM Check for Node.js and npm
    where node >nul 2>&1
    if %errorlevel% neq 0 (
        echo Node.js is not installed. Please install Node.js from https://nodejs.org/en/download/ and run this script again.
        call :fatal "Node.js not found."
    )
    where npm >nul 2>&1
    if %errorlevel% neq 0 (
        echo npm (Node Package Manager) is not found. It should be installed with Node.js.
        call :fatal "npm not found."
    )

    REM Check for Curl
    where curl >nul 2>&1
    if %errorlevel% neq 0 (
        echo Curl is not installed. It's usually available on Windows 10/11. If not, you might need to add it to your PATH.
        call :warn "Curl not found, but it might still work."
    )
    goto :EOF

:ST_install
    call :ST_installDeps
    
    cd /d %USERPROFILE%
    echo Cloning SillyTavern from primary repository...
    git clone %STREPO% SillyTavern --branch=release --depth=1
    if %errorlevel% neq 0 (
        call :warn "Unable to clone from main repository."
        call :warn "Now trying the mirror repository."
        git clone %STREPO_MIRROR% SillyTavern --branch=release --depth=1
        if %errorlevel% neq 0 (
            call :fatal "Unable to clone the source. Check your Internet connection first."
        )
    )
    
    cd /d %USERPROFILE%\SillyTavern
    echo Downloading STH.bat...
    curl -LO https://raw.githubusercontent.com/ManyFastScripts/SillyTavernHelper/refs/heads/main/STH.bat
    
    echo.
    echo To start SillyTavern, you can use this batch script with the "start" command.
    echo.
    echo Example (from Command Prompt):
    echo cd /d "%~dp0"
    echo %~nx0 start
    echo.
    goto :EOF

:ST_update
    cd /d %USERPROFILE%\SillyTavern
    git reset --hard
    git pull
    goto :EOF

:ST_prepare
    cd /d %USERPROFILE%\SillyTavern
    echo Setting npm registry to npmmirror.com...
    npm config set registry https://registry.npmmirror.com
    echo Installing npm dependencies...
    npm install
    if %errorlevel% neq 0 (
        call :fatal "npm install failed! Check your Node.js and npm installation."
    )
    goto :EOF

:ST_start
    call :ST_prepare
    cd /d %USERPROFILE%\SillyTavern
    echo Starting SillyTavern...
    npm run start
    goto :EOF

REM Main script logic
if "%~1" == "" (
    echo Usage: %~nx0 [command]
    echo Commands:
    echo   install   - Installs SillyTavern and its dependencies.
    echo   update    - Updates SillyTavern to the latest version.
    echo   prepare   - Prepares SillyTavern by installing npm dependencies.
    echo   start     - Starts SillyTavern.
    goto :EOF
)

for %%A in (%*) do (
    if /i "%%A" == "install" call :ST_install
    if /i "%%A" == "update" call :ST_update
    if /i "%%A" == "prepare" call :ST_prepare
    if /i "%%A" == "start" call :ST_start
)

pause
