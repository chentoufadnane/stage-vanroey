#Security Group aanmaken
New-ADGroup -Name "AVD User Access - MSTechnics" -GroupCategory Security -GroupScope Global -DisplayName "AVD User Access - MSTechnics" -Path "OU=MSTechnics - Security Groups,OU=MSTechnics,DC=mstechnics,DC=be" -Description "Groep met alle users die toegang moeten krijgen tot de session hosts"

#Users toevoegen aan de zojuist aangemaakte groep
Get-ADUser -SearchBase ‘OU=MSTechnics - Users,OU=MSTechnics,DC=mstechnics,DC=be’ -Filter * | ForEach-Object {Add-ADGroupMember -Identity ‘AVD User Access - MSTechnics’ -Members $_ }