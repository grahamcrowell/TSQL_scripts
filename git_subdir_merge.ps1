# https://saintgimp.org/2013/01/22/merging-two-git-repositories-into-one-repository-without-losing-file-history/

$repo_root = "C:\Users\user\Source\Repos"
Set-Location -Path $repo_root
# 
# 1. (setup) create new empty repo with placeholder/dumby commit
#
$new_repo = "DataWarehouseTesting"
New-Item -Name $new_repo -ItemType Directory
Set-Location -Path $new_repo
git init
dir > deleteme.txt
git add .
git commit -m “Initial dummy commit”

#
# 2. add repo into subdir of new repo (retain history)
#
# re-init variables
$repo_root="C:\Users\user\Source\Repos"
Set-Location -Path $repo_root
$new_repo="DataWarehouseTesting"
$new_repo_path="$repo_root\$new_repo"
$repo_folders='"'+((Get-ChildItem -Path $new_repo_path | Select Name).Name -join '","')+'"'
$repo_folders
# get subdir repo remote url
$remote_name="legacy_sql_test_scripts"
$sub_repo_path="$repo_root\SqlDataValidation"
Set-Location -Path $sub_repo_path
$remote_url=(git remote -v)[0].Split("`t")[1].Replace("(fetch)","").Trim()
$remote_url
Set-Location -Path "$new_repo_path"
# merge subdir into new_repo and cleanup
git remote add -f $remote_name $remote_url
git merge --allow-unrelated-histories "$remote_name/master"
if(Test-Path -Path ".\deleteme.txt")
{
    # clean up dumby file/commit
    git rm .\deleteme.txt
    git commit -m “Clean up initial file”
}
# move subdir repo files into subdir
New-Item -Name $remote_name -ItemType Directory
dir –exclude $repo_folders,"$remote_name" | %{git mv $_.Name $remote_name}
git commit -m “Move $remote_name files into subdir”

#
# repeat as for each subdir repo...
#

# re-init variables
$remote_name="etl_auto_test"
$remote_repo_name="AutoTest"
$repo_root="C:\Users\user\Source\Repos"
$new_repo="DataWarehouseTesting"

Set-Location -Path $repo_root
# get subdir repo remote url
$new_repo_path="$repo_root\$new_repo"
$repo_folders=New-Object System.Collections.ArrayList
[void]$repo_folders.AddRange([string[]](Get-ChildItem -Path $new_repo_path | Select Name).Name)
[void]$repo_folders.Add($remote_name)
$repo_folders
$sub_repo_path="$repo_root\$remote_repo_name"
Set-Location -Path $sub_repo_path
$remote_url=(git remote -v)[0].Split("`t")[1].Replace("(fetch)","").Trim()
$remote_url
Set-Location -Path "$new_repo_path"
# merge subdir into new_repo and cleanup
git remote add -f $remote_name $remote_url
git merge --allow-unrelated-histories "$remote_name/master"

# move subdir repo files into subdir
New-Item -Name $remote_name -ItemType Directory
dir –exclude $repo_folders | %{git mv $_.Name $remote_name}
git commit -m “Move $remote_repo_name files into $remote_name”

