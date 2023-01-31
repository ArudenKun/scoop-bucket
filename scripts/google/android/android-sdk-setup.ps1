#requires -version 2
<#
.SYNOPSIS
  This script assists in installing the required build-tools and platform SDKs to get started
  with Flutter development on an Android Phone.
.DESCRIPTION
  This script assists in installing the required build-tools and platform SDKs to get started
  with Flutter development on an Android Phone. It detects whether any SDKs are installed and
  prompts to install them if not.
.INPUTS
  None
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Ardelean Călin
  Creation Date:  14 July 2018
  Purpose/Change: Initial script development
#>


# Gets the installed packages list from sdkmanager
function get-installed {
    param (
        [Object]$sdkmanager_output
    )

    $flag_start = 0
    $installed_items = @()

    ForEach ($line in $sdkmanager_output) {
        if ($flag_start -eq 1) {
            $match = [regex]::Match($line.Trim(), "^(\S*)\s+\|\s+\d+.*")
            if ($match.Success -eq $true) {
                $installed_items += $match.Groups[1].Value
            }
        }

        if ($line.ToLower().Contains("installed packages")) {
            $flag_start = 1
        } elseif ($line.ToLower().Contains("available packages")) {
            $flag_start = 0
            break
        }
    }

    $installed_items
}

# Finds the latest reference to 'build-tools' that is not a release canditate.
# This results in the latest released build-tools version.
function get-latest-buildtools {
    param (
        [Object]$sdkmanager_output
    )

    $latest_buildtools = ""

    ForEach ($line in $sdkmanager_output) {
        $build_tools = [regex]::Match($line.Trim(), "^(build-tools;\d+\.\d+\.\d)(?!-rc.*).*")
        if ($build_tools.Success -eq $true) {
            $latest_buildtools = $build_tools.Groups[1].Value
        }
    }

    $latest_buildtools
}

# Gets available platforms from sdkmanager
function get-latest-platforms {
    param (
        [Object]$sdkmanager_output
    )

    $latest_platforms = ""

    ForEach ($line in $sdkmanager_output) {
        $platform = [regex]::Match($line.Trim(), "platforms;android-(^\d{2}$)")
        if ($platform.Success -eq $true) {
            $latest_platforms = $platform.Groups[1].Value
        }
    }

    $latest_platforms
}

# Check internet conenction first and only continue on success
$connection = Test-NetConnection

if ($connection.PingSucceeded -eq $false) {
    $scriptName = $MyInvocation.MyCommand.Name
    Write-Host "$scriptName could not connect to the internet. Please connect to the internet and try again, or install flutter requirements manually." -ForegroundColor Yellow
    exit 1
}

# Check if sdkmanager exists and in path. Program cannot continue without it
Get-Command "sdkmanager" -ErrorAction SilentlyContinue -ErrorVariable err | Out-Null
if ($err.Count -eq $true) {
    Write-Host "Could not find 'sdkmanager' in PATH. Make sure you have android-sdk installed." -ForegroundColor Red
    exit 2
}

# Runs sdkmanager with the --list argument to see what is installed on the system
# and what needs to be installed.
$sdkout = sdkmanager.bat --list


$installed_items = get-installed $sdkout
$latest_buildtools = get-latest-buildtools $sdkout
$latest_platforms = get-latest-platforms $sdkout

$platform_installed
foreach ($item in $installed_items) {
    if ($item.Contains("platforms;")) {
        $platform_installed = $true
        break
    } else {
        $platform_installed = $false
        break
    }
}
$buildtools_installed
foreach ($item in $installed_items) {
    if ($item.Contains("build-tools;")) {
        $buildtools_installed = $true
        break
    } else {
        $buildtools_installed = $false
        break
    }
}

# No build-tools detected, so we install them
if ($buildtools_installed -eq $false) {
    Write-Host "No build-tools detected. Installing the latest version... ($latest_buildtools)" -ForegroundColor Yellow
    sdkmanager.bat "$latest_buildtools"
}

# No platform SDK detected, so we install one from the available ones
if ($platform_installed -eq $false) {
    Write-Host "No platform detected. Installing the latest version... ($latest_platforms)" -ForegroundColor Yellow
    sdkmanager.bat $latest_platforms
}

# Done. We should be able to develop for Android now.
Write-Host "All required dependencies for Android Development are installed." -ForegroundColor Green
