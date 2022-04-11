#Update based on your organizational requirements
$Location = 'westeurope'
$ResourceGroupName = 'RG-MSTechnics'
$image = 'Win2019Datacenter'
$NetworkSecurityGroup = 'NSG-Fileservers'
$AvailabilitySet = 'MST-Fileservers'
$Storagesku = 'StandardSSD_LRS'
$VMSize = 'Standard_DS1_v2'
$disksize = '130'
$diskencryptionset = 'mst-diskenc-set-1'
$AdminUsername = 'fsAdmin'
$AdminPassword = 'fsTestPass123'
$VMName = 'mst-FS1'
$privateIP = '10.10.10.12'
$publicIP = 'Standard'

# Create an availability set.
az vm availability-set create --name $AvailabilitySet --resource-group $ResourceGroupName --location $Location

# Create a virtual machine.
az vm create --resource-group $ResourceGroupName --availability-set $AvailabilitySet --name $VMName --size $VMSize --storage-sku $Storagesku --image $image --admin-username $AdminUsername --admin-password $AdminPassword --os-disk-encryption-set $diskencryptionset --os-disk-size-gb $disksize --nsg $NetworkSecurityGroup --public-ip-sku $publicIP --private-ip-address $privateIP