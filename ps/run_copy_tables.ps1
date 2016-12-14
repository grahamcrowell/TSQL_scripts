cd $PSScriptRoot
.\copy_data.ps1 -SrcServer "STDBDECSUP03" -SrcDatabase "DSDW" -DestServer "STDBDECSUP01" -SrcTable "Community.ReferralFact" -Truncate
