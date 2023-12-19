@description('Storage Account의 이름')
param storageAccountName string

@description('Resource Group의 Location을 계승')
param location string = resourceGroup().location

param tags object

/*------------------------------------------------------------------------------------------------------------*/

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  tags: tags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    azureFilesIdentityBasedAuthentication: {
      directoryServiceOptions: 'None' // Option: 
    }
    // customDomain: { name: '' }
    encryption: {
      keySource: 'Microsoft.Keyvault'
    }
    isHnsEnabled: false // Option:
    isNfsV3Enabled: false // Option:
    largeFileSharesState: 'Disabled'
    keyPolicy: {
      keyExpirationPeriodInDays: 180
    }
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices' // Option:
      ipRules: [// Option:
        {
          value: ''
        }
      ]
      virtualNetworkRules: [// Option:
        {
          id: ''
        }
      ]
      resourceAccessRules: [// Option:
        {
          resourceId: ''
          tenantId: ''
        }
      ]
    }
    routingPreference: {}
    supportsHttpsTrafficOnly: true
    sasPolicy: {
      expirationAction: 'Log'
      sasExpirationPeriod: ''
    }
  }
}

/*------------------------------------------------------------------------------------------------------------*/

@description('main.bicep에 사용할 Storage Account의 이름')
output name string = storageAccount.name

@description('main.bicep에 사용할 Storage Account의 ID')
output id string = storageAccount.id
