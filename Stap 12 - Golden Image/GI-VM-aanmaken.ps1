#Update based on your organizational requirements
$Location = 'westeurope'
$ResourceGroupName = 'RG-MSTechnics'
$image = 'MicrosoftWindowsDesktop:Windows-10:19h1-ent-gensecond:18362.1198.2011031735'
$NetworkSecurityGroup = 'NSG-GI'
$AvailabilitySet = 'MST-GoldenImage'
$Storagesku = 'StandardSSD_LRS'
$VMSize = 'Standard_DS1_v2'
$disksize = '130'
$diskencryptionset = 'mst-diskenc-set-1'
$AdminUsername = 'giAdmin'
$AdminPassword = 'giTestPass123'
$FileServer1 = 'mst-GI'
$privateIP = '10.10.10.13'
$publicIP = 'Standard'

# Create an availability set.
az vm availability-set create --name $AvailabilitySet --resource-group $ResourceGroupName --location $Location

# Create a virtual machine.
az vm create --resource-group $ResourceGroupName --availability-set $AvailabilitySet --name $FileServer1 --size $VMSize --storage-sku $Storagesku --image $image --admin-username $AdminUsername --admin-password $AdminPassword --os-disk-encryption-set $diskencryptionset --os-disk-size-gb $disksize --nsg $NetworkSecurityGroup --public-ip-sku $publicIP --private-ip-address $privateIP