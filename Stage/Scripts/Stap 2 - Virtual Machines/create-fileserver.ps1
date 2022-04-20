# Update based on your organizational requirements
$Location = 'westeurope'
$ResourceGroupName = 'RG-MSTechnics'
$logworkspace = 'mst-LogAnalytics'
$Storagesku = 'StandardSSD_LRS'
$VMSize = 'Standard_DS1_v2'
$disksize = '130'
$diskencryptionset = 'mst-diskenc-set-1'
$publicIP = 'Standard'

# Fileserver VM
$FSimage ='Win2019Datacenter'
$FSNetworkSecurityGroup = 'NSG-Fileservers'
$FSAvailabilitySet = 'MST-Fileservers'
$FSAdminUsername = 'fsAdmin'
$FSAdminPassword = 'fsTestPass123'
$FSName = 'mst-FS1'
$FSprivateIP = '10.10.10.11'

## Create the fileserver availability set.
az vm availability-set create --name $AvailabilitySet --resource-group $ResourceGroupName --location $Location

## Create a virtual machine to be used as fileserver.
az vm create --resource-group $ResourceGroupName --availability-set $FSAvailabilitySet --workspace $logworkspace --name $FSName --size $VMSize --storage-sku $Storagesku --image $FSimage --admin-username $FSAdminUsername --admin-password $FSAdminPassword --os-disk-encryption-set $diskencryptionset --os-disk-size-gb $disksize --nsg $FSNetworkSecurityGroup --public-ip-sku $publicIP --private-ip-address $FSprivateIP