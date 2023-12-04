/*

Tip. 구독으로 범위 지정

targetScope = 'tenant'

param subscriptionID string

@description('create resources at subscription level')
module  'module.bicep' = {
  name: 'deployToSub'
  scope: subscription(subscriptionID)
}

Tip. 리소스 그룹으로 범위 지정

targetScope = 'tenant'

param resourceGroupName string
param subscriptionID string

@description('create resources at resource group level')
module  'module.bicep' = {
  name: 'deployToRG'
  scope: resourceGroup(subscriptionID, resourceGroupName)
}


*/

/*------------------------------------------------------------------------------------------------------------*/

targetScope = 'tenant'
param subscriptionID string = '611a7ed8-17fa-480a-901d-d7084803c376'

/*------------------------------------------------------------------------------------------------------------*/

@description('Name of key vault')
param utcValue string = utcNow()
param resourceName string = 'kv-${utcValue}'

@description('Object id of security group')
param securityGroupId string = 'cfa4eb1d-5a01-445a-84ad-1f198ebab44c'

@description('Name of virtual network')
param virtualNetworkName string

@description('Private IP Address')
param privateIpAddress string

@description('Location of resource groups and resources')
param location string = 'japaneast'

@description('Name of applications resource group')
param resourceGroup_application string = 'chanpu-application'

@description('Name of networks resource group')
param resourceGroup_networks string = 'chanpu-networks'

/*------------------------------------------------------------------------------------------------------------*/

@description('Module of key vault')
module keyVault 'modules/keyVault.bicep' = {
  scope: resourceGroup(subscriptionID, resourceGroup_application)
  name: 'keyVault.bicep'
  params: {
    keyVaultName: resourceName
    securityGroupId: securityGroupId
    location: location
  }
}

@description('Module of private endpoint for key vault')
module privateEndpoint 'modules/privateEndpoint.Bicep' = {
  scope: resourceGroup(subscriptionID, resourceGroup_networks)
  name: 'privateEndpoint.bicep'
  params: {
    location: location
    keyVaultId: keyVault.outputs.id
    resourceName: keyVault.outputs.name
    virtualNetworkName: virtualNetworkName
    privateIpAddress: privateIpAddress
  }
}
