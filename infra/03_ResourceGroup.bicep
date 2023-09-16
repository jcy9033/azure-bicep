targetScope = 'subscription'

@description('パラメータ変更必要')
param tagValue_serviceName string = '<タグの値>'
param tagValue_businessOwnersDepartment string = '<タグの値>'
param tagValue_bisinessOwnersEmail string = '<タグの値>'
param tagValue_SystemAdministratorDepartment string = '<タグの値>'
param tagValue_SystemAdministratorEmail string = '<タグの値>'
param tagValue_BillingContactsDepartment string = '<タグの値>'
param tagValue_BillingContactsEmail string = '<タグの値>'

/*-----------------------------------------------------------------------------------------------------------------------*/

@description('パラメータ変更不要')
param tags object = {
  'Service name': tagValue_serviceName
  'Business owner\'s department': tagValue_businessOwnersDepartment
  'Business owner\'s email': tagValue_bisinessOwnersEmail
  'System administrator\'s department': tagValue_SystemAdministratorDepartment
  'System administrator\'s email': tagValue_SystemAdministratorEmail
  'Billing contact\'s department': tagValue_BillingContactsDepartment
  'Billing contact\'s email': tagValue_BillingContactsEmail
}

param location object = {
  JPE: 'japaneast'
  JPW: 'japanwest'
}

@description('Country Hosting - Japan East resource group for networking resources')
resource newRg_1 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'JP-RG-JPE-CoreNetworking'
  tags: tags
  location: location.JPE
}

@description('Country Hosting - Japan West resource group for networking resources')
resource newRg_2 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'JP-RG-JPW-CoreNetworking'
  tags: tags
  location: location.JPW
}

@description('Country Hosting - Japan East resource group for network watcher')
resource newRg_3 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'NetworkWatcherRG'
  tags: tags
  location: location.JPE
}

output newRg_1_Name string = newRg_1.name
output newRg_2_Name string = newRg_2.name
output newRg_3_Name string = newRg_3.name
