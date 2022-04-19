# Active Directory Domain Services installeren
install-windowsfeature AD-Domain-Services

ADD-WindowsFeature RSAT-Role-Tools

# Windows PowerShell script for AD DS Deployment
$password = 'armTestPass123'

Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "arm-adnane.be" `
-DomainNetbiosName "armadnane" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-SafeModeAdministratorPassword (ConvertTo-secureString $password -AsPlainText -Force) `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
