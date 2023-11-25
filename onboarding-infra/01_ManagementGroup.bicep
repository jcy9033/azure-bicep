targetScope = 'managementGroup'

@description('パラメータ変更必要')
param dept string = '<部署名>'

/*-----------------------------------------------------------------------------------------------------------------------*/

@description('パラメータ変更不要')
param envs array = [ 'DEV', 'PRD' ]

var parentMgs = {
  DEV: '/providers/Microsoft.Management/managementGroups/<開発ルート管理グループ>'
  PRD: '/providers/Microsoft.Management/managementGroups/<本番ルート管理グループ>'
}

resource newMgs 'Microsoft.Management/managementGroups@2021-04-01' = [for env in envs: {
  name: '<管理グループのプレフィクス>${env}-${dept}'
  scope: tenant()
  properties: {
    displayName: '<管理グループのプレフィクス>${env} ${dept}'
    details: {
      parent: {
        id: parentMgs[env]
      }
    }
  }
}]
