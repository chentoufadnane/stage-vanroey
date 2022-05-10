#Variabelen
$rg = "MSTechnics"
$desname = $rg + '-DiskEncSet' #Dit niet veranderen tenzij je het ook in de template veranderd
$VNetName = $rg + '-VNET' #Dit niet veranderen tenzij je het ook in de template veranderd
$DC1IP = "10.10.10.11"

# Resource Group aanmaken
New-AzResourceGroup -Name $rg -Location "westeurope" -Force

# Eerste template deployen
New-AzResourceGroupDeployment -Name "new-STAC-KV-Key-DES" -ResourceGroupName $rg -TemplateFile "STAC-KV-DES/Template-1.json" -TemplateParameterFile "STAC-KV-DES/Template-1.parameters.json"

Write-Host "De resource group met naam $rg wordt aangemaakt. Ook wordt er een key vault aangemaakt met daarbij ook een key. Tenslotte wordt de disk encryption set aangemaakt.`n" -ForegroundColor Yellow

# Controleren of de Disk Encryption Set de juiste toegang heeft
$objectID = (Get-AzDiskEncryptionSet -Name $desname).Identity.PrincipalId
if (!(Get-AzRoleAssignment -ObjectId $objectID -RoleDefinitionName 'Key Vault Administrator')) {
    New-AzRoleAssignment -ResourceGroupName $rg -RoleDefinitionName 'Key Vault Administrator' -ObjectId $objectID
} else {
    Write-Host "`nDe rol 'Key Vault Administrator' bestaat al" -ForegroundColor Yellow
}

Write-Host "`nDe rest van je omgeving wordt opgesteld. Eventjes geduld." -ForegroundColor Yellow

# Tweede template deployen
New-AzResourceGroupDeployment -Name "new-vm-vnet-backup-ext-hostpool" -ResourceGroupName $rg -TemplateFile "VNET-VM-AVD/Template-2.json" -TemplateParameterFile "VNET-VM-AVD/Template-2.parameters.json"

az network vnet update -g $rg -n $VNetName --dns-servers $DC1IP