$command = @'
cmd.exe /C ipconfig
'@
Invoke-Expression -Command:$command

$command = @'
cmd.exe /C netstat
'@
Invoke-Expression -Command:$command

$command = @'
cmd.exe /C ping www.google.com
'@
Invoke-Expression -Command:$command

$command = @'
cmd.exe /C tracert www.google.com
'@
Invoke-Expression -Command:$command

$command = @'
cmd.exe /C tracert www.google.com
'@
Invoke-Expression -Command:$command


$command = @'
cmd.exe /C pathping www.google.com
'@
Invoke-Expression -Command:$command

$command = @'
cmd.exe /C tracert www.google.com
'@
Invoke-Expression -Command:$command
