# Script de Instalação - Sistema de Impressão de Pulseiras
# Versão sem necessidade de administrador

Write-Host "======================================================" -ForegroundColor Green
Write-Host "  Sistema de Impressão de Pulseiras - Instalação" -ForegroundColor Green  
Write-Host "======================================================" -ForegroundColor Green
Write-Host ""

# Configurar ExecutionPolicy apenas para o usuário atual
Write-Host "Configurando permissões..." -ForegroundColor Blue
try {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "✓ Permissões configuradas" -ForegroundColor Green
} catch {
    Write-Host "⚠ Aviso: Não foi possível alterar ExecutionPolicy" -ForegroundColor Yellow
}

# Verificar se Docker está instalado e rodando
Write-Host "Verificando Docker..." -ForegroundColor Blue
try {
    docker --version | Out-Null
    Write-Host "✓ Docker encontrado" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker não encontrado!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Por favor, instale o Docker Desktop primeiro:" -ForegroundColor Yellow
    Write-Host "https://www.docker.com/products/docker-desktop/" -ForegroundColor White
    Write-Host ""
    Read-Host "Pressione Enter para sair"
    exit 1
}

try {
    docker info | Out-Null
    Write-Host "✓ Docker está rodando" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker não está rodando!" -ForegroundColor Red
    Write-Host "Inicie o Docker Desktop e execute este script novamente." -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host ""
Write-Host "Instalando sistema..." -ForegroundColor Blue

# Configurações
$ContainerName = "print-bracelets-system"
$InstallPath = "C:\PrintBracelets"

# Parar containers existentes
Write-Host "Parando containers existentes..." -ForegroundColor Yellow
docker stop $ContainerName watchtower 2>$null | Out-Null
docker rm $ContainerName watchtower 2>$null | Out-Null

# Baixar imagem
Write-Host "Baixando imagem do sistema..." -ForegroundColor Yellow
docker pull matheuzsilva/print-bracelets:latest

# Criar diretório de instalação
try {
    New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
    Write-Host "✓ Diretório criado: $InstallPath" -ForegroundColor Green
} catch {
    Write-Host "✗ Erro ao criar diretório: $InstallPath" -ForegroundColor Red
    Read-Host "Pressione Enter para sair"
    exit 1
}

# Criar scripts de controle
Write-Host "Criando scripts de controle..." -ForegroundColor Yellow

# Menu Principal
$menuScript = @"
@echo off
title Sistema de Impressao - Menu Principal
color 0A

:MENU
cls
echo.
echo  ================================================
echo   Sistema de Impressao de Pulseiras
echo  ================================================
echo.
echo   [1] Configurar Sistema (Primeira vez)
echo   [2] Ver Status do Sistema
echo   [3] Ver Logs em Tempo Real  
echo   [4] Iniciar Sistema
echo   [5] Parar Sistema
echo   [6] Reiniciar Sistema
echo   [7] Desinstalar Sistema
echo   [8] Sair
echo.
echo  ================================================
echo.
set /p opcao=Digite sua opcao (1-8): 

if "%opcao%"=="1" goto CONFIGURAR
if "%opcao%"=="2" goto STATUS  
if "%opcao%"=="3" goto LOGS
if "%opcao%"=="4" goto INICIAR
if "%opcao%"=="5" goto PARAR
if "%opcao%"=="6" goto REINICIAR
if "%opcao%"=="7" goto DESINSTALAR
if "%opcao%"=="8" exit
goto MENU

:CONFIGURAR
call "C:\PrintBracelets\configurar.bat"
pause
goto MENU

:STATUS
call "C:\PrintBracelets\status.bat"
pause
goto MENU

:LOGS
call "C:\PrintBracelets\logs.bat"
goto MENU

:INICIAR
call "C:\PrintBracelets\iniciar.bat"
pause
goto MENU

:PARAR
call "C:\PrintBracelets\parar.bat"
pause
goto MENU

:REINICIAR
call "C:\PrintBracelets\reiniciar.bat"
pause
goto MENU

:DESINSTALAR
call "C:\PrintBracelets\desinstalar.bat"
pause
goto MENU
"@

$menuScript | Out-File -FilePath "$InstallPath\menu-principal.bat" -Encoding ASCII

# Outros scripts essenciais
@"
@echo off
title Sistema de Impressao - Configurar
color 0B
cls
echo Acessando configuracao do sistema...
docker exec -it print-bracelets-system node setup.js
"@ | Out-File -FilePath "$InstallPath\configurar.bat" -Encoding ASCII

@"
@echo off
title Sistema de Impressao - Status
color 0D
cls
echo === Status do Sistema ===
docker ps --filter name=print-bracelets-system --filter name=watchtower --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.
echo === Ultimos logs ===
docker logs --tail 5 print-bracelets-system 2>nul
"@ | Out-File -FilePath "$InstallPath\status.bat" -Encoding ASCII

@"
@echo off
title Sistema de Impressao - Logs
color 0F
cls
echo === Logs em Tempo Real ===
echo Pressione Ctrl+C para sair
docker logs -f print-bracelets-system
"@ | Out-File -FilePath "$InstallPath\logs.bat" -Encoding ASCII

@"
@echo off
title Sistema de Impressao - Iniciar
color 0A
cls
echo Iniciando sistema...
docker start print-bracelets-system watchtower 2>nul
if errorlevel 1 (
    echo Primeira execucao - criando containers...
    docker run -d --name print-bracelets-system --restart unless-stopped --network host -it --label "com.centurylinklabs.watchtower.enable=true" matheuzsilva/print-bracelets:latest
    docker run -d --name watchtower --restart unless-stopped -v "//./pipe/docker_engine://./pipe/docker_engine" -e WATCHTOWER_CLEANUP=true -e WATCHTOWER_POLL_INTERVAL=300 -e WATCHTOWER_LABEL_ENABLE=true containrrr/watchtower:latest --interval 300 --cleanup
)
echo Sistema iniciado!
"@ | Out-File -FilePath "$InstallPath\iniciar.bat" -Encoding ASCII

@"
@echo off
title Sistema de Impressao - Parar
color 0E
cls
set /p confirmacao="Parar sistema? (s/N): "
if /i "%confirmacao%" neq "s" exit /b 0
docker stop print-bracelets-system watchtower 2>nul
echo Sistema parado!
"@ | Out-File -FilePath "$InstallPath\parar.bat" -Encoding ASCII

@"
@echo off
title Sistema de Impressao - Reiniciar
color 0D
cls
echo Reiniciando sistema...
docker restart print-bracelets-system watchtower 2>nul
echo Sistema reiniciado!
"@ | Out-File -FilePath "$InstallPath\reiniciar.bat" -Encoding ASCII

@"
@echo off
title Sistema de Impressao - Desinstalar
color 0C
cls
echo ATENCAO: Remove completamente o sistema!
set /p confirmacao="Tem CERTEZA? (s/N): "
if /i "%confirmacao%" neq "s" exit /b 0
docker stop print-bracelets-system watchtower 2>nul
docker rm print-bracelets-system watchtower 2>nul  
docker rmi matheuzsilva/print-bracelets:latest containrrr/watchtower:latest 2>nul
docker system prune -f 2>nul
echo Sistema removido!
"@ | Out-File -FilePath "$InstallPath\desinstalar.bat" -Encoding ASCII

# Criar atalho na área de trabalho
Write-Host "Criando atalho na área de trabalho..." -ForegroundColor Yellow

$DesktopPath = [Environment]::GetFolderPath('Desktop')
$ShortcutPath = "$DesktopPath\Sistema de Impressao.lnk"

try {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = "$InstallPath\menu-principal.bat"
    $Shortcut.WorkingDirectory = $InstallPath
    $Shortcut.Description = "Sistema de Impressao de Pulseiras"
    $Shortcut.IconLocation = "shell32.dll,138"
    $Shortcut.Save()
    Write-Host "✓ Atalho criado na área de trabalho" -ForegroundColor Green
} catch {
    Write-Host "⚠ Não foi possível criar atalho na área de trabalho" -ForegroundColor Yellow
}

# Iniciar sistema
Write-Host "Iniciando sistema..." -ForegroundColor Blue

try {
    # Iniciar sistema principal
    docker run -d --name $ContainerName --restart unless-stopped --network host -it --label "com.centurylinklabs.watchtower.enable=true" matheuzsilva/print-bracelets:latest | Out-Null
    
    # Iniciar Watchtower
    docker run -d --name watchtower --restart unless-stopped -v "//./pipe/docker_engine://./pipe/docker_engine" -e WATCHTOWER_CLEANUP=true -e WATCHTOWER_POLL_INTERVAL=300 -e WATCHTOWER_LABEL_ENABLE=true containrrr/watchtower:latest --interval 300 --cleanup | Out-Null
    
    Write-Host "✓ Sistema iniciado com sucesso" -ForegroundColor Green
} catch {
    Write-Host "⚠ Sistema criado, use 'Iniciar Sistema' no menu" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✅ INSTALAÇÃO CONCLUÍDA!" -ForegroundColor Green
Write-Host ""
Write-Host "🖱️  ATALHO CRIADO:" -ForegroundColor Blue
Write-Host "   'Sistema de Impressao.lnk' na área de trabalho" -ForegroundColor White
Write-Host ""
Write-Host "🎯 PRÓXIMOS PASSOS:" -ForegroundColor Blue
Write-Host "   1. Clique no ícone da área de trabalho" -ForegroundColor White
Write-Host "   2. Escolha 'Configurar Sistema (Primeira vez)'" -ForegroundColor White
Write-Host "   3. Configure ID do totem e IP da impressora" -ForegroundColor White
Write-Host "   4. Sistema estará pronto!" -ForegroundColor White
Write-Host ""
Write-Host "📁 Scripts instalados em: $InstallPath" -ForegroundColor Blue
Write-Host ""
Write-Host "🎉 Sistema pronto para uso!" -ForegroundColor Green
Write-Host ""
Read-Host "Pressione Enter para sair"
