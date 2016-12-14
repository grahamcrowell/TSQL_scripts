# https://www.safaribooksonline.com/library/view/windows-powershell-cookbook/9780596528492/ch17s14.html

$dir = "C:\Users\gcrowell\_Vault_\Dev\release to test\DR9561 eCN dimension merge DSDW to CommunityMart\database\table"
Get-ChildItem $dir | Rename-Item -NewName { $_.Name -replace 'DSDW','CommunityMart' }

