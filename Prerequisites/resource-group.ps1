# Variables
$Location = 'westeurope'
$ResourceGroupName = 'RG-MSTechnics'
$WorkspaceName = 'mst-LogAnalytics'

# Create a resource group.
az group create --name $ResourceGroupName --location $Location

# Create the workspace
New-AzOperationalInsightsWorkspace -Location $Location -Name $WorkspaceName -Sku Standard -ResourceGroupName $ResourceGroup