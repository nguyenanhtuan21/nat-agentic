<#
.SYNOPSIS
    Nat Agentic Installer for Windows

.DESCRIPTION
    Installs Nat Agentic, a custom Claude Code distribution with curated plugins.

.PARAMETER Version
    Specify version to install (default: latest)

.PARAMETER InstallDir
    Installation directory (default: $env:USERPROFILE\.nat-agentic)

.EXAMPLE
    irm https://nat-agentic.dev/install.ps1 | iex

.EXAMPLE
    .\install.ps1 -Version "1.0.0" -InstallDir "C:\Tools\nat-agentic"
#>

param(
    [string]$Version = "latest",
    [string]$InstallDir = "",
    [switch]$Help
)

# Configuration
$Repo = "nat-agentic/nat-agentic"
$InstallVersion = $Version
if ($InstallDir -eq "") {
    $InstallDir = "$env:USERPROFILE\.nat-agentic"
}

# Colors
function Write-Info { param($msg) Write-Host "[INFO] " -ForegroundColor Blue -NoNewline; Write-Host $msg }
function Write-Success { param($msg) Write-Host "[SUCCESS] " -ForegroundColor Green -NoNewline; Write-Host $msg }
function Write-Warning { param($msg) Write-Host "[WARN] " -ForegroundColor Yellow -NoNewline; Write-Host $msg }
function Write-Error { param($msg) Write-Host "[ERROR] " -ForegroundColor Red -NoNewline; Write-Host $msg }

# Show help
if ($Help) {
    Get-Help $MyInvocation.MyCommand.Path -Detailed
    exit 0
}

# Banner
function Show-Banner {
    Write-Host ""
    Write-Host "  _   _ _______  ______  _   _ _____    _    _ _   _ _ _   _" -ForegroundColor Magenta
    Write-Host " | \ | | ____\ \/ /  _ \| \ | | ____|  / \  | | \ | | | \ | |" -ForegroundColor Magenta
    Write-Host " |  \| |  _|  \  /| |_) |  \| |  _|   / _ \ | |  \| | |  \| |" -ForegroundColor Magenta
    Write-Host " | |\  | |___ /  \|  __/| |\  | |___ / ___ \| | |\  | | |\  |" -ForegroundColor Magenta
    Write-Host " |_| \_|_____/_/\_\_|   |_| \_|_____/_/   \_\_|_| \_|_|_| \_|" -ForegroundColor Magenta
    Write-Host ""
}

# Check if command exists
function Command-Exists {
    param($cmd)
    return [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
}

# Install dependencies
function Install-Dependencies {
    Write-Info "Checking dependencies..."

    # Check for git
    if (-not (Command-Exists "git")) {
        Write-Warning "Git not found. Please install Git from https://git-scm.com"
        Write-Info "You can also use: winget install Git.Git"
        exit 1
    }

    # Check for Node.js
    if (-not (Command-Exists "node")) {
        Write-Warning "Node.js not found. Installing..."

        if (Command-Exists "winget") {
            winget install OpenJS.NodeJS.LTS
        } elseif (Command-Exists "scoop") {
            scoop install nodejs-lts
        } else {
            Write-Error "Please install Node.js manually from https://nodejs.org"
            exit 1
        }
    }

    # Check for Claude Code
    if (-not (Command-Exists "claude")) {
        Write-Warning "Claude Code not found. Installing..."
        npm install -g @anthropic-ai/claude-code
    }

    Write-Success "All dependencies installed"
}

# Download Nat Agentic
function Download-NatAgentic {
    param($version)

    Write-Info "Downloading Nat Agentic $version..."

    $tempDir = New-TempDirectory
    $downloadUrl = ""

    if ($version -eq "latest") {
        $downloadUrl = "https://github.com/$Repo/archive/refs/heads/main.zip"
    } else {
        $downloadUrl = "https://github.com/$Repo/archive/refs/tags/v$version.zip"
    }

    $zipFile = Join-Path $tempDir "nat-agentic.zip"

    try {
        # Download
        Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile -UseBasicParsing

        # Extract
        Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force

        # Find extracted directory
        $extractedDir = Get-ChildItem -Path $tempDir -Directory | Where-Object { $_.Name -like "nat-agentic*" } | Select-Object -First 1

        return $extractedDir.FullName
    } catch {
        Write-Error "Failed to download: $_"
        exit 1
    }
}

# Create temp directory
function New-TempDirectory {
    $tempPath = Join-Path $env:TEMP "nat-agentic-install-$(Get-Random)"
    New-Item -ItemType Directory -Path $tempPath -Force | Out-Null
    return $tempPath
}

# Install Nat Agentic
function Install-NatAgentic {
    param($sourceDir)

    Write-Info "Installing Nat Agentic..."

    # Create directories
    $dirs = @("bin", "config", "marketplace", "branding")
    foreach ($dir in $dirs) {
        $targetDir = Join-Path $InstallDir $dir
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }
    }

    # Copy files
    Copy-Item -Path "$sourceDir\bin\*" -Destination "$InstallDir\bin" -Recurse -Force
    Copy-Item -Path "$sourceDir\config\*" -Destination "$InstallDir\config" -Recurse -Force
    Copy-Item -Path "$sourceDir\marketplace\*" -Destination "$InstallDir\marketplace" -Recurse -Force
    Copy-Item -Path "$sourceDir\branding\*" -Destination "$InstallDir\branding" -Recurse -Force
    Copy-Item -Path "$sourceDir\VERSION" -Destination $InstallDir -Force

    Write-Success "Nat Agentic installed to $InstallDir"
}

# Add to PATH
function Add-ToPath {
    $binPath = "$InstallDir\bin"

    # Check if already in PATH
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($currentPath -notlike "*$binPath*") {
        [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$binPath", "User")
        Write-Success "Added to user PATH"
    } else {
        Write-Info "Already in PATH"
    }

    # Set NAT_AGENTIC_HOME
    [Environment]::SetEnvironmentVariable("NAT_AGENTIC_HOME", $InstallDir, "User")
    Write-Success "Set NAT_AGENTIC_HOME environment variable"
}

# Run setup
function Run-Setup {
    $setupScript = Join-Path $InstallDir "bin\nat-setup"

    if (Test-Path "$setupScript.ps1") {
        Write-Info "Running setup..."
        & "$setupScript.ps1"
    } elseif (Test-Path "$setupScript") {
        Write-Info "Running setup..."
        & bash "$setupScript"
    }
}

# Main
function Main {
    Show-Banner
    Write-Info "Starting installation..."
    Write-Host ""

    # Check architecture
    $arch = if ([Environment]::Is64BitOperatingSystem) { "x64" } else { "x86" }
    Write-Info "Detected: Windows ($arch)"

    # Install dependencies
    Install-Dependencies

    # Download
    $sourceDir = Download-NatAgentic $InstallVersion

    # Install
    Install-NatAgentic $sourceDir

    # Add to PATH
    Add-ToPath

    # Run setup
    Run-Setup

    Write-Host ""
    Write-Success "Installation complete!"
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "  1. Restart your terminal"
    Write-Host "  2. Run 'nat' to start Nat Agentic"
    Write-Host "  3. Run 'nat --help' for available options"
    Write-Host ""
    Write-Host "Documentation: https://nat-agentic.dev/docs"
}

# Run main
Main
