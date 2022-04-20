$rg = "AC-ARM"

New-AzResourceGroup -Name $rg -Location "westeurope" -Force

New-AzResourceGroupDeployment -Name "new-rg-storageacc-keyv" -ResourceGroupName $rg -TemplateFile "01-storage.json" -TemplateParameterFile "01-storage.parameters.json"
