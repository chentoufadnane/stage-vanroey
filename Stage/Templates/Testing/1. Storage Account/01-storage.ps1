$rg = "AC-ARM"

New-AzResourceGroup -Name $rg -Location "westeurope" -Force

New-AzResourceGroupDeployment -Name "new-rg-test" -ResourceGroupName $rg -TemplateFile "1. Storage Account/01-storage.json" -TemplateParameterFile "1. Storage Account/01-storage.parameters.json"
