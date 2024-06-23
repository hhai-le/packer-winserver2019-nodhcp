$Host.UI.RawUI.WindowTile = "update"
Get-PackageProvider -name nuget -force
Install-Module PSWindowsUpdate -confirm:$false -force -Verbose
Import-Module -name PSWindowsUpdate -Verbose
Get-WindowsUpdate -MicrosoftUpdate -install -IgnoreUserInput -acceptall -IgnoreReboot

shutdown /s /t 10 /f /d p:4:1 /c "Packer Build Complete"
