# This script is used for creating bulk organizational units.

# Import active directory module for running AD cmdlets
Import-Module activedirectory

#Store the data from the CSV in the $ADOU variable. 
$filepath = "C:\Temp\ou-file.csv"
$csv = Import-csv -Path $filepath -Delimiter ‘;’ 

#Loop through each row containing user details in the CSV file

foreach ($line in $csv)
{
#Read data from each field in each row and assign the data to a variable as below

    $name = $line.name
    $path = $line.path

#Account will be created in the OU provided by the $OU variable read from the CSV file
    New-ADOrganizationalUnit -Name $name -Path $path
}