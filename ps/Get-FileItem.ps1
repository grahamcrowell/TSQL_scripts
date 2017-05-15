# https://www.petri.com/wp-content/uploads/Get-FileItem.txt
#requires -version 2.0

<#
 -----------------------------------------------------------------------------
 Script: Get-FileItem.ps1
 Version: 0.9.1
 Author: Jeffery Hicks
    http://jdhitsolutions.com/blog
    http://twitter.com/JeffHicks
    http://www.ScriptingGeek.com
 Date: 6/25/2012
 Keywords: A PowerShell version of the WHERE command line tool
 Comments:

 "Those who forget to script are doomed to repeat their work."

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************
 -----------------------------------------------------------------------------
 #>
 
Function Get-FileItem {

<#
.SYNOPSIS
A PowerShell version of the Where command
.DESCRIPTION
This is an enhanced, PowerShell version of the WHERE command from the traditional 
CLI which will find files in %PATH% that match a particular pattern.
.PARAMETER Pattern
The name of the file to find. Separate multiple entries with a comma. 
Wildcards are allowed. You can also specify a regular expression pattern 
by including the -REGEX parameter.
.PARAMETER Regex
Indicates that the pattern is a regular expression.
.PARAMETER Path
The folders to search other than %PATH%.
.PARAMETER Recurse
Used with -Path to indicate a recursive search.
.PARAMETER Full
Write the full file object to the pipeline. The default is just the full name.
.PARAMETER Quiet
Returns True if a match is made. This parameter will override -Full.
.PARAMETER First
Stop searching after the pattern is found. Don't search any more paths. 
.EXAMPLE
PS C:\> Get-Fileitem notepad.exe
C:\Windows\system32\notepad.exe
C:\Windows\notepad.exe

Find notepad.exe in  %path% and return the full file name. This is the default
behavior.
.EXAMPLE
PS C:\> PSWhere calculator.exe -quiet
False

Search for calculator.exe and return $True if found. This commmand is using
the PSWhere alias.
.EXAMPLE
PS C:\> pswhere "^\d+\S+\.txt" -Regex -path c:\scripts -full

           Directory: C:\scripts


Mode                LastWriteTime     Length Name
----                -------------     ------ ----
-a---         12/5/2007   2:19 PM      30146 1000FemaleNames.txt
-a---         12/5/2007   2:19 PM      29618 1000MaleNames.txt
-a---          6/2/2010  11:02 AM      31206 1000names.txt
-a---          6/3/2010   8:52 AM       3154 100names.txt
-a---         4/13/2012  10:27 AM       3781 13ScriptBlocks-v2.txt
-a---         8/13/2010  10:41 AM       3958 13ScriptBlocks.txt
-a---          2/7/2011   1:37 PM      78542 2500names.txt
-a---          2/8/2011   9:43 AM     157396 5000names.txt

Find all TXT files in C:\Scripts that start with a number and display full file information.
.NOTES
NAME        :  Get-FileItem
VERSION     :  0.9   
LAST UPDATED:  6/25/2012
AUTHOR      :  Jeffery Hicks (http://jdhitsolutions.com/blog)
.LINK
Get-ChildItem
Where.exe 
.INPUTS
Strings
.OUTPUTS
String, Boolean or File
#>

[cmdletbinding(DefaultParameterSetName="Default")]

Param(
[parameter(position=0,mandatory=$True,
HelpMessage="Enter a filename or pattern to search for")]
[ValidateNotNullorEmpty()]
[string[]]$Pattern,
[switch]$Regex,
[Parameter(ParameterSetName="Path")]
[string[]]$Path,
[Parameter(ParameterSetName="Path")]
[switch]$Recurse,
[switch]$Full,
[switch]$Quiet,
[switch]$First
)

<#
 The Resolve-EnvVariable function is used by Get-FileItem to resolve 
 any paths that might contain environmental names like %WINDIR% or
 %USERNAME%
#>

Function Resolve-EnvVariable {

[cmdletbinding()]
Param(
[Parameter(Position=0,Mandatory=$True,
HelpMessage="Enter a string that contains an environmental variable like %WINDIR%")]
[ValidatePattern("%\S+%")]
[string]$String
)

Write-Verbose "Starting $($myinvocation.mycommand)"
Write-Verbose "Resolving environmental variables in $String"
[environment]::ExpandEnvironmentVariables($string)
Write-Verbose "Ending $($myinvocation.mycommand)"
} #end Resolve-EnvVariable function
##########################################################################

#This is the main part of Get-FileItem
Write-Verbose "Starting $($myinvocation.MyCommand)"
Write-Verbose "Searching for $pattern"
Write-Verbose "Quiet mode is $Quiet"
Write-Verbose "Full mode is $Full"

if ($path) {
    #use specified path or array of paths
    $paths=$path
}
else {
    #split %PATH% and weed out any potential duplicates
    $paths=$env:path.Split(";") | Select -Unique
}

#define a variable to hold results
$results=@()

#foreach path search for the pattern
foreach ($path in $paths) {
    #if path has an environmental variable, resolve it first
    if ($path.Contains("%")) {
        Write-Verbose "Resolving environmental variables found in the path"
        $path=Resolve-EnvVariable -string $path
    }

    Write-Verbose "Searching $path"

    #search for each pattern
    foreach ($p in $pattern) {
        $cmd="Get-ChildItem -Path '$path'"
        Write-Verbose "...for $p"
        #is recurse called?
        if ($recurse) {
            $cmd+=" -recurse"
        }
        if ($regex) {
            Write-Verbose "...as regex"
            $cmd+=" | Where {`$_.name -match '$p'}"
        }
        else {
            $cmd+=" -filter $p"
        }
        #save results to a variable
        Write-Verbose $cmd
        $results+=Invoke-Expression $cmd
    }
        #stop after first match if specific
        if (($results|measure).count -gt 0 -AND $First) {
         Write-Verbose "First match found in $path. Breaking."
         <#
           I want to use the Break keyword here because I
           don't want to continue this part of the pipeline.
         #>    
         Break
        }
} #foreach

$count=($results|measure).count
write-verbose "Found $count matches"

If (($count -gt 0) -And $Quiet) {
    #if Quiet and results found write $True
    $True
}
elseif (($count -eq 0) -And $Quiet) {
    $False
    }
elseif (($count -gt 0) -AND $Full) {
    #if results found and write file results
    $results 
}
Else {
    #else just write full name
    $results | Select -expandproperty Fullname
}

Write-Verbose "Ending $($myinvocation.MyCommand)"

} #end function

Set-Alias -Name PSWhere -Value Get-FileItem