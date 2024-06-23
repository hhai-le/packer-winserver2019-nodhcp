
$var = 0
$host.UI.RawUI.WindowTile = "check_update"
while ($var -le 60) {
    Write-host $var
    start-sleep 1
}