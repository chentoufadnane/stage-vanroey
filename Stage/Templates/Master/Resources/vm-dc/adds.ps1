param(
    [string]$DomainName,
	[string]$NetBios
)
# Active Directory Domain Services installeren
install-windowsfeature AD-Domain-Services

ADD-WindowsFeature RSAT-Role-Tools

# Windows PowerShell script for AD DS Deployment
$password = 'mstTempPass123'

Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName $DomainName `
-DomainNetbiosName $NetBios `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-SafeModeAdministratorPassword (ConvertTo-secureString $password -AsPlainText -Force) `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true