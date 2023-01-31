Info "Setting up sdk"

Info "Checking if cmdline-tools are setup correctly"
Get-Command "sdkmanager" -ErrorAction SilentlyContinue -ErrorVariable err | Out-Null
if ($err.Count -eq $true) {
    Write-Host "Could not find 'sdkmanager' in PATH" -ForegroundColor Red
    exit 2
}

function Get-Installed {
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
        }
        elseif ($line.ToLower().Contains("available packages")) {
            $flag_start = 0
            break
        }
    }

    $installed_items
}

function Get-Latest-Buildtools {
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


$sdkout = sdkmanager.bat --list
$installed_items = Get-Installed $sdkout
$latest_buildtools = Get-Latest-Buildtools $sdkout
$buildtools_installed = ($installed_items | ForEach-Object {$_.Contains("build-tools;")}).Contains($true)

if ($buildtools_installed -eq $false) {
    Write-Host "No build-tools detected. Installing the latest version... ($latest_buildtools)" -ForegroundColor Yellow
    sdkmanager.bat "$latest_buildtools"
}
