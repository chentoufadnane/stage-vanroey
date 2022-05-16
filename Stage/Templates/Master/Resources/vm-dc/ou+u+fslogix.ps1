# Modules
Import-Module ActiveDirectory

# Variabelen
$DCName = "mstDC"
$DomainName = "mstechnics.be" #Define UPN
$OUfilepath = "C:\Temp\ou-file.csv" #csv bestand met ou's
$Usersfilepath = "C:\Temp\user-file.csv" #csv bestand met Users
$SecGroupName = "AVD User Access - MSTechnics" #Security Group Name
$SecGroupPath = "OU=MSTechnics - Security Groups,OU=MSTechnics,DC=mstechnics,DC=be" #Security Group Path
$DomainUsersPath = "OU=MSTechnics - Users,OU=MSTechnics,DC=mstechnics,DC=be" #Path where domain users are located
$DomainAdminsPath= "OU=MSTechnics - Administrators,OU=MSTechnics,DC=mstechnics,DC=be" #Path where domain admins are located

#OU's aanmaken

$csv = Import-csv -Path $OUfilepath -Delimiter ";"

foreach ($line in $csv)
{
    $name = $line.name
    $path = $line.path

    New-ADOrganizationalUnit -Name $name -Path $path
    Write-Host "The organizational unit $name is created." -ForegroundColor Green
}

# Users aanmaken
 
$ADUsers = Import-Csv $Usersfilepath -Delimiter ";"

foreach ($User in $ADUsers) {
    $username = $User.username
    $password = $User.password
    $firstname = $User.firstname
    $lastname = $User.lastname
    $initials = $User.initials
    $OU = $User.ou
    $city = $User.city
    $zipcode = $User.zipcode
    $country = $User.country
    $telephone = $User.telephone
    $jobtitle = $User.jobtitle
    $company = $User.company
    $department = $User.department

    if (Get-ADUser -F { SamAccountName -eq $username }) {
        Write-Warning "A user account with username $username already exists in Active Directory."
    }
    else {
        New-ADUser `
            -SamAccountName $username `
            -UserPrincipalName "$username@$DomainName" `
            -Name "$firstname $lastname" `
            -GivenName $firstname `
            -Surname $lastname `
            -Initials $initials `
            -Enabled $True `
            -DisplayName "$lastname, $firstname" `
            -Path $OU `
            -City $city `
            -PostalCode $zipcode `
            -Country $country `
            -Company $company `
            -OfficePhone $telephone `
            -Title $jobtitle `
            -Department $department `
            -AccountPassword (ConvertTo-secureString $password -AsPlainText -Force) -ChangePasswordAtLogon $False

        Write-Host "The user account $username is created." -ForegroundColor Cyan
    }
}

#Security Group aanmaken
New-ADGroup -Name $SecGroupName -GroupCategory Security -GroupScope Global -DisplayName $SecGroupName -Path $SecGroupPath -Description "Groep met alle users die toegang moeten krijgen tot de session hosts"

#Users toevoegen aan de zojuist aangemaakte groep
Get-ADUser -SearchBase $DomainUsersPath -Filter * | ForEach-Object {Add-ADGroupMember -Identity "AVD User Access - MSTechnics" -Members $_ }

#Users RDP toegang geven om later de golden image te kunnen testen
Get-ADUser -SearchBase $DomainUsersPath -Filter * | ForEach-Object {Add-ADGroupMember -Identity "Remote Desktop Users" -Members $_ }

#Administrators promoten naar Enterprise Admins
Get-ADUser -SearchBase $DomainAdminsPath -Filter * | ForEach-Object {Add-ADGroupMember -Identity "Enterprise Admins" -Members $_ }

#FSLogix installeren
Invoke-WebRequest "https://aka.ms/fslogix/download" -OutFile "C:\Temp\fslogix.zip" 

New-Item "C:\FSLogix" -ItemType Directory
New-Item "C:\FSLogix\Profiles" -ItemType Directory
Expand-Archive -LiteralPath C:\Temp\fslogix.zip -DestinationPath C:\FSLogix\ 

New-Item "\\$DomainName\SYSVOL\$DomainName\Policies\PolicyDefinitions" -ItemType Directory
New-Item "\\$DomainName\SYSVOL\$DomainName\Policies\PolicyDefinitions\en-US" -ItemType Directory

Copy-Item -Path "C:\FSLogix\fslogix.admx" -Destination "\\$DomainName\SYSVOL\$DomainName\Policies\PolicyDefinitions"
Copy-Item -Path "C:\FSLogix\fslogix.adml" -Destination "\\$DomainName\SYSVOL\$DomainName\Policies\PolicyDefinitions\en-US" 
& " C:\FSLogix\x64\Release\FSLogixAppsSetup.exe" /install /quiet /norestart 

Copy-item -Force -Recurse -Verbose 'C:\Windows\PolicyDefinitions\*' -Destination "\\$DCName\SYSVOL\$DomainName\Policies\PolicyDefinitions"
Copy-item -Force -Recurse -Verbose 'C:\Windows\PolicyDefinitions\en-US\*' -Destination "\\$DCName\SYSVOL\$DomainName\Policies\PolicyDefinitions\en-US"

Disable-ScheduledTask -TaskName "InstallingBasics"