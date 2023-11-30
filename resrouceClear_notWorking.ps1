# 사용자에게 리소스 그룹 이름을 입력받음
$groupName = Read-Host -Prompt "Enter the name of the resource group"
$groupLocation = 'japaneast'

# 입력받은 리소스 그룹 이름으로 그룹 삭제
az group delete --name $groupName

# 이전 명령이 성공적으로 수행되었는지 확인 후, 리소스 그룹 생성
if ($?) { az group create --name $groupName --location $groupLocation }
