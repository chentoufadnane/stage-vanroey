# Active Directory Domain Services installeren
install-windowsfeature AD-Domain-Services

ADD-WindowsFeature RSAT-Role-Tools

# Windows PowerShell script for AD DS Deployment
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "scripttest.be" `
-DomainNetbiosName "SCRIPTTEST" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-SafeModeAdministratorPassword "myTestPass123"
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true