$step=$args[0]
$step

$path = "C:\Program Files\R\R-3.2.4revised\bin\R.exe"
$parms = "C:\Users\gcrowell\Documents\GITHUB\FactFakeR\funk.R. script _.R"

$pclass = [wmiclass]'root\cimv2:Win32_Process'
$new_pid = $pclass.Create($path, '.', $null).ProcessId
$new_pid