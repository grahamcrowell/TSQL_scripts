$ProjectParentPath="C:\Users\gcrowell\Source\Repos\GenericProfiles"
$ProjectName="GenericProfilesWeb"
$AppName="SqlProfiles"
$ProjectRootPath=Join-Path -Path $ProjectParentPath -ChildPath $ProjectName
$AppPath=Join-Path -Path $ProjectRootPath -ChildPath $AppName

Set-Location -Path $ProjectParentPath

django-admin startproject $ProjectName

Set-Location -Path $ProjectRootPath
python manage.py startapp $AppName
Set-Location -Path $AppPath


Set-Location -Path $ProjectRootPath
python manage.py runserver