# Windown Configuration
My goto tools for Windows, managed as a [chezmoi](https://www.chezmoi.io/) repo.

## Setup

```ps
winget install twpayne.chezmoi
chezmoi init --apply https://github.com/nudopnu/win-config.git
```

Or use an existing local clone as chezmoi source by adding this to `~/.config/chezmoi/chezmoi.toml`:
```toml
sourceDir = "~/code/win-config"
```

`chezmoi apply` copies everything in `home/` to `~` (AutoHotkey scripts go to the Startup folder)
and runs `winget configure` whenever `home/configuration.winget` changes.

## Manually apply winget configuration

```ps
winget configure validate -f home/configuration.winget
winget configure test -f home/configuration.winget --accept-configuration-agreements
winget configure -f home/configuration.winget --accept-configuration-agreements
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