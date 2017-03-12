#Author: Ayo Ijidakinro
#Date: 09/01/2012

#Script-object Helper Methods
#load needed assemblies
[System.Reflection.Assembly]::Load("Microsoft.SqlServer.Management.Sdk.Sfc, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91, processorArchitecture=MSIL")

function Get-ScriptObjectCreate([Microsoft.SqlServer.Management.Smo.Server] $server_instance)
{
    return Get-ScriptObject "create" $server_instance
}

function Get-ScriptObjectDrop([Microsoft.SqlServer.Management.Smo.Server] $server_instance)
{
    return Get-ScriptObject "drop" $server_instance
}

function Get-ScriptObject([string]$scriptType, [Microsoft.SqlServer.Management.Smo.Server] $server_instance)
{   
    $scripter = new-object ('Microsoft.SqlServer.Management.Smo.Scripter') ($server_instance)
    
    if($scriptType -eq "drop")
    {
        $scripter.Options.ScriptDrops = $true
    }
    elseif($scriptType -eq "create")
    {
        $scripter.Options.ScriptDrops = $false
    }
    else
    {
        throw ("Unknown script type {0} encountered. Only drop and create are supported." -f $scriptType)
    }
    
    $scripter.Options.AnsiPadding = $true
    $scripter.Options.AppendToFile = $true
    $scripter.Options.ContinueScriptingOnError = $false
    $scripter.Options.IncludeIfNotExists = $true
    $scripter.Options.IncludeHeaders = $true
    $scripter.Options.SchemaQualify = $true
    $scripter.Options.ExtendedProperties = $true
    $scripter.Options.Permissions = $true
    $scripter.Options.AllowSystemObjects = $false
    $scripter.Options.DriAll = $true
    $scripter.Options.ToFileOnly = $true
    $scripter.Options.Indexes = $true
    $scripter.Options.Permissions = $true
    $scripter.Options.WithDependencies = $false
    $scripter.Options.SchemaQualifyForeignKeysReferences = $true
    $scripter.Options.NoCollation = $true
    $scripter.Options.DriAllConstraints = $true
    $scripter.Options.DriAllKeys = $true
    $scripter.Options.DriForeignKeys = $true
    $scripter.Options.DriIndexes = $true
    $scripter.Options.ClusteredIndexes = $true
    $scripter.Options.NonClusteredIndexes = $true
    
    return $scripter
}

#returns a method delegate of type Func<Boolean,Urn> that is accepted by a DependencyWalker
function Get-FilterCallbackFunction([string[]]$schemasToScript, [bool]$includeTables)
{    
    $callbackScriptBlock = 
        [System.Func[[System.Boolean],[Microsoft.SqlServer.Management.Sdk.Sfc.Urn]]] #create a filter callback delegate from this script block
        {
            param([Microsoft.SqlServer.Management.Sdk.Sfc.Urn]$urn)
            
            [Microsoft.SqlServer.Management.Smo.SqlSmoObject]$nodeSMOObject= $null
            
            if($urn -ne $null)
            {
                Write-Debug ("Examining object with urn: {0}" -f $urn)
                $nodeSMOObject = $server.GetSmoObject($urn)                
            }
            
            if(($nodeSMOObject -ne $null) -and ($schemasToScript -notcontains $nodeSMOObject.Schema)) #determine whether or not to script the object
            {                
                Write-Host ("Excluding object: {0}" -f $nodeSMOObject) -Foreground Yellow            
                return $true #filter it
            }
            else
            {
                Write-Host ("Object: {0}" -f $nodeSMOObject) -Foreground White
                if(($nodeSMOObject.GetType().Name -eq "Table") -and ($includeTables -eq $false)) #see if table filtering is on. If so remove all tables.
                {
                    Write-Host ("Exclude tables={0}. Excluding table: {1}" -f $includeTables, $nodeSMOObject) -Foreground Yellow
                    return $true #filter it
                }
                
                Write-Host ("Retaining object: {0}" -f $nodeSMOObject) -Foreground Green
                return $false #keep it                
            }
        }
}