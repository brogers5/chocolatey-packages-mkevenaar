$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. $toolsDir\helpers.ps1

[version] $softwareVersion = '70.0.2.0'
$installedVersion = Get-InstalledVersion

if ($installedVersion -eq $softwareVersion -and !$env:ChocolateyForce) {
  Write-Output "Google Drive $version is already installed. Skipping download and installation."
}
else {
  if ($softwareVersion -le $installedVersion) {
    Write-Output "Current installed version (v$installedVersion) must be uninstalled first..."
    Uninstall-CurrentVersion
    throw 'Windows must be rebooted before installation can be completed!'
  }

  $packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'exe'
    file           = Join-Path -Path $toolsDir -ChildPath 'GoogleDriveSetup.exe'
    softwareName   = 'Google Drive*'
    silentArgs     = "--silent --desktop_shortcut"
    validExitCodes = @(0, 1641, 3010)
  }

  Install-ChocolateyInstallPackage @packageArgs
}
