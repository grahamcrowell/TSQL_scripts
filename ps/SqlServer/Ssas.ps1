Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
Enable-psremoting -Force

#STDSDB004
#WinRM already is set up to receive requests on this machine.
#WinRM already is set up for remote management on this machine.
Import-module "sqlps" -DisableNameChecking
Import-module "sqlascmdlets"



Set-Location sqlas
dir
Set-Location STDSDB004
dir
# multi-dim
Set-Location DEFAULT
Set-Location ..\TABULAR
dir
Set-Location Databases
dir
Set-Location ReferralAcuteAdmissionCube
dir
Set-Location Cubes
dir
Set-Location Model
dir
Set-Location Perspectives
dir
Set-Location Advanced
dir

Set-Location ..
dir
$Perspectives = Get-ChildItem
$Perspective = $Perspectives | Where-Object {$_.Name -eq "Advanced"} 
$Perspectives[0].MeasureGroups
$Perspectives[1].MeasureGroups

$Perspectives[0].Dimensions
$Perspectives[1].Dimensions


Set-Location \sqlas\STDSDB004\TABULAR\Databases
# exclude workspace and other messyness
$Cubes = Get-ChildItem | Where-Object {$_.Name -notlike "*_*"} | Where-Object {$_.Name -notlike "* *"} | Where-Object {$_.State -eq "Processed"}

$CubeRootPath = Get-Location
foreach($Cube in $Cubes)
{
    Write-Host $Cube.Name


    break
}
