Get-NetIpAddress -InterfaceAlias Ethernet0 | New-NetIpAddress -IpAddress 192.168.148.215 -PrefixLength 24 -DefaultGateway 192.168.148.1

Set-DNSClientServerAddress "Ethernet0" -ServerAddresses ("192.168.148.11","192.168.148.12")