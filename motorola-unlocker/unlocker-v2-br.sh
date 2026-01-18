#!/data/data/com.termux/files/usr/bin/bash

# ===== CORES =====
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

# ===== SPINNER =====
spinner() {
  local pid=$!
  local delay=0.1
  local spinstr='|/-\'
  while ps a | awk '{print $1}' | grep -q "$pid"; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

clear
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════╗"
echo "║      MOTOROLA BOOTLOADER UNLOCK PRO       ║"
echo "║        Auto Detect FASTBOOT v2           ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${RESET}"
sleep 1

# ===== DEPENDÊNCIAS =====
echo -e "${BLUE}➜ Verificando dependências...${RESET}"
(command -v adb >/dev/null && command -v fastboot >/dev/null) & spinner

if ! command -v adb >/dev/null || ! command -v fastboot >/dev/null; then
  echo -e "\n${RED}❌ adb ou fastboot não encontrado${RESET}"
  echo -e "${YELLOW}Instale com:${RESET} pkg install android-tools"
  exit 1
fi

echo -e "\n${GREEN}✔ Dependências OK${RESET}"
sleep 1

# ===== ADB =====
echo
echo -e "${CYAN}📱 Conecte o celular com DEPURAÇÃO USB ativa${RESET}"
read -p "Pressione ENTER para continuar..."

adb start-server >/dev/null 2>&1 & spinner
sleep 1

echo
echo -e "${BLUE}Dispositivos conectados:${RESET}"
adb devices
echo

read -p "Seu dispositivo apareceu? (s/n): " CONFIRM
if [[ "$CONFIRM" != "s" ]]; then
  echo -e "${RED}❌ Nenhum dispositivo confirmado.${RESET}"
  exit 1
fi

# ===== REBOOT =====
echo
echo -e "${YELLOW}➜ Reiniciando para o BOOTLOADER...${RESET}"
adb reboot bootloader & spinner

echo
echo -e "${CYAN}⏳ Aguardando entrada em FASTBOOT...${RESET}"
while ! fastboot devices | grep -q fastboot; do
  sleep 1
done

echo -e "${GREEN}✔ FASTBOOT detectado${RESET}"
sleep 1

# ===== UNLOCK DATA =====
echo
echo -e "${CYAN}➜ Obtendo código do bootloader...${RESET}"
RAW_CODE=$(fastboot oem get_unlock_data 2>/dev/null | \
grep -i "Unlock" | sed 's/(bootloader)//g' | tr -d ' \r\n')

echo
echo -e "${WHITE}════════════════════════════════════════════${RESET}"
echo -e "${GREEN}CÓDIGO DO BOOTLOADER (COPIE SEM ESPAÇOS):${RESET}"
echo -e "${YELLOW}$RAW_CODE${RESET}"
echo -e "${WHITE}════════════════════════════════════════════${RESET}"

echo
echo -e "${CYAN}⚠️  INSTRUÇÕES:${RESET}"
echo -e "${WHITE}1.${RESET} Copie o código acima"
echo -e "${WHITE}2.${RESET} Remova TODOS os espaços"
echo -e "${WHITE}3.${RESET} Cole no site da Motorola"
echo -e "${WHITE}4.${RESET} Solicite a Unlock Key"
echo

read -p "Cole aqui a UNLOCK KEY recebida por email: " UNLOCK_KEY

if [[ -z "$UNLOCK_KEY" ]]; then
  echo -e "${RED}❌ Unlock Key vazia.${RESET}"
  exit 1
fi

# ===== UNLOCK =====
echo
echo -e "${YELLOW}➜ Desbloqueando bootloader...${RESET}"
fastboot oem unlock "$UNLOCK_KEY" & spinner
sleep 2

# ===== FINAL =====
echo
echo -e "${GREEN}════════════════════════════════════════════${RESET}"
echo -e "${GREEN}✔ Obrigado por Confiar na Gente!${RESET}"
echo -e "${CYAN}👉 Você já pode fazer ROOT após configurar seu celular! :)${RESET}"
echo -e "${GREEN}════════════════════════════════════════════${RESET}"

sleep 4
exit
