This is a Powershell script that will extract all the binaries and PDBs from
MSIs and zip them up into a single archive.

Just copy the script and all the MSIs you want to get the DLLs from into the
same directory and run the .ps1 script with Powershell. The zip file will be
deposited into the same directory.

If Powershell won't run the script, run 'Set-ExecutionPolicy Unrestricted' in
the Powershell window and accept the change. This is a one-time operation.

The script will not run if you do not have Powershell 3.0. Powershell 2.0
comes with Windows 7 and you can (and should) download version 3.0 if the
script tells you to. Windows 8 comes with 3.0 so you should have no problems
there.
