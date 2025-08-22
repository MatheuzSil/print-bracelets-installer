# Script para testar diferentes ícones na área de trabalho
Write-Host "Testador de Icones para Sistema de Impressao" -ForegroundColor Green
Write-Host "=" * 50

# Lista de ícones para testar
$icones = @{
    "Impressora Classica" = "shell32.dll,138"
    "Impressora com Papel" = "shell32.dll,139" 
    "Impressora 3D Moderna" = "imageres.dll,93"
    "Engrenagem Configuracao" = "shell32.dll,154"
    "Computador Moderno" = "imageres.dll,1"
    "Servidor Sistema" = "imageres.dll,13"
    "Usuario Pessoa" = "imageres.dll,2"
    "Produto Caixa" = "imageres.dll,190"
    "Nuvem" = "imageres.dll,165"
    "Rede Global" = "shell32.dll,17"
}

Write-Host "Criando atalhos de teste na area de trabalho..." -ForegroundColor Blue
Write-Host ""

$desktop = [Environment]::GetFolderPath('Desktop')
$WshShell = New-Object -ComObject WScript.Shell

foreach ($item in $icones.GetEnumerator()) {
    $nome = $item.Key
    $icone = $item.Value
    
    $shortcutPath = "$desktop\TESTE - $nome.lnk"
    $shortcut = $WshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = "notepad.exe"
    $shortcut.Description = "Teste de icone: $nome"
    $shortcut.IconLocation = $icone
    $shortcut.Save()
    
    Write-Host "Criado: TESTE - $nome" -ForegroundColor Green
}

Write-Host ""
Write-Host "Verifique sua area de trabalho!" -ForegroundColor Yellow
Write-Host "Escolha o icone que mais gosta e anote o nome." -ForegroundColor Yellow
Write-Host ""
Write-Host "Para limpar os testes depois:" -ForegroundColor Blue
Write-Host "Remove-Item '$desktop\TESTE - *.lnk'" -ForegroundColor White
Write-Host ""
Write-Host "Proximo passo:" -ForegroundColor Blue  
Write-Host "Edite o install.ps1 e mude a linha do IconPath" -ForegroundColor White
