targetScope = 'managementGroup'

@description('パラメータ変更必要')
param dept string = '<部署名>'
@allowed([
  'DEV'
  'PRD'
])
param env string = '<環境>'

param tagValues array = [
  '<サービスネーム：タグの値>'
  '<ビジネスオーナーの部署名：タグの値>'
  '<ビジネスオーナーのメール：タグの値>'
  '<システム管理者の部署名：タグの値>'
  '<システム管理者のメール：タグの値>'
  '<請求担当者の部署名：タグの値>'
  '<請求担当者のメール：タグの値>'
]

/*-----------------------------------------------------------------------------------------------------------------------*/

@description('パラメータ変更不要')
param tagNames array = [
  'Service name'
  'Business owner\'s department'
  'Business owner\'s email'
  'System administrator\'s department'
  'System administrator\'s email'
  'Billing contact\'s department'
  'Billing contact\'s email'
]

param policyDefinitionBase string = '/providers/Microsoft.Management/managementGroups/<ルート管理グループ>/providers/Microsoft.Authorization/policyDefinitions'
param policyDefinitionIds array = [
  '${policyDefinitionBase}/<ポリシーID>'
  '${policyDefinitionBase}/<ポリシーID>'
  '${policyDefinitionBase}/<ポリシーID>'
  '${policyDefinitionBase}/<ポリシーID>'
  '${policyDefinitionBase}/<ポリシーID>'
  '${policyDefinitionBase}/<ポリシーID>'
  '${policyDefinitionBase}/<ポリシーID>'
]

param category string = '<カテゴリー>'

// Resource definition
resource policySetDefinition 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: 'JP Add a tag to resource groups - ${env} ${dept}'
  properties: {
    displayName: 'JP Add a tag to resource groups - ${env} ${dept}'
    policyType: 'Custom'
    description: 'Automatically add the required tags to the resource group.'
    metadata: {
      version: '1.0.0'
      category: category
      source: 'Azure built-in policy definition - Add a Tag to resource groups'
    }
    policyDefinitions: [for i in range(0, length(tagNames)): {
      policyDefinitionId: policyDefinitionIds[i]
      parameters: {
        tagName: {
          value: tagNames[i]
        }
        tagValue: {
          value: tagValues[i]
        }
      }
    }]
  }
}


@description('Default values for policy assignment')
param location string = 'japaneast'

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'policyAssignment'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'JP Add a Tag to resource groups - ${env} ${dept}'
    description: 'Cannot modify tag value in policy assignment. If you want to modify the value, set it in the policy definition.'
    enforcementMode: 'Default'
    policyDefinitionId: policySetDefinition.id
  }
}
