$resourcegroup = "RG-MSTechnics"
$hostpoolname = "mst-HostPool"
$workspace = "mst-Workspace" #maakt een nieuwe als de naam nog niet bestaat
$hptype = "pooled"
$loadbalancetype = "BreadthFirst"
$location = "westeurope"
$desktopGroup = "MSTechnics"
$objectid = "452620b5-650e-4628-9d58-0fe42038e221" #object ID van een azure group met users die toegang mogen krijgen tot avd

#Aanmaken hostpool
New-AzWvdHostPool -ResourceGroupName $resourcegroup -Name $hostpoolname -WorkspaceName $workspace -HostPoolType $hptype -LoadBalancerType $loadbalancetype -Location $location -DesktopAppGroupName $desktopGroup -PreferredAppGroupType 'Desktop'

#Add Azure Active Directory users to the desktop app group
New-AzRoleAssignment -ObjectId $objectid -RoleDefinitionName "Desktop Virtualization User" -ResourceName $desktopGroup -ResourceGroupName $resourcegroup -ResourceType 'Microsoft.DesktopVirtualization/applicationGroups'