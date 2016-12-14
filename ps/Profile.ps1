# http://www.howtogeek.com/50236/customizing-your-powershell-profile/

if((Test-Path $profile) -eq $false)
{
    New-Item -path $profile -type file –force
}
