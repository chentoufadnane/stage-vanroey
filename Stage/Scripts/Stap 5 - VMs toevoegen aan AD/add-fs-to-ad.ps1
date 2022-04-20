$FSName = 'mst-FS1'
$FSAdminUsername = 'fsAdmin'
$FSAdminPassword = ConvertTo-SecureString -String "fsTestPass123" -AsPlainText -Force
$domain = 'mstechnics.be'
$oupath = 'OU=Servers,OU=MSTechnics - Computers,OU=MSTechnics,DC=mstechnics,DC=be'

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $FSAdminUsername, $FSAdminPassword
Add-Computer -ComputerName $FSName -DomainName $domain -OUPath $oupath -Credential $Credential -Restart -Force