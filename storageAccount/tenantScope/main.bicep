targetScope = 'tenant'

/*------------------------------------------------------------------------------------------------------------*/

@description('Subscription ID of Core')
param core_subscriptionId string = '611a7ed8-17fa-480a-901d-d7084803c376'

@description('Name of core networks resource group')
param core_resourceGroup_networks string = 'core-networks'

@description('Subscription ID of Systems')
param system_subscriptionId string = '0b5f5005-c30c-4a28-89c1-9457d0cd5e0f' /* 환경에 맞춰 값을 변경 */

@description('Name of networks resource group')
param system_resourceGroup_networks string = 'chanpu-networks'

@description('Name of applications resource group')
param system_resourceGroup_application string = 'chanpu-app'

/*------------------------------------------------------------------------------------------------------------*/

@description('utcValue')
param utcValue string = utcNow()

@description('Change utcValue with lowerCase')
param lowerCaseUtcValue string = toLower(utcValue)

@description('Name of storage account')
param storageAccountName string = 'st${lowerCaseUtcValue}'

@description('Sub resource of storage account')
param sub_resource string = 'blob'

@description('Name of virtual network')
param virtualNetworkName string = 'vnet-20231209T101152Z' /* 환경에 맞춰 값을 변경 */

@description('Name of subnet')
param subnetName string = 'subnet-1' /* 환경에 맞춰 값을 변경 */

@description('Private ip address')
param privateIpAddress string = '10.0.0.30' /* 환경에 맞춰 값을 변경 */

@description('Location of resource groups and resources')
param location string = 'japaneast'

@description('Name of private dns zone')
param privateDnsZoneName string = 'privatelink.vaultcore.azure.net'

@description('Tag values of storage account')
param tags object = {}

/*------------------------------------------------------------------------------------------------------------*/

module storageAccount 'modules/storageAccount.bicep' = {
  scope: resourceGroup(system_subscriptionId, system_resourceGroup_application)
  name: 'storageAccount.bicep'
  params: {
    storageAccountName: storageAccountName
    location: location
    tags: tags
  }
}

@description('Module of virtual network')
module virtualNetwork 'modules/virtualNetwork.bicep' = {
  scope: resourceGroup(system_subscriptionId, system_resourceGroup_networks)
  name: 'virtualNetwork.bicep'
  params: {
    virtualNetworkName: virtualNetworkName /* Output 사용 불가 */
  }
}

@description('Module of private endpoint for key vault')
module privateEndpoint 'modules/privateEndpoint.Bicep' = {
  scope: resourceGroup(system_subscriptionId, system_resourceGroup_networks)
  name: 'privateEndpoint.bicep'
  params: {
    location: location
    privateDnsZoneId: privateDnsZone.outputs.id
    privateDnsZoneName: privateDnsZone.outputs.name
    privateIpAddress: privateIpAddress
    sub_resource: sub_resource
    storageAccountId: storageAccount.outputs.id
    storageAccountName: storageAccount.outputs.name
    subnetName: subnetName
    virtualNetworkName: virtualNetwork.outputs.name
  }
}

@description('Module of private dns zone(privatelink.vaultcore.azure.net)')
module privateDnsZone 'modules/privateDnsZone.Bicep' = {
  scope: resourceGroup(core_subscriptionId, core_resourceGroup_networks)
  name: 'privateDnsZone.bicep'
  params: {
    privateDnsZoneName: privateDnsZoneName /* Output 사용 불가 */
    virtualNetworkId: virtualNetwork.outputs.id
    virtualNetworkLinkName: virtualNetwork.outputs.name
  }
}
