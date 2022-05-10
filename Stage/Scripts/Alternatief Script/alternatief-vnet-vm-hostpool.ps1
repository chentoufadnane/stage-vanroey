#Update based on your organizational requirements
$Location = 'westeurope'
$ResourceGroupName = 'RG-MSTechnics'
$logworkspace = 'mst-LogAnalytics'
$Storagesku = 'StandardSSD_LRS'
$VMSize = 'Standard_DS1_v2'
$disksize = '130'
$diskencryptionset = 'mst-diskenc-set-1'
$publicIP = 'Standard'

#Virtual Network variabelen
$VNetName = 'VNet-MSTechnics'
$VNetAddress = '10.10.0.0/16'
$SubnetName = 'Sub1-MSTechnics'
$SubnetAddress = '10.10.10.0/24'

# Domain Controller VM variabelen
$DCimage ='Win2019Datacenter'
$DCNetworkSecurityGroup = 'NSG-DomainControllers'
$DCAvailabilitySet = 'MST-DomainControllers'
$DCAdminUsername = 'dcAdmin'
$DCAdminPassword = 'dcTestPass123'
$DCName = 'mst-DC1'
$DCprivateIP = '10.10.10.11'

# Fileserver VM variabelen
$FSimage ='Win2019Datacenter'
$FSNetworkSecurityGroup = 'NSG-Fileservers'
$FSAvailabilitySet = 'MST-Fileservers'
$FSAdminUsername = 'fsAdmin'
$FSAdminPassword = 'fsTestPass123'
$FSName = 'mst-FS1'
$FSprivateIP = '10.10.10.11'

# Golden Image VM variabelen
$GIimage ='MicrosoftWindowsDesktop:Windows-10:19h1-ent-gensecond:18362.1198.2011031735'
$GINetworkSecurityGroup = 'NSG-GI'
$GIAvailabilitySet = 'MST-GoldenImage'
$GIAdminUsername = 'giAdmin'
$GIAdminPassword = 'giTestPass123'
$GIName = 'mst-GI'
$GIprivateIP = '10.10.10.11'

# Hostpool variabelen
$hostpoolname = "mst-HostPool"
$workspace = "mst-Workspace" #maakt een nieuwe als de naam nog niet bestaat
$hptype = "pooled"
$loadbalancetype = "BreadthFirst"
$desktopGroup = "MSTechnics"
$objectid = "452620b5-650e-4628-9d58-0fe42038e221" #object ID van een azure group met users die toegang mogen krijgen tot avd



####################################################################### Virtual Network ####################################################################################################

# Create a network security group
az network nsg create --name $NetworkSecurityGroup --resource-group $ResourceGroupName --location $Location

# Create a network security group rule for port 3389.
az network nsg rule create --name PermitRDP --nsg-name $NetworkSecurityGroup --priority 1000 --resource-group $ResourceGroupName --access Allow --source-address-prefixes "*" --source-port-ranges "*" --direction Inbound --destination-port-ranges 3389

# Create a virtual network.
az network vnet create --name $VNetName --resource-group $ResourceGroupName --address-prefixes $VNetAddress --location $Location

# Create a subnet
az network vnet subnet create --address-prefix $SubnetAddress --name $SubnetName --resource-group $ResourceGroupName --vnet-name $VNetName --network-security-group $NetworkSecurityGroup

###########################################################################################################################################################################################



####################################################################### Domain Controller VM ##############################################################################################

## Create the DC availability set.
az vm availability-set create --name $AvailabilitySet --resource-group $ResourceGroupName --location $Location

## Create a virtual machine to be used as DC.
az vm create --resource-group $ResourceGroupName --availability-set $DCAvailabilitySet --workspace $logworkspace --name $DCName --size $VMSize --storage-sku $Storagesku --image $DCimage --admin-username $DCAdminUsername --admin-password $DCAdminPassword --os-disk-encryption-set $diskencryptionset --os-disk-size-gb $disksize --nsg $DCNetworkSecurityGroup --public-ip-sku $publicIP --private-ip-address $DCprivateIP

## Set the VNet DNS server to the DC's private address
az network vnet update -g $ResourceGroupName -n $VNetName --dns-servers $DC1IP

###########################################################################################################################################################################################



####################################################################### Fileserver VM #####################################################################################################

## Create the fileserver availability set.
az vm availability-set create --name $AvailabilitySet --resource-group $ResourceGroupName --location $Location

## Create a virtual machine to be used as fileserver.
az vm create --resource-group $ResourceGroupName --availability-set $FSAvailabilitySet --workspace $logworkspace --name $FSName --size $VMSize --storage-sku $Storagesku --image $FSimage --admin-username $FSAdminUsername --admin-password $FSAdminPassword --os-disk-encryption-set $diskencryptionset --os-disk-size-gb $disksize --nsg $FSNetworkSecurityGroup --public-ip-sku $publicIP --private-ip-address $FSprivateIP

###########################################################################################################################################################################################



####################################################################### Golden Image VM ###################################################################################################
# Create a golden image availability set.
az vm availability-set create --name $AvailabilitySet --resource-group $ResourceGroupName --location $Location

# Create a virtual machine to be used as golden image.
az vm create --resource-group $ResourceGroupName --availability-set $GIAvailabilitySet --workspace $logworkspace --name $GIName --size $VMSize --storage-sku $Storagesku --image $GIimage --admin-username $GIAdminUsername --admin-password $GIAdminPassword --os-disk-encryption-set $diskencryptionset --os-disk-size-gb $disksize --nsg $GINetworkSecurityGroup --public-ip-sku $publicIP --private-ip-address $GIprivateIP

###########################################################################################################################################################################################



####################################################################### Hostpool ##########################################################################################################

#Aanmaken hostpool
New-AzWvdHostPool -ResourceGroupName $resourcegroup -Name $hostpoolname -WorkspaceName $workspace -HostPoolType $hptype -LoadBalancerType $loadbalancetype -Location $location -DesktopAppGroupName $desktopGroup -PreferredAppGroupType 'Desktop'

#Add Azure Active Directory users to the desktop app group
New-AzRoleAssignment -ObjectId $objectid -RoleDefinitionName "Virtual Machine User Login" -ResourceName $desktopGroup -ResourceGroupName $resourcegroup -ResourceType 'Microsoft.DesktopVirtualization/applicationGroups'

###########################################################################################################################################################################################
