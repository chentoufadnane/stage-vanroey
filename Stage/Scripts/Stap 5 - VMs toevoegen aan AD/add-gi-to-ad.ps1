$GIName = 'mst-GI'
$GIAdminUsername = 'giAdmin'
$GIAdminPassword = ConvertTo-SecureString -String "giTestPass123" -AsPlainText -Force
$domain = 'mstechnics.be'
$oupath = 'OU=Servers,OU=MSTechnics - Computers,OU=MSTechnics,DC=mstechnics,DC=be'

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $GIAdminUsername, $GIAdminPassword
Add-Computer -ComputerName $GIName -DomainName $domain -OUPath $oupath -Credential $Credential -Restart -Force