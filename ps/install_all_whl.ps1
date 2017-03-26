$downloads = "C:\Users\gcrowell\Downloads"
Set-Location -Path $downloads

$whl_files = Get-ChildItem -Filter "*.whl"

foreach($whl_file in $whl_files)
{
    Write-Host $whl_file
    pip install $whl_file.Name
}
