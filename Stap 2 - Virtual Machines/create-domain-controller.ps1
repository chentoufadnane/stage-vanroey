# Update based on your organizational requirements
$Location = 'westeurope'
$ResourceGroupName = 'RG-MSTechnics'
$logworkspace = 'mst-LogAnalytics'
$Storagesku = 'StandardSSD_LRS'
$VMSize = 'Standard_DS1_v2'
$disksize = '130'
$diskencryptionset = 'mst-diskenc-set-1'
$VNetName = 'VNet-MSTechnics'
$publicIP = 'Standard'

# Domain Controller VM
$DCimage ='Win2019Datacenter'
$DCNetworkSecurityGroup = 'NSG-DomainControllers'
$DCAvailabilitySet = 'MST-DomainControllers'
$DCAdminUsername = 'dcAdmin'
$DCAdminPassword = 'dcTestPass123'
$DCName = 'mst-DC1'
$DCprivateIP = '10.10.10.11'

## Create the DC availability set.
az vm availability-set create --name $AvailabilitySet --resource-group $ResourceGroupName --location $Location

## Create a virtual machine to be used as DC.
az vm create --resource-group $ResourceGroupName --availability-set $DCAvailabilitySet --workspace $logworkspace --name $DCName --size $VMSize --storage-sku $Storagesku --image $DCimage --admin-username $DCAdminUsername --admin-password $DCAdminPassword --os-disk-encryption-set $diskencryptionset --os-disk-size-gb $disksize --nsg $DCNetworkSecurityGroup --public-ip-sku $publicIP --private-ip-address $DCprivateIP

## Set the VNet DNS server to the DC's private address
az network vnet update -g $ResourceGroupName -n $VNetName --dns-servers $DC1IP