Clear-Host
$ScriptFolder = $PSScriptRoot
$ScriptFolder = "C:\Users\gcrowell\Dropbox\Vault\Dev\CommunityMart\Database\Table"
$ScriptFolder = "C:\Users\gcrowell\Dropbox\Vault\Dev\CommunityMart\Database\Index"
$TargetServer = "STDBDECSUP01"
$TargetDatabase = "CommunityMart"
Set-Location -Path $ScriptFolder
$ScriptFiles = Get-ChildItem -Path $ScriptFolder -Filter "*.sql"

foreach($ScriptFile in $ScriptFiles)
{
    Write-Host $ScriptFile
    $ScriptFileName = $ScriptFile.Name
    if($ScriptFile.Name.Contains(" "))
    {
        $ScriptFileName = $ScriptFileName.Replace(" ","_")
        $ScriptFileNameOld = $ScriptFileName
        Write-Host ("script file names cannot contain white space: renaming local copy. ' '->'_' ({0} -> {1})" -f  $ScriptFileNameOld, $ScriptFileName)
        $ScriptFilePath = $ScriptFile.PSPath
        Rename-Item $ScriptFilePath -NewName $ScriptFileName
    }
    $SqlCmd = ("SQLCMD -S{0} -E -d{1} -i""{2}""" -f $TargetServer, $TargetDatabase, $ScriptFileName)
    Write-Host $SqlCmd
    Invoke-Expression -Command:"$SqlCmd"
}
