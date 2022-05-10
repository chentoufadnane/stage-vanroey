param location string = resourceGroup().location
param resourceGroupName string = resourceGroup().name
param tenantID string = 'a354cec5-4943-4a17-b194-0f7e6db8eb62'

param keyVaultSKU string = 'Standard'
param publicNetworkAccess string = 'Enabled'
param enableSoftDelete bool = true
param softDeleteRetentionInDays int = 90
param publicIpType string = 'Static'
param subnet1Prefix string = '10.22.10.0/24'
param addressPrefix array = [
  '10.22.0.0/16'
]
param networkAcls object = {
  defaultAction: 'allow'
  bypass: 'AzureServices'
}
param accessPolicies array = [
  {
    tenantId: 'a354cec5-4943-4a17-b194-0f7e6db8eb62'
    objectId: '876ea173-5564-4161-8728-35af3237af83'
    permissions: {
      keys: [
        'Get'
        'List'
        'Update'
        'Create'
        'Import'
        'Delete'
        'Recover'
        'Backup'
        'Restore'
        'GetRotationPolicy'
        'SetRotationPolicy'
        'Rotate'
        'Sign'
        'Verify'
        'WrapKey'
        'UnwrapKey'
        'Encrypt'
        'Decrypt'
        'Purge'
      ]
      secrets: [
        'Get'
        'List'
        'Set'
        'Delete'
        'Recover'
        'Backup'
        'Restore'
        'Purge'
      ]
      certificates: [
        'Get'
        'List'
        'Update'
        'Create'
        'Import'
        'Delete'
        'Recover'
        'Backup'
        'Restore'
        'Purge'
      ]
    }
  }
]

param platformFaultDomainCount int = 2
param platformUpdateDomainCount int = 5

param keyType string = 'RSA'
param keySize int = 2048

param adminNameDC string = 'armAdmin'
param adminPasswordDC string = 'armTestPass123'
param dcSize string = 'Standard_DS1_v2'
param imageDCPublisher string = 'MicrosoftWindowsServer'
param imageDCOffer string = 'WindowsServer'
param imageDCSku string = '2019-Datacenter'
param imageDCversion string = 'latest'

param adminNameFS string = 'armAdmin'
param adminPasswordFS string = 'armTestPass123'
param fsSize string = 'Standard_DS1_v2'
param imageFSPublisher string = 'MicrosoftWindowsServer'
param imageFSOffer string = 'WindowsServer'
param imageFSSku string = '2019-Datacenter'
param imageFSversion string = 'latest'

param adminNameGI string = 'armAdmin'
param adminPasswordDGI string = 'armTestPass123'
param giSize string = 'Standard_DS1_v2'
param imageGIPublisher string = 'MicrosoftWindowsServer'
param imageGIOffer string = 'WindowsServer'
param imageGISku string = '2019-Datacenter'
param imageGIversion string = 'latest'

param privateIpDC string = '10.22.10.10'
param privateIpTypeDC string = 'Static'

param privateIpFS string = '10.22.10.12'
param privateIpTypeFS string = 'Static'

param privateIpGI string = '10.22.10.14'
param privateIpTypeGI string = 'Static'

param osDiskType string = 'Windows'
param osDiskOption string = 'FromImage'
param osDiskCaching string = 'ReadWrite'
param osDiskDelete string = 'Detach'


var storageName = 'arm${uniqueString(resourceGroup().id)}'
var keyVaultName = '${resourceGroupName}-KeyVault'
var diskESName = '${resourceGroupName}-DiskEncSet'
var keyName = '${resourceGroupName}-KEY-${uniqueString(resourceGroup().id)}'

var NSGNameVNET = '${resourceGroupName}-NSG-VirtualNetwork' 
var virtualNetworkName = '${resourceGroupName}-VNET'
var subnet1Name = 'Sub1-${resourceGroupName}'

var DomainControllerName = '${resourceGroupName}-DC'
var availabilitySetNameDC = '${resourceGroupName}-DomainController'
var NSGNameDC = '${resourceGroupName}-NSG-DomainControllers'
var networkInterfaceDCName = '${DomainControllerName}-VMNic'
var publicIPAddressDCName = '${DomainControllerName}-PublicIP'
var ipConfigurationNameDC = '${DomainControllerName}-IpConfig'

var FileServerName = '${resourceGroupName}-FS'
var availabilitySetNameFS = '${resourceGroupName}-Fileserver'
var NSGNameFS = '${resourceGroupName}-NSG-Fileservers'
var networkInterfaceFSName = '${FileServerName}-VMNic'
var publicIPAddressFSName = '${FileServerName}-PublicIP'
var ipConfigurationNameFS = '${FileServerName}-IpConfig'

