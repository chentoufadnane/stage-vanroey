$DomainName = "mstechnics.be"
$NetBios = "mstechnics"

#Scheduledtasks
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument 'C:\Temp\ou+u+fslogix.ps1'
$trigger = New-JobTrigger -AtLogOn -RandomDelay 00:00:10
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "InstallingBasics" -Description "Installs OUs, users and FSLogix"

&"C:\Temp\adds.ps1" -DomainName $DomainName -NetBios $NetBios