param location string = resourceGroup().location

resource apiManagementInstance 'Microsoft.ApiManagement/service@2020-12-01' = {
  name: 'name'
  location: location
  sku: {
    capacity: 0
    name: 'Developer'
  }
  properties: {
    virtualNetworkType: 'None'
    publisherEmail: 'publisherEmail@contoso.com'
    publisherName: 'publisherName'
  }
}
