Set-Location C:\
Set-Alias grep findstr
Set-Alias ss select-string
Set-Alias less more
Set-Alias help get-help
Add-PSSnapin Microsoft.TeamFoundation.PowerShell

#Set environment variables for Visual Studio Command Prompt.
#This method uses a static text file with the output of vcvarsall.bat, which speeds startup time.
#This assumes regen-vc-vars has been run at least one time.
cat $env:userprofile/Documents/WindowsPowerShell\VCVars.txt |
foreach {
    $v = $_.split(“=”); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
}
write-host "Visual Studio 2013 Command Prompt variables set.`n" -ForegroundColor Yellow

#Custom prompt
function prompt
{
write-host "$env:username" -ForegroundColor Magenta -nonewline
write-Host "@" -ForegroundColor Green -nonewline
write-host "$([System.Net.Dns]::GetHostName()) [$(Get-Location)]$" -ForegroundColor Cyan -nonewline
return ' '
}

#Regenerates the VCVars.txt file in the user profile folder.
function regen-vc-vars
{
pushd "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC"
cmd /c 'vcvarsall.bat&set' | out-file $env:userprofile/Documents/WindowsPowerShell\VCVars.txt
popd
write-host "Successfully regenerated list of Visual Studio 2013 Command Prompt environment variables" -foregroundcolor green
}

#function grep ($input)
#{
#
#}
#function Bulk-File-Rename ($replace, $with)
#{
#	Dir | Rename-Item -NewName { $_.name -replace $replace $with }	
#}
