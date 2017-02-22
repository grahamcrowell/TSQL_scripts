cd $PSScriptRoot


.\copy_data.ps1 -SrcServer "STDBDECSUP03" -SrcDatabase "CommunityMart" -SrcTable "Dim.School" -DestServer "STDBDECSUP01" -Truncate
.\copy_data.ps1 -SrcServer "STDBDECSUP03" -SrcDatabase "DSDW" -SrcTable "Dim.School" -DestServer "STDBDECSUP01" -Truncate

.\copy_data.ps1 -SrcServer "STDBDECSUP03" -SrcDatabase "CommunityMart" -SrcTable "Dim.CommunityLocation" -DestServer "STDBDECSUP01" -Truncate
.\copy_data.ps1 -SrcServer "STDBDECSUP03" -SrcDatabase "DSDW" -SrcTable "Dim.CommunityLocation" -DestServer "STDBDECSUP01" -Truncate

.\copy_data.ps1 -SrcServer "STDBDECSUP03" -SrcDatabase "CommunityMart" -SrcTable "Dim.CommunityOrganization" -DestServer "STDBDECSUP01" -Truncate
.\copy_data.ps1 -SrcServer "STDBDECSUP03" -SrcDatabase "DSDW" -SrcTable "Dim.CommunityOrganization" -DestServer "STDBDECSUP01" -Truncate


.\copy_data.ps1 -SrcServer "STDBDECSUP03" -SrcDatabase "CommunityMart" -SrcTable "dbo.YouthClinicActivityFact" -DestServer "STDBDECSUP01" -Truncate
#.\copy_data.ps1 -SrcServer "STDBDECSUP03" -SrcDatabase "CommunityMart" -SrcTable "dbo.AssessmentContactFact" -DestServer "STDBDECSUP01" -Truncate
#.\copy_data.ps1 -SrcServer "STDBDECSUP03" -SrcDatabase "CommunityMart" -SrcTable "dbo.ImmunizationHistoryFact" -DestServer "STDBDECSUP01" -Truncate
#.\copy_data.ps1 -SrcServer "STDBDECSUP03" -SrcDatabase "CommunityMart" -SrcTable "dbo.ScreeningResultFact" -DestServer "STDBDECSUP01" -Truncate
