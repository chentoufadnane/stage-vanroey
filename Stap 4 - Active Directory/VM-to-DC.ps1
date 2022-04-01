# Active Directory Domain Services installeren
install-windowsfeature AD-Domain-Services

ADD-WindowsFeature RSAT-Role-Tools

# Windows PowerShell script for AD DS Deployment
$password = 'demoTestPass123'

Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "demomarch.be" `
-DomainNetbiosName "demomarch" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-SafeModeAdministratorPassword (ConvertTo-secureString $password -AsPlainText -Force) -ChangePasswordAtLogon $False `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true