var GoldenImageName = '${resourceGroupName}-GI'
var availabilitySetNameGI = '${resourceGroupName}-GoldenImage'
var NSGNameGI = '${resourceGroupName}-NSG-GoldenImage'
var networkInterfaceGIName = '${GoldenImageName}-VMNic'
var publicIPAddressGIName = '${GoldenImageName}-PublicIP'
var ipConfigurationNameGI = '${GoldenImageName}-IpConfig'



resource storageAccount 'Microsoft.Storage/storageAccounts@2021-01-01' = {
  name: storageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: keyVaultSKU
    }
    tenantId: tenantID
    accessPolicies: accessPolicies
    publicNetworkAccess: publicNetworkAccess
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enableSoftDelete: enableSoftDelete
    softDeleteRetentionInDays: softDeleteRetentionInDays
    networkAcls: networkAcls
  }
  dependsOn: [
    storageAccount
  ]
}

resource key 'Microsoft.KeyVault/vaults/keys@2021-10-01' = {
  name: '${keyVaultName}/${keyName}'
  properties: {
    kty: keyType
    keySize: keySize
  }
  dependsOn: [
    keyVault
  ]
}

resource diskEncryptionSet 'Microsoft.Compute/diskEncryptionSets@2021-08-01' = {
  name: diskESName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties:{
    activeKey: {
      keyUrl: reference(resourceId('Microsoft.KeyVault/vaults/keys', keyVaultName, keyName)).keyUriWithVersion
      sourceVault:{
        id: resourceId('Microsoft.KeyVault/vaults',keyVaultName)
      }
    }
    encryptionType: 'EncryptionAtRestWithCustomerKey'
    rotationToLatestKeyVersionEnabled: true
  }
  dependsOn: [
    key
  ]
}
resource nsgDC 'Microsoft.Network/networkSecurityGroups@2021-05-01'= {
  name: NSGNameDC
  location: location
  properties: {
    securityRules: [
      {
        name: 'PermitRDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}
resource nsgFS 'Microsoft.Network/networkSecurityGroups@2021-05-01'= {
  name: NSGNameFS
  location: location
  properties: {
    securityRules: [
      {
        name: 'PermitRDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}
resource nsgGI 'Microsoft.Network/networkSecurityGroups@2021-05-01'= {
  name: NSGNameGI
  location: location
  properties: {
    securityRules: [
      {
        name: 'PermitRDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}
resource nsgVNET 'Microsoft.Network/networkSecurityGroups@2021-05-01'= {
  name: NSGNameVNET
  location: location
  properties: {
    securityRules: [
      {
        name: 'PermitRDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}
resource publicIpDC 'Microsoft.Network/publicIPAddresses@2021-05-01'= {
  name: publicIPAddressDCName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: publicIpType
  }
}
resource publicIpFS 'Microsoft.Network/publicIPAddresses@2021-05-01'= {
  name: publicIPAddressFSName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: publicIpType
  }
}
resource publicIpGI 'Microsoft.Network/publicIPAddresses@2021-05-01'= {
  name: publicIPAddressGIName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: publicIpType
  }
}
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01'= {
  name: virtualNetworkName
  location: location
  dependsOn: [
    nsgVNET
  ]
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefix
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1Prefix
          networkSecurityGroup: {
            id: resourceId('Microsoft.Network/networkSecurityGroups', NSGNameVNET)
          }
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    enableDdosProtection: false
  }
}
resource asDC 'Microsoft.Compute/availabilitySets@2021-11-01'= {
  name: availabilitySetNameDC
  location: location
  sku: {
    name: 'Aligned'
  }
  properties: {
    platformFaultDomainCount: platformFaultDomainCount
    platformUpdateDomainCount: platformUpdateDomainCount
    virtualMachines: [
    {
      id: DomainControllerName
    }
    ]
  }
}
resource asFS 'Microsoft.Compute/availabilitySets@2021-11-01'= {
  name: availabilitySetNameFS
  location: location
  sku: {
    name: 'Aligned'
  }
  properties: {
    platformFaultDomainCount: platformFaultDomainCount
    platformUpdateDomainCount: platformUpdateDomainCount
    virtualMachines: [
    {
      id: FileServerName
    }
    ]
  }
}
resource asGI 'Microsoft.Compute/availabilitySets@2021-11-01'= {
  name: availabilitySetNameGI
  location: location
  sku: {
    name: 'Aligned'
  }
  properties: {
    platformFaultDomainCount: platformFaultDomainCount
    platformUpdateDomainCount: platformUpdateDomainCount
    virtualMachines: [
    {
      id: GoldenImageName
    }
    ]
  }
}
resource DC 'Microsoft.Compute/virtualMachines@2021-11-01'= {
  name: DomainControllerName
  location: location
  dependsOn: [
    nsgDC
    asDC
  ]
  properties: {
    availabilitySet: {
      id: resourceId('Microsoft.Compute/availabilitySets', availabilitySetNameDC)
    }
    hardwareProfile: {
      vmSize: dcSize
    }
    storageProfile: {
      imageReference: {
        publisher: imageDCPublisher
        offer: imageDCOffer
        sku: imageDCSku
        version: imageDCversion
      }
      osDisk: {
        osType: osDiskType
        createOption: osDiskOption
        caching: osDiskCaching
        deleteOption: osDiskDelete
        managedDisk: {
          storageAccountType: osDiskType
          diskEncryptionSet: {
            id: resourceId('Microsoft.Compute/diskEncryptionSets', diskESName)
          }
        }
      }
    }
    osProfile: {
      computerName: DomainControllerName
      adminUsername: adminNameDC
      adminPassword: adminPasswordDC
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
      }
      allowExtensionOperations: true 
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: niDC.id
        }
      ]
    }
  }
}
resource FS 'Microsoft.Compute/virtualMachines@2021-11-01'= {
  name: FileServerName
  location: location
  dependsOn: [
    nsgFS
    asFS
  ]
  properties: {
    availabilitySet: {
      id: resourceId('Microsoft.Compute/availabilitySets', availabilitySetNameFS)
    }
    hardwareProfile: {
      vmSize: fsSize
    }
    storageProfile: {
      imageReference: {
        publisher: imageFSPublisher
        offer: imageFSOffer
        sku: imageFSSku
        version: imageFSversion
      }
      osDisk: {
        osType: osDiskType
        createOption: osDiskOption
        caching: osDiskCaching
        deleteOption: osDiskDelete
      }
    }
    osProfile: {
      computerName: FileServerName
      adminUsername: adminNameFS
      adminPassword: adminPasswordFS
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
      }
      allowExtensionOperations: true 
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: niFS.id
        }
      ]
    }
  }
}
resource GI 'Microsoft.Compute/virtualMachines@2021-11-01'= {
  name: GoldenImageName
  location: location
  dependsOn: [
    nsgGI
    asGI
  ]
  properties: {
    availabilitySet: {
      id: resourceId('Microsoft.Compute/availabilitySets', availabilitySetNameGI)
    }
    hardwareProfile: {
      vmSize: giSize
    }
    storageProfile: {
      imageReference: {
        publisher: imageGIPublisher
        offer: imageGIOffer
        sku: imageGISku
        version: imageGIversion
      }
      osDisk: {
        osType: osDiskType
        createOption: osDiskOption
        caching: osDiskCaching
        deleteOption: osDiskDelete
      }
    }
    osProfile: {
      computerName: DomainControllerName
      adminUsername: adminNameGI
      adminPassword: adminPasswordDGI
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
      }
      allowExtensionOperations: true 
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: niGI.id
        }
      ]
    }
  }
}
resource niDC 'Microsoft.Network/networkInterfaces@2021-05-01'= {
  name: networkInterfaceDCName
  location: location
  dependsOn: [
    vnet
    nsgDC
  ]
  properties: {
    ipConfigurations: [
      {
        name: ipConfigurationNameDC
        properties: {
          privateIPAddress: privateIpDC
          privateIPAllocationMethod: privateIpTypeDC
          publicIPAddress: {
            id: publicIpDC.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/VirtualNetworks/subnets', virtualNetworkName, subnet1Name)
          }
          primary: true
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', NSGNameDC)
    }
  }
}
resource niFS 'Microsoft.Network/networkInterfaces@2021-05-01'= {
  name: networkInterfaceFSName
  location: location
  dependsOn: [
    vnet
    nsgFS
  ]
  properties: {
    ipConfigurations: [
      {
        name: ipConfigurationNameFS
        properties: {
          privateIPAddress: privateIpFS
          privateIPAllocationMethod: privateIpTypeFS
          publicIPAddress: {
            id: publicIpFS.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/VirtualNetworks/subnets', virtualNetworkName, subnet1Name)
          }
          primary: true
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', NSGNameFS)
    }
  }
}
resource niGI 'Microsoft.Network/networkInterfaces@2021-05-01'= {
  name: networkInterfaceGIName
  location: location
  dependsOn: [
    vnet
    nsgGI
  ]
  properties: {
    ipConfigurations: [
      {
        name: ipConfigurationNameGI
        properties: {
          privateIPAddress: privateIpGI
          privateIPAllocationMethod: privateIpTypeGI
          publicIPAddress: {
            id: publicIpGI.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/VirtualNetworks/subnets', virtualNetworkName, subnet1Name)
          }
          primary: true
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', NSGNameGI)
    }
  }
}
