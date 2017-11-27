$SolutionRoot="C:\Users\user\Source\Repos"
$OldSolutionName="OdbcDataWarehouseSimulator"
$NewSolutionName="OdbcCpp"
Set-Location -Path $SolutionRoot

#Rename-Item -Path "$SolutionRoot\$OldSolutionName" -NewName $NewSolutionName

Set-Location -Path "$SolutionRoot\$NewSolutionName"

#Remove-Item -Path "Debug"
#Remove-Item -Path "ipch"
#Remove-Item -Path "OdbcDataWarehouseSimulator.sdf"

$OldNames=Get-ChildItem -Filter "*$OldSolutionName*"
foreach($OldName in $OldNames)
{
    Rename-Item -Path "$OldName" -NewName "$OldName".Replace($OldSolutionName,$NewSolutionName)
    
}
Get-ChildItem
$OldFiles=Get-ChildItem # | Where-Object {$_.Name -ilike {"sln","vcxproj"}}
foreach($OldFile in $OldFiles)
{
    #$Content=
    Write-Host $OldFile
    $Content=Get-Content -Path $OldFile -Raw
    if($Content.Contains($OldSolutionName))
    {
        Write-Host "---------------------------------------------"
        Write-Host "---------------------------------------------"
        Write-Host "---------------------------------------------"

    }
    $Content.Replace($OldSolutionName,$NewSolutionName)
    Set-Content -Path $OldFile -Value $Content.Replace($OldSolutionName,$NewSolutionName)
    Write-Host $OldFile

}



