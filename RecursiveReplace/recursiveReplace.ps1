$match = "..\\..\\CommonAssemblyInfo.cs"
$replace = "..\..\..\Build\CommonAssemblyInfo.cs"

$files = Get-ChildItem $(get-location) -include *.csproj -Recurse 

foreach($file in $files) 
{ 
    ((Get-Content $file.fullname) -creplace $match, $replace) | set-content $file.fullname 
}

read-host -prompt "Done! Press any key to close."