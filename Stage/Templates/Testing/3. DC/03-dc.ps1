$rg = "AC-ARM"

# New-AzResourceGroup -Name $rg -Location "westeurope" -Force

New-AzResourceGroupDeployment -Name "adnane-first-deploy" -ResourceGroupName $rg -TemplateFile "test.json" -TemplateParameterFile "test.parameters.json"