$AvailabilitySet = 'MST-SessionHosts'
$ResourceGroupName = 'RG-MSTechnics'
$Location = 'westeurope'

az vm availability-set create --name $AvailabilitySet --resource-group $ResourceGroupName --location $Location