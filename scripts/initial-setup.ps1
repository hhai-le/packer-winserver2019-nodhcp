sleep 10
$profile = Get-NetConnectionProfile
Set-NetConnectionProfile -Name $profile.Name -NetworkCategory Private

winrm quickconfig -quiet
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

$rule = @{
    Name = "RDP-3389"
    DisplayName = "Windows Remote Destop (RDP-In)"
    Description = "Inbound rule for Windows Remote Destop. [TCP 3389]"
    Enabled = "true"
    Direction = "Inbound"
    Profile = "Any"
    Action = "Allow"
    Protocol = "TCP"
    LocalPort = "3389"
  }
New-NetFirewallRule @rule

$rule1 = @{
    Name = "WINRM-HTTPS-In-TCP-5985"
    DisplayName = "Windows Remote Management (HTTPS-In)"
    Description = "Inbound rule for Windows Remote Management via WS-Management. [TCP 5985]"
    Enabled = "true"
    Direction = "Inbound"
    Profile = "Any"
    Action = "Allow"
    Protocol = "TCP"
    LocalPort = "5985"
  }
New-NetFirewallRule @rule1
Restart-Service WinRM
