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

targetScope = 'subscription'

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

/*------------------------------------------------------------------------------------------------------------*/

@description('Existing resource group of applications')
resource applicationsResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: 'chanpu-applications'
}

@description('Existing resource group of network resources')
resource networksResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: 'chanpu-networks'
}

/*------------------------------------------------------------------------------------------------------------*/

@description('Module of key vault')
module keyVault 'modules/keyVault.bicep' = {
  scope: applicationsResourceGroup
  name: 'keyVault.bicep'
  params: {
    keyVaultName: resourceName
    securityGroupId: securityGroupId
    location: applicationsResourceGroup.location
  }
}

@description('Module of private endpoint for key vault')
module privateEndpoint 'modules/privateEndpoint.Bicep' = {
  scope: networksResourceGroup
  name: 'privateEndpoint.bicep'
  params: {
    location: networksResourceGroup.location
    keyVaultId: keyVault.outputs.id
    resourceName: keyVault.outputs.name
    virtualNetworkName: virtualNetworkName
    privateIpAddress: privateIpAddress
  }
}
