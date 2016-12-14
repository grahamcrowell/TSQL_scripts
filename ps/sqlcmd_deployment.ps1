# cd $PSScriptRoot

$root_dir = "C:\Users\gcrowell\_Vault_\Dev\release to test\DR9561 eCN dimension merge DSDW to CommunityMart"
$myArray = "CommunityMart\database\table","CommunityMart\database\view"

foreach ($element in $myArray) {
    Write-Host $element
    $dir_name = Join-Path -Path $root_dir -ChildPath $element
    Write-Host $dir_name
    Get-ChildItem $dir_name -Filter *.sql | 
    Foreach-Object {
        $script_path = $_.FullName
        # [Environment]::NewLine+
        $script_path
        "{0}{1}" -f [Environment]::NewLine,$script_path
        SQLCMD -SSTDBDECSUP01 -E -dmaster -i $script_path
         # -v pathvar=$dir_name
        # $content = Get-Content $_.FullName
        # Write-Host $content
        #filter and save content to the original file
        # $content | Where-Object {$_ -match 'step[49]'} | Set-Content $_.FullName

        #filter and save content to a new file 
        # $content | Where-Object {$_ -match 'step[49]'} | Set-Content ($_.BaseName + '_out.log')
    }
}