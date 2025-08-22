# 🖨️ Sistema de Impressão de Pulseiras - Instalador

> **Instalação automática para Windows com interface gráfica**

## 🚀 Instalação em 2 Passos

### 1️⃣ Execute no PowerShell (SEM precisar de Administrador)
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/MatheuzSil/print-bracelets-installer/main/install.ps1" -OutFile "install.ps1"; .\install.ps1
```

**OU se der erro de permissão:**
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force; Invoke-WebRequest -Uri "https://raw.githubusercontent.com/MatheuzSil/print-bracelets-installer/main/install.ps1" -OutFile "install.ps1"; .\install.ps1
```

### 2️⃣ Configure o sistema
- Um ícone será criado na área de trabalho: **"Sistema de Impressao"**
- Clique duplo → Escolha **"Configurar Sistema (Primeira vez)"**
- Digite ID do totem e IP da impressora
- Pronto! ✅

## 📋 Requisitos
- ✅ Windows 10/11
- ✅ [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado

## 🎯 O que faz o instalador?

- 🐳 **Baixa automaticamente** a imagem do sistema
- 🖱️ **Cria ícone** na área de trabalho
- 📁 **Instala scripts** de controle em `C:\PrintBracelets\`
- 🔄 **Configura atualizações** automáticas
- ▶️ **Inicia o sistema** automaticamente

## 🖱️ Interface Gráfica (Scripts)

Após instalação, use os scripts na área de trabalho:

- 🔧 **Configurar Sistema** - Setup inicial
- 📊 **Ver Status** - Estado atual
- 📋 **Ver Logs** - Monitoramento tempo real
- ▶️ **Iniciar Sistema** - Ligar
- ⏸️ **Parar Sistema** - Desligar
- 🔄 **Reiniciar Sistema** - Reset
- 🗑️ **Desinstalar** - Remoção completa

## 🔧 Configuração

Na primeira execução configure:
- **Totem ID**: Identificador único (ex: TOTEM_01)
- **IP da Impressora**: Endereço na rede local (ex: 192.168.1.100)

## ⚙️ Sistema Automático

- 🔄 **Atualizações**: Automáticas a cada 5 minutos
- 🔃 **Restart**: Automático em caso de falha
- 📊 **Monitoramento**: Watchtower integrado

## 🆘 Suporte

### Problemas Comuns
- **Docker não rodando**: Abra Docker Desktop
- **Erro de permissão**: Execute PowerShell como Administrador
- **Impressora offline**: Verifique IP e conexão de rede

### Logs do Sistema
```powershell
# Ver logs
docker logs print-bracelets-system

# Ver status
docker ps --filter name=print-bracelets
```

---

## 🏗️ Tecnologia

- **Sistema**: Containerizado em Docker
- **Atualizações**: Automáticas via Watchtower
- **Compatibilidade**: Windows 10/11
- **Interface**: Scripts .bat amigáveis

---

**🎉 Sistema pronto para produção com instalação em 1 comando!**
