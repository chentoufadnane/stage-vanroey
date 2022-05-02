#Variabelen
$rg = "RG-MSTechnics-2"
$desname = $rg + '-DiskEncSet' #Dit niet veranderen tenzij je het ook in de template veranderd

# Resource Group aanmaken
New-AzResourceGroup -Name $rg -Location "westeurope" -Force

# Eerste template deployen
New-AzResourceGroupDeployment -Name "new-hp-dag-wp" -ResourceGroupName $rg -TemplateFile "Storage/storage.json" -TemplateParameterFile "Storage/storage.parameters.json"

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
New-AzResourceGroupDeployment -Name "new-vm-vnet" -ResourceGroupName $rg -TemplateFile "VNET/VNET.json" -TemplateParameterFile "VNET/VNET.parameters.json"