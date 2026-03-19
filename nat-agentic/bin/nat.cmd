@echo off
REM Nat Agentic CLI Wrapper for Windows
REM Custom Claude Code Distribution
REM
REM Usage: nat [options] [prompt]
REM

setlocal EnableDelayedExpansion

REM Version
set "NAT_VERSION_FILE=%~dp0..\VERSION"
if exist "%NAT_VERSION_FILE%" (
    set /p NAT_AGENTIC_VERSION=<"%NAT_VERSION_FILE%"
) else (
    set "NAT_AGENTIC_VERSION=1.0.0"
)

REM Default home directory
if not defined NAT_AGENTIC_HOME set "NAT_AGENTIC_HOME=%USERPROFILE%\.nat-agentic"
set "NAT_AGENTIC_CONFIG=%NAT_AGENTIC_HOME%\config"
set "NAT_AGENTIC_MARKETPLACE=%NAT_AGENTIC_HOME%\marketplace"

REM Parse arguments
set "NAT_SHOW_BANNER=1"
set "NAT_PASS_ARGS="
set "NAT_PROFILE="

:parse_args
if "%~1"=="" goto :main
if "%~1"=="--nat-version" goto :show_version
if "%~1"=="--nat-update" goto :update
if "%~1"=="--nat-config" goto :open_config
if "%~1"=="--profile" (
    set "NAT_PROFILE=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="--no-banner" (
    set "NAT_SHOW_BANNER=0"
    shift
    goto :parse_args
)
if "%~1"=="--help" goto :show_help
if "%~1"=="-h" goto :show_help

set "NAT_PASS_ARGS=%NAT_PASS_ARGS% %~1"
shift
goto :parse_args

:show_version
echo Nat Agentic v%NAT_AGENTIC_VERSION%
for /f "tokens=*" %%i in ('claude --version 2^>nul') do echo Claude Code: %%i
exit /b 0

:show_help
echo Nat Agentic - Custom Claude Code Distribution v%NAT_AGENTIC_VERSION%
echo.
echo Usage: nat [options] [prompt]
echo.
echo Options:
echo   --nat-version       Show Nat Agentic version
echo   --nat-update        Update Nat Agentic to latest version
echo   --nat-config        Open configuration file
echo   --profile ^<name^>    Switch to a profile (web-dev, backend, minimal)
echo   --no-banner         Don't show ASCII banner
echo   --help              Show this help message
echo.
echo Documentation: https://nat-agentic.dev/docs
exit /b 0

:update
echo [Nat Agentic] Checking for updates...

REM Try different update methods
where npm >nul 2>&1
if %errorlevel%==0 (
    npm list -g @nat-agentic/cli >nul 2>&1
    if !errorlevel!==0 (
        echo [Nat Agentic] Updating via NPM...
        npm update -g @nat-agentic/cli
        echo [Nat Agentic] Update complete!
        exit /b 0
    )
)

where scoop >nul 2>&1
if %errorlevel%==0 (
    scoop list | findstr nat-agentic >nul 2>&1
    if !errorlevel!==0 (
        echo [Nat Agentic] Updating via Scoop...
        scoop update nat-agentic
        echo [Nat Agentic] Update complete!
        exit /b 0
    )
)

echo [Nat Agentic] Running PowerShell installer for update...
powershell -Command "irm https://nat-agentic.dev/install.ps1 | iex"
echo [Nat Agentic] Update complete!
exit /b 0

:open_config
set "config_file=%NAT_AGENTIC_CONFIG%\settings.json"

if not exist "%config_file%" (
    echo [Nat Agentic Error] Configuration file not found: %config_file%
    exit /b 1
)

where code >nul 2>&1
if %errorlevel%==0 (
    code "%config_file%"
    exit /b 0
)

where notepad >nul 2>&1
if %errorlevel%==0 (
    notepad "%config_file%"
    exit /b 0
)

type "%config_file%"
exit /b 0

:main
REM Check if Claude Code is installed
where claude >nul 2>&1
if %errorlevel% neq 0 (
    echo [Nat Agentic Error] Claude Code CLI not found!
    echo [Nat Agentic] Please install Claude Code first:
    echo   npm install -g @anthropic-ai/claude-code
    echo   or visit: https://claude.ai/code
    exit /b 1
)

REM Initialize home directory
if not exist "%NAT_AGENTIC_HOME%" (
    echo [Nat Agentic] Initializing home directory...
    mkdir "%NAT_AGENTIC_CONFIG%" 2>nul
    mkdir "%NAT_AGENTIC_MARKETPLACE%" 2>nul
    mkdir "%NAT_AGENTIC_HOME%\logs" 2>nul
)

REM Create default settings if not exists
if not exist "%NAT_AGENTIC_CONFIG%\settings.json" (
    set "default_settings=%~dp0..\config\settings-default.json"
    if exist "!default_settings!" (
        copy "!default_settings!" "%NAT_AGENTIC_CONFIG%\settings.json" >nul
        echo [Nat Agentic] Created default settings
    )
)

REM Switch profile if specified
if defined NAT_PROFILE (
    set "profile_file=%~dp0..\config\profiles\%NAT_PROFILE%.json"
    if exist "!profile_file!" (
        copy "!profile_file!" "%NAT_AGENTIC_CONFIG%\settings.json" >nul
        echo [Nat Agentic] Switched to profile: %NAT_PROFILE%
    ) else (
        echo [Nat Agentic Error] Profile not found: %NAT_PROFILE%
        echo [Nat Agentic] Available profiles: default, web-dev, backend, minimal
        exit /b 1
    )
)

REM Initialize marketplace plugins
set "bundled_marketplace=%~dp0..\marketplace\plugins"
if exist "%bundled_marketplace%" (
    for /d %%d in ("%bundled_marketplace%\*") do (
        set "plugin_name=%%~nxd"
        set "target_dir=%NAT_AGENTIC_MARKETPLACE%\plugins\!plugin_name!"
        if not exist "!target_dir!" (
            echo [Nat Agentic] Installing plugin: !plugin_name!
            xcopy "%%d" "!target_dir!\" /E /I /Q >nul
        )
    )
)

REM Show banner for interactive sessions
if "%NAT_SHOW_BANNER%"=="1" (
    if "%NAT_PASS_ARGS%"=="" (
        set "banner_file=%~dp0..\branding\banner.txt"
        if exist "!banner_file!" (
            for /f "usebackq delims=" %%l in ("!banner_file!") do (
                set "line=%%l"
                echo !line:{VERSION}=%NAT_AGENTIC_VERSION%!
            )
            echo.
        )
    )
)

REM Set environment variables
set "NAT_AGENTIC_HOME=%NAT_AGENTIC_HOME%"
set "NAT_AGENTIC_VERSION=%NAT_AGENTIC_VERSION%"
set "CLAUDE_SETTINGS_PATH=%NAT_AGENTIC_CONFIG%\settings.json"

REM Execute Claude Code
claude --settings-path "%CLAUDE_SETTINGS_PATH%" %NAT_PASS_ARGS%
