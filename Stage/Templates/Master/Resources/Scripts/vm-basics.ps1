param(
    [string]$Script
)
Set-NetFirewallProfile -All -Enabled False

New-Item "C:\Temp" -ItemType Directory

$path = 'https://scriptsstoragevra.blob.core.windows.net/scripts/' + $Script
$outfile = 'C:\Temp\' + $Script

Invoke-WebRequest $path -OutFile $outfile

Invoke-WebRequest "https://aka.ms/fslogix/download" -OutFile "C:\Temp\fslogix.zip" 

New-Item "C:\FSLogix" -ItemType Directory
Expand-Archive -LiteralPath C:\Temp\fslogix.zip -DestinationPath C:\FSLogix\ 
& " C:\FSLogix\x64\Release\FSLogixAppsSetup.exe" /install /quiet /norestart