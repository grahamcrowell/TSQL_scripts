# https://technet.microsoft.com/library/hh847748.aspx
Get-ExecutionPolicy -List
Get-ExecutionPolicy -Scope CurrentUser

Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope CurrentUser
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser


[Environment]::UserName
[Environment]::UserDomainName
[Environment]::MachineName
[Environment]::UserDomainName

$var_user = [Environment]::UserName
$var_user

Set-Location C:\Users\$var_user

Get-Location
# Clear-Content

# Clear-Host $Path = "HKLM:\Software\Microsoft\PowerShell"