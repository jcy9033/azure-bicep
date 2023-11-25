param vaults_chanpu_kv_1_name string = 'chanpu-kv-1'

resource vaults_chanpu_kv_1_name_resource 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: vaults_chanpu_kv_1_name
  location: 'japaneast'
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: 'e25d89fa-cf6f-41ea-ad14-451e723f2900'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
    accessPolicies: []
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: false
    vaultUri: 'https://${vaults_chanpu_kv_1_name}.vault.azure.net/'
    provisioningState: 'Succeeded'
    publicNetworkAccess: 'Disabled'
  }
}

resource vaults_chanpu_kv_1_name_vaults_chanpu_kv_1_name_pep_10442308_5b02_4d51_8b69_669e8bcf8051 'Microsoft.KeyVault/vaults/privateEndpointConnections@2023-07-01' = {
  parent: vaults_chanpu_kv_1_name_resource
  name: '${vaults_chanpu_kv_1_name}-pep_10442308-5b02-4d51-8b69-669e8bcf8051'
  location: 'japaneast'
  properties: {
    provisioningState: 'Succeeded'
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      actionsRequired: 'None'
    }
  }
}
