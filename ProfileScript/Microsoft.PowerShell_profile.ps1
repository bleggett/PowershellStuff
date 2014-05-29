Set-Location C:\
Set-Alias grep findstr
Set-Alias ss select-string
Set-Alias less more
Set-Alias help get-help
Add-PSSnapin Microsoft.TeamFoundation.PowerShell

#Set environment variables for Visual Studio Command Prompt
pushd 'C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC'
cmd /c “vcvarsall.bat&set” |
foreach {
  if ($_ -match “=”) {
    $v = $_.split(“=”); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
  }
}
popd
write-host "Visual Studio 2013 Command Prompt variables set.`n" -ForegroundColor Yellow


function prompt
{
write-host "$env:username" -ForegroundColor Magenta -nonewline
write-Host "@" -ForegroundColor Green -nonewline
write-host "$([System.Net.Dns]::GetHostName()) [$(Get-Location)]$" -ForegroundColor Cyan -nonewline
return ' '
}

function grep ($input)
{

}
#function Bulk-File-Rename ($replace, $with)
#{
#	Dir | Rename-Item -NewName { $_.name -replace $replace $with }	
#}
