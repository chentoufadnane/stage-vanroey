$GIName = 'mstGI'
$GIAdminUsername = 'mstAdmin'
$GIAdminPassword = ConvertTo-SecureString -String "mstTempPass123" -AsPlainText -Force
$domain = 'mstechnics.be'
$oupath = 'OU=AVD,OU=MSTechnics - Computers,OU=MSTechnics,DC=mstechnics,DC=be'

Set-NetFirewallProfile -All -Enabled False

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $GIAdminUsername, $GIAdminPassword
Add-Computer -ComputerName $GIName -DomainName $domain -OUPath $oupath -Credential $Credential -Restart -Force