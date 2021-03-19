﻿$ErrorActionPreference = 'Stop'
$checksum              = 'E465225BEDC50523397F9094914722897DC56509C7FCB6861AC815A94D638DDE'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'EXE'
  url64bit       = 'https://kcc.iosphe.re/Windows/'
  softwareName   = 'Kindle Comic Converter*'
  checksum64     = $checksum
  checksumType64 = 'sha256'
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes = @(0)
}

$addionalArgs = Get-PackageParameters

if($addionalArgs['InstallationPath']) {
  $path = $addionalArgs['InstallationPath']
  $packageArgs['silentArgs'] += " /DIR=""$path"""
}

$tasks = [System.Collections.ArrayList]@()
if($addionalArgs['CreateDesktopIcon']) {
  $tasks.Add('desktopicon')
}

if(!$addionalArgs['CBZassociation']) {
  $tasks.Add('!cbzassociation')
}

if(!$addionalArgs['CB7association']) {
  $tasks.Add('!cb7association')
}

if(!$addionalArgs['CBRassociation']) {
  $tasks.Add('!cbrassociation')
}
$packageArgs['silentArgs'] += " /MERGETASKS=""$($tasks -join ' ')"""

Install-ChocolateyPackage @packageArgs