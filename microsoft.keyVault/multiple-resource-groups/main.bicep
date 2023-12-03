/*------------------------------------------------------------------------------------------------------------*/
targetScope = 'subscription'

/*------------------------------------------------------------------------------------------------------------*/
@description('Name of key vault')
param keyVaultName string = 'ChanpuVault01'

@description('Object id of security group')
param securityGroupId string = 'cfa4eb1d-5a01-445a-84ad-1f198ebab44c'

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
    keyVaultName: keyVaultName
    securityGroupId: securityGroupId
    location: applicationsResourceGroup.location
  }
}
