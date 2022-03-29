$domain = "scripttest.be"

wget "https://aka.ms/fslogix/download" -OutFile "C:\Downloads\fslogix.zip" 

New-Item "C:\FSLogix" -ItemType Directory
Expand-Archive -LiteralPath C:\Downloads\fslogix.zip -DestinationPath C:\FSLogix\ 


New-Item "\\$domain\SYSVOL\$domain\Policies\PolicyDefinitions" -ItemType Directory
New-Item "\\$domain\SYSVOL\$domain\Policies\PolicyDefinitions\en-US" -ItemType Directory

Copy-Item -Path "C:\FSLogix\fslogix.admx" -Destination "\\$domain\SYSVOL\$domain\Policies\PolicyDefinitions"
Copy-Item -Path "C:\FSLogix\fslogix.adml" -Destination "\\$domain\SYSVOL\$domain\Policies\PolicyDefinitions\en-US" 
& " C:\FSLogix\x64\Release\FSLogixAppsSetup.exe" /install /quiet /norestart 