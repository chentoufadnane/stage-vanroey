$rg = "AC-ARM-Test"

New-AzResourceGroup -Name $rg -Location "westeurope" -Force

New-AzResourceGroupDeployment -Name "new-rg-test" -ResourceGroupName $rg -TemplateFile "bigboy.json" -TemplateParameterFile "bigboy.parameters.json"
