﻿$newPath="C:\ProgramData\Oracle\Java\javapath;%CSSCRIPT_DIR%\lib;%CSSCRIPT_DIR%;C:\Program Files (x86)\Intel\iCLS Client\;C:\Program Files\Intel\iCLS Client\;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;C:\Program Files (x86)\Microsoft Application Virtualization Client;C:\Program Files\Intel\Intel(R) Management Engine Components\DAL;C:\Program Files\Intel\Intel(R) Management Engine Components\IPT;C:\Program Files (x86)\Intel\Intel(R) Management Engine Components\DAL;C:\Program Files (x86)\Intel\Intel(R) Management Engine Components\IPT;C:\Program Files (x86)\Intel\OpenCL SDK\2.0\bin\x86;C:\Program Files (x86)\Intel\OpenCL SDK\2.0\bin\x64;C:\Program Files\Microsoft SQL Server\110\DTS\Binn\;C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Binn\;C:\Program Files\Microsoft SQL Server\110\Tools\Binn\;C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Binn\ManagementStudio\;C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\PrivateAssemblies\;C:\Program Files (x86)\Microsoft SQL Server\110\DTS\Binn\;C:\Program Files (x86)\PDFtk\bin\;C:\Program Files\nodejs\;C:\Program Files (x86)\Microsoft ASP.NET\ASP.NET Web Pages\v1.0\;C:\Program Files\Microsoft\Web Platform Installer\;C:\Program Files\Microsoft SQL Server\120\Tools\Binn\;C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\IDE\PrivateAssemblies\;C:\Program Files (x86)\Windows Kits\8.1\Windows Performance Toolkit\;C:\Program Files (x86)\Microsoft SDKs\TypeScript\1.0\;C:\Program Files (x86)\Microsoft SDKs\Azure\CLI\wbin;C:\Program Files (x86)\MiKTeX 2.9\miktex\bin\;C:\Program Files\Microsoft SQL Server\130\Tools\Binn\;C:\Program Files\Git\cmd;C:\Program Files (x86)\Microsoft SQL Server\130\DTS\Binn\;C:\Program Files (x86)\Microsoft SQL Server\120\DTS\Binn\;C:\Program Files (x86)\nodejs\;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;%systemroot%\System32\WindowsPowerShell\v1.0\;"


[Environment]::SetEnvironmentVariable("Path", $newPath, [EnvironmentVariableTarget]::Machine)