@description('리소스를 배포할 Azure 지역')
param location string = resourceGroup().location

@description('Key Vault에 적용할 태그')
param tags object = {}

@description('Key Vault의 이름')
param keyVaultName string

@description('Key Vault Private link의 이름')
param keyVaultPlName string

@description('Key Vault Private link가 생성될 서브넷ID')
param subnetId string

@description('Key Vault Private link가 생성될 가상 네트워크ID')
param virtualNetworkId string

@description('Key Vault 접근 정책을 할당할 그룹ID')
param securityGroupId string

var privateDnsZoneName = 'privatelink${environment().suffixes.keyvaultDns}'

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

@description('Key Vault Private DNS Zone생성')
resource keyVaultPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
}

@description('Private Endpoint생성 및 Key Vault와 링크 생성')
resource keyVaultPrivateEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: '${keyVault.name}-pep'
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: keyVaultPlName
        properties: {
          privateLinkServiceId: keyVault.id
          groupIds: [
            'vault'
          ]
        }
      }
    ]
    subnet: {
      id: subnetId
    }
  }
}

@description('Private Endpoint와 Private DNS Zone의 링크 생성')
resource privateEndpointDns 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-05-01' = {
  parent: keyVaultPrivateEndpoint
  name: 'vault-PrivateDnsZoneGroup'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: privateDnsZoneName
        properties: {
          privateDnsZoneId: keyVaultPrivateDnsZone.id
        }
      }
    ]
  }
}

@description('Private DNS Zone과 Virtual Network의 링크 생성')
resource keyVaultPrivateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: keyVaultPrivateDnsZone
  name: uniqueString(keyVault.id)
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworkId
    }
  }
}
