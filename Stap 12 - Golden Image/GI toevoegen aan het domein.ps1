$User = "dcAdmin"
$PWord = ConvertTo-SecureString -String "dcTestPass123" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
Add-Computer -ComputerName mst-GI -DomainName mstechnics.be -OUPath "OU=AVD,OU=MSTechnics - Computers,OU=MSTechnics,DC=mstechnics,DC=be" -Credential $Credential -Restart -Force