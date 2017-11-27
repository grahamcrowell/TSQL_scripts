
$root = "K:\SQL_Backup\SPDBSSPS008"
$root = "C:\Users\gcrowell\Dropbox\Vault\Dev"
$database_names = Get-ChildItem -Path $root
$common_sub_dir_name = "/LOG"
$common_sub_dir_name = "/Database"
$target_ext = "sql"
$target_paths = @{}

foreach($database_name in $database_names)
{
    $log_dir_path = Join-Path -Path $root -ChildPath $database_name$common_sub_dir_name;
    
    if(Test-Path -Path $log_dir_path -PathType Container)
    {
        Write-host ("{0} -> {1}" -f $database_name, $log_dir_path)
        $log_files = Get-ChildItem -Path $log_dir_path
        foreach($log_file in $log_files)
        {
            $log_file_path = Join-Path -Path $log_dir_path -ChildPath $log_file
            if(Test-Path -Path $log_file_path -PathType Leaf)
            {
                if($log_file_path -like "*."+$target_ext)
                {
                    Write-Host ("{0} ({1} bytes)" -f $log_file_path, (Get-Item -Path $log_file_path).length)
                    $target_paths.Add($log_file_path, (Get-Item -Path $log_file_path).length)
                }
            }
        }
    }
}

#sort by file length
$targets = $target_paths.GetEnumerator() | Sort-Object Value -Descending
Write-Host "Target Paths:"

foreach($target in $targets)
{
    Write-Host ("{0} ({1} bytes)" -f $target.Name, $target.Value)
    Remove-Item -Path $target.Key -Confirm
}

Write-Host ("{0} targets" -f $target.Count)