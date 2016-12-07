[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo");

$server=new-object Microsoft.SqlServer.Management.Smo.Server "STDBDECSUP01"

$server

$views=$server.Databases["DSDW"].Views | Where-Object {$_.Schema -eq "Community"}

foreach($view in $views)
{
    Write-Host ("{0}`n" -f $view.Name)
    $new_table=new-object Microsoft.SqlServer.Management.Smo.Table
    $server.Databases["gcDev"].Tables.Add($new_table)
    foreach($column in $columns)
    {
        

    }
}

