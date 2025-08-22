# Script para testar diferentes ícones na área de trabalho
Write-Host "🎨 Testador de Ícones para Sistema de Impressão" -ForegroundColor Green
Write-Host "=" * 50

# Lista de ícones para testar
$icones = @{
    "Impressora Clássica" = "shell32.dll,138"
    "Impressora com Papel" = "shell32.dll,139" 
    "Impressora 3D Moderna" = "imageres.dll,93"
    "Engrenagem Configuração" = "shell32.dll,154"
    "Computador Moderno" = "imageres.dll,1"
    "Servidor/Sistema" = "imageres.dll,13"
    "Usuário/Pessoa" = "imageres.dll,2"
    "Produto/Caixa" = "imageres.dll,190"
    "Nuvem" = "imageres.dll,165"
    "Rede Global" = "shell32.dll,17"
}

Write-Host "Criando atalhos de teste na área de trabalho..." -ForegroundColor Blue
Write-Host ""

$desktop = [Environment]::GetFolderPath('Desktop')
$WshShell = New-Object -ComObject WScript.Shell

foreach ($item in $icones.GetEnumerator()) {
    $nome = $item.Key
    $icone = $item.Value
    
    $shortcutPath = "$desktop\TESTE - $nome.lnk"
    $shortcut = $WshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = "notepad.exe"
    $shortcut.Description = "Teste de ícone: $nome"
    $shortcut.IconLocation = $icone
    $shortcut.Save()
    
    Write-Host "✓ Criado: TESTE - $nome" -ForegroundColor Green
}

Write-Host ""
Write-Host "🖱️ Verifique sua área de trabalho!" -ForegroundColor Yellow
Write-Host "Escolha o ícone que mais gosta e anote o nome." -ForegroundColor Yellow
Write-Host ""
Write-Host "🗑️ Para limpar os testes depois:" -ForegroundColor Blue
Write-Host "Remove-Item '$desktop\TESTE - *.lnk'" -ForegroundColor White
Write-Host ""

# Script de limpeza opcional
$limpar = Read-Host "Deseja criar script de limpeza? (s/N)"
if ($limpar -eq "s" -or $limpar -eq "S") {
    @"
# Script para remover atalhos de teste
Remove-Item "$desktop\TESTE - *.lnk" -Force
Write-Host "Atalhos de teste removidos!" -ForegroundColor Green
"@ | Out-File -FilePath "limpar-testes.ps1" -Encoding UTF8
    Write-Host "✓ Script 'limpar-testes.ps1' criado" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎯 Próximo passo:" -ForegroundColor Blue  
Write-Host "Edite o install.ps1 e mude a linha:" -ForegroundColor White
Write-Host '$IconPath = "imageres.dll,93"' -ForegroundColor Yellow
Write-Host "Para o ícone escolhido!" -ForegroundColor White
