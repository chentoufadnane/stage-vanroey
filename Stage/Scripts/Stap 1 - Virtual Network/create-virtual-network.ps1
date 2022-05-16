#Update based on your organizational requirements
$Location = 'westeurope'
$ResourceGroupName = 'RG-MSTechnics'

$VNetName = 'VNet-MSTechnics'
$VNetAddress = '10.10.0.0/16'
$SubnetName = 'Sub1-MSTechnics'
$SubnetAddress = '10.10.10.0/24'

# Create a network security group
az network nsg create --name $NetworkSecurityGroup --resource-group $ResourceGroupName --location $Location

# Create a network security group rule for port 3389.
az network nsg rule create --name PermitRDP --nsg-name $NetworkSecurityGroup --priority 1000 --resource-group $ResourceGroupName --access Allow --source-address-prefixes "*" --source-port-ranges "*" --direction Inbound --destination-port-ranges 3389

# Create a virtual network.
az network vnet create --name $VNetName --resource-group $ResourceGroupName --address-prefixes $VNetAddress --location $Location

# Create a subnet
az network vnet subnet create --address-prefix $SubnetAddress --name $SubnetName --resource-group $ResourceGroupName --vnet-name $VNetName --network-security-group $NetworkSecurityGroup