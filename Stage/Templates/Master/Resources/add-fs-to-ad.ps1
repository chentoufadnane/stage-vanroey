$FSName = 'mstFS'
$FSAdminUsername = 'mstAdmin'
$FSAdminPassword = ConvertTo-SecureString -String "mstTempPass123" -AsPlainText -Force
$domain = 'mstechnics.be'
$oupath = 'OU=Servers,OU=MSTechnics - Computers,OU=MSTechnics,DC=mstechnics,DC=be'

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $FSAdminUsername, $FSAdminPassword
Add-Computer -ComputerName $FSName -DomainName $domain -OUPath $oupath -Credential $Credential -Restart -Force
