@description('Key Vault에 적용할 태그')
param tags object = {}

@description('Key Vault Private link의 이름')
param keyVaultPlName string = 'kv-pl'

@description('Key Vault 접근 정책을 할당할 그룹ID')
param securityGroupId string = 'cfa4eb1d-5a01-445a-84ad-1f198ebab44c'

/*------------------------------------------------------------------------------------------------------------*/

@description('리소스를 배포할 Azure 지역')
param location string = resourceGroup().location

@description('Key Vault의 이름')
param deploymentTime string
var keyVaultName = 'kv-${uniqueString(deploymentTime)}'

@description('Private DNS Zone의 이름')
var privateDnsZoneName = 'privatelink.vaultcore.azure.net'

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
@description('Virtual Network 생성')
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'chanpu-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'Subnet-1'
        properties: {
          addressPrefix: '10.0.0.0/24'
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'Subnet-2'
        properties: {
          addressPrefix: '10.0.1.0/24'
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

/*------------------------------------------------------------------------------------------------------------*/
@description('Key Vault Private DNS Zone생성')
resource keyVaultPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
}

/*------------------------------------------------------------------------------------------------------------*/
@description('Private Endpoint생성 및 Key Vault와 링크 생성')
resource keyVaultPrivateEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: '${keyVault.name}-pep'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'vault'
          memberName: 'default'
          privateIPAddress: '10.0.0.10'
        }
      }
    ]
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
      id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetwork.name, 'Subnet-1')
    }
  }
}

/*------------------------------------------------------------------------------------------------------------*/
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
  name: virtualNetwork.name
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}
