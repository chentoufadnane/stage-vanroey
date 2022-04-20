$domain = "mstechnics.be"

New-Item "C:\Temp" -ItemType Directory

wget "https://aka.ms/fslogix/download" -OutFile "C:\Temp\fslogix.zip" 

New-Item "C:\FSLogix" -ItemType Directory
Expand-Archive -LiteralPath C:\Temp\fslogix.zip -DestinationPath C:\FSLogix\ 

New-Item "\\$domain\SYSVOL\$domain\Policies\PolicyDefinitions" -ItemType Directory
New-Item "\\$domain\SYSVOL\$domain\Policies\PolicyDefinitions\en-US" -ItemType Directory

Copy-Item -Path "C:\FSLogix\fslogix.admx" -Destination "\\$domain\SYSVOL\$domain\Policies\PolicyDefinitions"
Copy-Item -Path "C:\FSLogix\fslogix.adml" -Destination "\\$domain\SYSVOL\$domain\Policies\PolicyDefinitions\en-US" 
& " C:\FSLogix\x64\Release\FSLogixAppsSetup.exe" /install /quiet /norestart 

Copy-item -Force -Recurse -Verbose 'C:\Windows\PolicyDefinitions\*' -Destination '\\mst-DC1\SYSVOL\mstechnics.be\Policies\PolicyDefinitions'
Copy-item -Force -Recurse -Verbose 'C:\Windows\PolicyDefinitions\en-US\*' -Destination '\\mst-DC1\SYSVOL\mstechnics.be\Policies\PolicyDefinitions\en-US'