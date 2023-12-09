targetScope = 'tenant'

/*------------------------------------------------------------------------------------------------------------*/
@description('Subscription ID of Core')
param subscriptionId_core string = '611a7ed8-17fa-480a-901d-d7084803c376'

@description('Subscription ID of Systems')
param subscriptionId_system string = '0b5f5005-c30c-4a28-89c1-9457d0cd5e0f'

@description('Name of key vault')
param utcValue string = utcNow()

param resourceName string = 'kv-${utcValue}'

@description('Object id of security group')
param securityGroupId string = '0b5f5005-c30c-4a28-89c1-9457d0cd5e0f'

@description('Name of virtual network')
param virtualNetworkName string = 'vnet-20231209T064814Z'

@description('Private IP Address')
param privateIpAddress string = '10.0.0.7'

@description('Location of resource groups and resources')
param location string = 'japaneast'

@description('Name of applications resource group')
param resourceGroup_application string = 'chanpu-application'

@description('Name of networks resource group')
param resourceGroup_networks string = 'chanpu-networks'

/*------------------------------------------------------------------------------------------------------------*/

@description('Module of key vault')
module keyVault 'modules/keyVault.bicep' = {
  scope: resourceGroup(subscriptionId_system, resourceGroup_application)
  name: 'keyVault.bicep'
  params: {
    keyVaultName: resourceName
    securityGroupId: securityGroupId
    location: location
  }
}

@description('Module of private endpoint for key vault')
module privateEndpoint 'modules/privateEndpoint.Bicep' = {
  scope: resourceGroup(subscriptionId_system, resourceGroup_networks)
  name: 'privateEndpoint.bicep'
  params: {
    location: location
    keyVaultId: keyVault.outputs.id
    resourceName: keyVault.outputs.name
    virtualNetworkName: virtualNetworkName
    privateIpAddress: privateIpAddress
  }
}
