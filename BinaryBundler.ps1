# The following script extracts all files from all MSIs in the current directory
# and puts them all into a zip file in the current directory.

$msiOutDir = (Get-Location).Path + "\Out";
$zipDir = $msiOutDir + "\Zip";
$zipFileName = (Get-Location).Path + "\Binaries.zip";
$msiexecPath = (Get-Command msiexec).Path;
$msiList = Get-ChildItem (Get-Location).Path -filter *.msi;

$includeExts = @("*.exe", "*.dll", "*.pdb", "*.map");

#Functions

#Uses zip libraries from .Net 3.5+ to compress files in a provided directory.
function ZipFiles( $zipfilename, $sourcedir )
{
   $result = [Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem")
   $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
   $result = [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir,
        $zipfilename, $compressionLevel, $false)
}

#Assembly loading might fail if you're using an old version of Powershell.
if((Get-Host).Version -eq "2.0")
{
    write-host "You are running version 2.0 of Powershell. This version is outdated. Please install Powershell 3.0" -ForegroundColor Red;
    exit;
}

if(!$msiList)
{
    write-host "Did not find any MSIs in the current directory. Please copy the MSIs to the same directory you run the script from." -ForegroundColor Red;
    exit;
}

if (!$msiexecPath)
{
    write-Host "Could not find msiexec.exe! Check that it is in your system path." -ForegroundColor Red;
    exit;
}

#Clean up the output directory and zip file if left over from previous run
if (Test-Path -path $msiOutDir)
{
    Remove-Item -Recurse -Force $msiOutDir;
}

if (Test-Path -path $zipFileName)
{
    Remove-Item -Recurse -Force $zipFileName;
}

#create the directory to which we will copy the files to be zipped.
$result = New-Item $zipDir -Type Directory -Force;

#extract the MSIs to the same location
ForEach ($msi in $msiList)
{
    write-Host "Extracting $($msi.Name)..." -ForegroundColor Green;
    
    $process = (Start-Process `
                    -FilePath $msiexecPath `
                    -ArgumentList " /a $($msi.Name) /qn TARGETDIR=`"${msiOutDir}`"" `
                    -Wait `
                    -Passthru)

    if($process.ExitCode -ne 0)
    {
        write-Host "Error extracting $($msi.Name)!" -ForegroundColor Red;
    }
}

#filter the files produced by the MSIs and copy the ones we want to the zip dir.
$includeFiles = Get-ChildItem "$msiOutDir" -Recurse -Include $includeExts;

ForEach ($file in $includeFiles)
{
    Copy-Item $file -Destination $zipDir -Force;
}

write-Host "Creating $zipFileName..." -ForegroundColor Green;

#zip the files in the zip dir.
ZipFiles $zipFileName $zipDir;

#remove the output dir as it is no longer needed.
Remove-Item -Recurse -Force $msiOutDir;

write-Host "Done!" -ForegroundColor Green;

#script end
