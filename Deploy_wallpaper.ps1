<#
.SYNOPSIS
    Deploys a desktop wallpaper to domain-joined machines via GPO logon script.

.DESCRIPTION
    - Copies wallpaper from a network share to local machine.
    - Updates registry keys to set wallpaper.
    - Forces wallpaper refresh without requiring a reboot.

.NOTES
    Author: Your Name
    Tested on: Windows 10/11
#>

# Path to wallpaper on network share (must be accessible to all users)
$SourceWallpaper = "\\MyServer\Share\wallpaper.jpg"

# Local path where wallpaper will be stored
$LocalWallpaper = "$env:PUBLIC\Pictures\wallpaper.jpg"

try {
    # Validate source file exists
    if (-not (Test-Path $SourceWallpaper)) {
        Write-Error "Source wallpaper not found: $SourceWallpaper"
        exit 1
    }

    # Create local folder if not exists
    $LocalFolder = Split-Path $LocalWallpaper
    if (-not (Test-Path $LocalFolder)) {
        New-Item -Path $LocalFolder -ItemType Directory -Force | Out-Null
    }

    # Copy wallpaper to local machine
    Copy-Item -Path $SourceWallpaper -Destination $LocalWallpaper -Force

    # Set registry keys for wallpaper
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name wallpaper -Value $LocalWallpaper
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value "2"   # 2 = Stretch
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -Value "0"    # 0 = No tile

    # Refresh desktop to apply wallpaper immediately
    rundll32.exe user32.dll, UpdatePerUserSystemParameters

    Write-Output "Wallpaper deployed successfully."
}
catch {
    Write-Error "Error deploying wallpaper: $_"
    exit 1
}
