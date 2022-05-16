New-Item "C:\Temp" -ItemType Directory

#Bestanden installeren
Invoke-WebRequest "https://scriptsstoragevra.blob.core.windows.net/resources/ou-file.csv" -OutFile "C:\Temp\ou-file.csv"
Invoke-WebRequest "https://scriptsstoragevra.blob.core.windows.net/resources/user-file.csv" -OutFile "C:\Temp\user-file.csv"
Invoke-WebRequest "https://scriptsstoragevra.blob.core.windows.net/vm-dc/adds.ps1" -OutFile "C:\Temp\adds.ps1"
Invoke-WebRequest "https://scriptsstoragevra.blob.core.windows.net/vm-dc/ou+u+fslogix.ps1" -OutFile "C:\Temp\ou+u+fslogix.ps1"
Invoke-WebRequest "https://scriptsstoragevra.blob.core.windows.net/vm-dc/master.ps1" -OutFile "C:\Temp\master.ps1"