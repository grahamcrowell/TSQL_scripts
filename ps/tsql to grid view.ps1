Import-Module "sqlps" -DisableNameChecking

#Set-Location STDBDECSUP01
Invoke-Sqlcmd -Query "SELECT GETDATE() AS TimeOfQuery;" -ServerInstance STDBDECSUP01 | Out-GridView