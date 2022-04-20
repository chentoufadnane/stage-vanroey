New-Item "C:\Temp" -ItemType Directory

wget "https://aka.ms/fslogix/download" -OutFile "C:\Temp\fslogix.zip" 

New-Item "C:\FSLogix" -ItemType Directory
Expand-Archive -LiteralPath C:\Temp\fslogix.zip -DestinationPath C:\FSLogix\ 
& " C:\FSLogix\x64\Release\FSLogixAppsSetup.exe" /install /quiet /norestart 