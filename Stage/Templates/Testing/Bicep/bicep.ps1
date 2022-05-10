$ResourceGroup = "AC-ARM-Test"

New-AzResourceGroup -Name $ResourceGroup -Location 'westeurope'

$path = "c:\Users\adnane.chentouf\OneDrive - VanRoey.be\Documenten\Stage\Templates\Bicep\script.bicep"

New-AzResourceGroupDeployment -Name "new-rg-storage-test" -ResourceGroupName $ResourceGroup -TemplateFile $path