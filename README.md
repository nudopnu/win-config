# Windown Configuration
My goto tools for Windows.

```ps
winget configure validate -f configuration.winget
winget configure test -f configuration.winget --accept-configuration-agreements
winget configure -f configuration.winget --accept-configuration-agreements
```

If winget is not in `PATH`:
```
Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
Repair-WinGetPackageManager
```
(thanks to https://stackoverflow.com/questions/77758602/winget-is-not-a-cmdlet-name)


Run elevated powershell here from git bash:
```bash
powershell -NoProfile -Command "Start-Process powershell -Verb RunAs -ArgumentList \"-NoExit -Command cd '\$PWD'\""
```