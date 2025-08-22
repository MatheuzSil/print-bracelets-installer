# 🎨 Opções de Ícones para o Sistema

## 📋 Ícones do Windows (Funciona Imediatamente)

Você pode escolher um destes ícones que já existem no Windows:

### Impressoras e Dispositivos
- `"shell32.dll,138"` - Impressora (atual)
- `"shell32.dll,139"` - Impressora com papel
- `"shell32.dll,16"` - Monitor/Tela
- `"imageres.dll,93"` - Impressora 3D moderna

### Trabalho e Produção  
- `"shell32.dll,154"` - Engrenagem/Configuração
- `"shell32.dll,21"` - Pasta de rede
- `"imageres.dll,2"` - Usuário/Pessoa
- `"imageres.dll,190"` - Caixinha/Produto

### Tecnologia
- `"imageres.dll,1"` - Computador moderno
- `"imageres.dll,13"` - Servidor
- `"shell32.dll,13"` - Disquete/Dados
- `"imageres.dll,165"` - Nuvem

### Comunicação
- `"imageres.dll,25"` - Telefone
- `"shell32.dll,17"` - Mundo/Global  
- `"imageres.dll,194"` - Mensagem

## 🖼️ Como Testar Ícones Rapidamente

Copie e cole no PowerShell para testar:

```powershell
# Criar atalho de teste na área de trabalho
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$([Environment]::GetFolderPath('Desktop'))\Teste-Icone.lnk")
$Shortcut.TargetPath = "notepad.exe"
$Shortcut.IconLocation = "imageres.dll,93"  # ← Mude aqui
$Shortcut.Save()
```

## 🎨 Ícone Personalizado (Mais Profissional)

### Para criar seu próprio ícone:

1. **Criar imagem 256x256px** com:
   - Logo da empresa
   - Ícone de impressora + pulseira
   - Cores da marca

2. **Converter para .ico:**
   - https://convertico.com/
   - https://favicon.io/

3. **Adicionar ao repositório:**
   ```bash
   # Na pasta distribuicao/
   git add logo.ico
   git commit -m "feat: adicionar ícone personalizado"
   git push
   ```

## 🔄 Alterar Ícone Atual

Para mudar o ícone usado pelo instalador, edite o arquivo `install.ps1` na linha:

```powershell
# De:
$IconPath = "shell32.dll,138"

# Para (exemplo):
$IconPath = "imageres.dll,93"
```

---

**Recomendação**: Teste alguns ícones do Windows primeiro, depois crie um personalizado se necessário!
