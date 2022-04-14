# Update based on your organizational requirements
$Location = 'westeurope'
$ResourceGroupName = 'RG-MSTechnics'
$logworkspace = 'mst-LogAnalytics'
$Storagesku = 'StandardSSD_LRS'
$VMSize = 'Standard_DS1_v2'
$disksize = '130'
$diskencryptionset = 'mst-diskenc-set-1'
$publicIP = 'Standard'

# Golden Image VM
$GIimage ='MicrosoftWindowsDesktop:Windows-10:19h1-ent-gensecond:18362.1198.2011031735'
$GINetworkSecurityGroup = 'NSG-GI'
$GIAvailabilitySet = 'MST-GoldenImage'
$GIAdminUsername = 'giAdmin'
$GIAdminPassword = 'giTestPass123'
$GIName = 'mst-GI'
$GIprivateIP = '10.10.10.11'

# Create a golden image availability set.
az vm availability-set create --name $AvailabilitySet --resource-group $ResourceGroupName --location $Location

# Create a virtual machine to be used as golden image.
az vm create --resource-group $ResourceGroupName --availability-set $GIAvailabilitySet --workspace $logworkspace --name $GIName --size $VMSize --storage-sku $Storagesku --image $GIimage --admin-username $GIAdminUsername --admin-password $GIAdminPassword --os-disk-encryption-set $diskencryptionset --os-disk-size-gb $disksize --nsg $GINetworkSecurityGroup --public-ip-sku $publicIP --private-ip-address $GIprivateIP