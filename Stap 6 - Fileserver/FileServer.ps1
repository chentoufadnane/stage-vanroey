#Update based on your organizational requirements
$Location = 'westeurope'
$ResourceGroupName = 'demomarch'
$NetworkSecurityGroup = 'NSG-Fileserver'
$AvailabilitySet = 'Fileservers'
$VMSize = 'Standard_DS1_v2'
$DataDiskSize = '40'
$AdminUsername = 'demoFSAdmin'
$AdminPassword = 'demoTestPass123'
$FileServer1 = 'demoFS'
$FSIP = '10.10.10.12'
$publicIP = 'Standard'

# Create an availability set.
az vm availability-set create --name $AvailabilitySet --resource-group $ResourceGroupName --location $Location

# Create a virtual machine.
az vm create --resource-group $ResourceGroupName --availability-set $AvailabilitySet --name $FileServer1 --size $VMSize --image Win2019Datacenter --admin-username $AdminUsername --admin-password $AdminPassword --data-disk-sizes-gb $DataDiskSize --data-disk-caching None --nsg $NetworkSecurityGroup --public-ip-sku $publicIP --private-ip-address $FSIP