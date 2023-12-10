// Parameters
@description('Key Vault에 적용할 태그')
param tags object = {}

@description('Resource Group의 지역')
param location string = resourceGroup().location

@description('Key Vault의 이름')
param keyVaultName string

@description('Key Vault 접근 정책을 할당할 그룹ID')
param securityGroupId string

/*------------------------------------------------------------------------------------------------------------*/

@description('Azure Key Vault')
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  tags: tags
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: securityGroupId
        permissions: {
          keys: [
            'get'
            'list'
            'update'
            'create'
            'import'
            'delete'
            'recover'
            'backup'
            'restore'
          ]
          secrets: [
            'all'
          ]
          certificates: [
            'all'
          ]
        }
      }
    ]
    publicNetworkAccess: 'disabled'
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}

/*------------------------------------------------------------------------------------------------------------*/
@description('main.bicep에서 사용할 Key Vault의 이름')
output name string = keyVault.name

@description('main.bicep에서 사용할 Key Vault의 ID')
output id string = keyVault.id
