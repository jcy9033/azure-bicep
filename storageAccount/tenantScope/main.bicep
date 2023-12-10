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

@description('utcValue 값을 생성')
param utcValue string = utcNow()

@description('utcValue 값을 모두 소문자로 변경')
param lowerCaseUtcValue string = toLower(utcValue)

@description('Storage Account의 이름')
param storageAccountName string = 'st${lowerCaseUtcValue}'

/*------------------------------------------------------------------------------------------------------------*/

module storageAccount 'mouldes/storageAccount.bicep' = {
  scope: resourceGroup(system_subscriptionId, system_resourceGroup_application)
  name: 'storageAccount.bicep'
  params: {
    storageAccountName: storageAccountName
  }
}
