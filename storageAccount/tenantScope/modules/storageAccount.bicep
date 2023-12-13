@description('Storage Account의 이름')
param storageAccountName string

@description('Resource Group의 Location을 계승')
param location string = resourceGroup().location

param tags object

/*------------------------------------------------------------------------------------------------------------*/

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  tags: tags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

/*------------------------------------------------------------------------------------------------------------*/

@description('main.bicep에 사용할 Storage Account의 이름')
output name string = storageaccount.name

@description('main.bicep에 사용할 Storage Account의 ID')
output id string = storageaccount.id
