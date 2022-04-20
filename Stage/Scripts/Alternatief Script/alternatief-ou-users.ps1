# Modules
Import-Module ActiveDirectory

# Variabelen
$OUfilepath = "C:\Temp\ou-file.csv" #csv bestand met ou's
$Usersfilepath = "C:\Temp\user-file.csv" #csv bestand met Users
$UPN = "mstechnics.be" #Define UPN
$SecGroupName = "AVD User Access - MSTechnics" #Security Group Name
$SecGroupPath = "OU=MSTechnics - Security Groups,OU=MSTechnics,DC=mstechnics,DC=be" #Security Group Path
$DomainUsersPath = "OU=MSTechnics - Users,OU=MSTechnics,DC=mstechnics,DC=be" #Path where domain users are located
$DomainAdminsPath= "OU=MSTechnics - Administrators,OU=MSTechnics,DC=mstechnics,DC=be" #Path where domain admins are located

##################################################################################################################################################################



####################################################################### OU's aanmaken ###########################################################################

#Store the data from the CSV in the $ADOU variable. 
$csv = Import-csv -Path $OUfilepath -Delimiter ";"

#Loop through each row containing user details in the CSV file

foreach ($line in $csv)
{
#Read data from each field in each row and assign the data to a variable as below

    $name = $line.name
    $path = $line.path

#Account will be created in the OU provided by the $OU variable read from the CSV file
    New-ADOrganizationalUnit -Name $name -Path $path
}

#################################################################################################################################################################



####################################################################### Users aanmaken ##########################################################################
 
# Store the data from NewUsersFinal.csv in the $ADUsers variable
$ADUsers = Import-Csv $Usersfilepath -Delimiter ";"

# Loop through each row containing user details in the CSV file
foreach ($User in $ADUsers) {

    #Read user data from each field in each row and assign the data to a variable as below
    $username = $User.username
    $password = $User.password
    $firstname = $User.firstname
    $lastname = $User.lastname
    $initials = $User.initials
    $OU = $User.ou #This field refers to the OU the user account is to be created in
    $city = $User.city
    $zipcode = $User.zipcode
    $country = $User.country
    $telephone = $User.telephone
    $jobtitle = $User.jobtitle
    $company = $User.company
    $department = $User.department

    # Check to see if the user already exists in AD
    if (Get-ADUser -F { SamAccountName -eq $username }) {
        
        # If user does exist, give a warning
        Write-Warning "A user account with username $username already exists in Active Directory."
    }
    else {

        # User does not exist then proceed to create the new user account
        # Account will be created in the OU provided by the $OU variable read from the CSV file
        New-ADUser `
            -SamAccountName $username `
            -UserPrincipalName "$username@$UPN" `
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

        # If user is created, show message.
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