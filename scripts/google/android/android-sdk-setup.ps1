Write-Host "Setting up sdk"

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

        if ($line.ToLower().Contains("Installed packages")) {
            $flag_start = 1
        }
        elseif ($line.ToLower().Contains("Available packages")) {
            $flag_start = 0
            break
        }
    }

    $installed_items
}

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


$sdkout = sdkmanager.bat --list
$installed_items = get-installed $sdkout
$latest_buildtools = get-latest-buildtools $sdkout
$buildtools_installed = ($installed_items | ForEach-Object {$_.Contains("build-tools;")}).Contains($true)

if ($buildtools_installed -eq $false) {
    Write-Host "No build-tools detected. Installing the latest version... ($latest_buildtools)" -ForegroundColor Yellow
    sdkmanager.bat "$latest_buildtools"
}
