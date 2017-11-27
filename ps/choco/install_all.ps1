Set-ExecutionPolicy Unrestricted -Force -Scope LocalMachine
Get-ExecutionPolicy

# install chocalately
# https://chocolatey.org/install

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco list --local-only

choco install powershell -y
# choco install visualstudiocode -y  

choco install googlechrome -y
choco install python -y
choco install jdk8 -y

choco install intellijidea-ultimate -y
choco install postgresql -y
choco install awscli -y
choco install 7zip.install -y
choco install vlc -y
choco list --local-only