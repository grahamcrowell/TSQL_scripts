# http://mikefrobbins.com/2014/09/11/creating-a-simplistic-gui-interface-with-out-gridview/
Invoke-Command -ComputerName (
    Get-Process |
    Out-GridView -OutputMode Multiple -Title 'Select Servers to Query:' |
    Select-Object -ExpandProperty DNSHostName
) -FilePath (
    Get-ChildItem -Path C:\users\gcrowell\*.xml |
    Out-GridView -OutputMode Single -Title 'Select PowerShell Script to Run:' |
    Select-Object -ExpandProperty FullName
) | Out-GridView -Title 'Results'