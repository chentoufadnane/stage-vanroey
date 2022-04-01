$User = "demoAdmin"
$PWord = ConvertTo-SecureString -String "demoTestPass123" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
Add-Computer -ComputerName FS01 -DomainName scripttest.be -OUPath "OU=Servers,OU=VanRoey - Computers,OU=VanRoey,DC=demomarch,DC=be" -Credential $Credential -Restart -Force