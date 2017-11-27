
# script parameters
#requires -version 2.0 
  Param (
      [parameter(Mandatory = $true)]
      [string] $SrcServer,
      [parameter(Mandatory = $true)]
      [string] $SrcDatabase,
      [parameter(Mandatory = $true)]
      [string] $SrcTable,
      [parameter(Mandatory = $true)]
      [string] $DestServer,
      [string] $DestDatabase, # Name of the destination database is optional. When omitted, it is set to the source database name.
      [parameter(Mandatory = $true)]
      [string] $DestTable, # Name of the destination table is optional. When omitted, it is set to the source table name.
      [parameter(Mandatory = $true)]
      [switch] $Truncate # Include this switch to truncate the destination table before the copy.
  )


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