#!/data/data/com.termux/files/usr/bin/bash

# ===== COLORS =====
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

# ===== DEPENDENCIES =====
echo -e "${BLUE}➜ Checking dependencies...${RESET}"
(command -v adb >/dev/null && command -v fastboot >/dev/null) & spinner

if ! command -v adb >/dev/null || ! command -v fastboot >/dev/null; then
  echo -e "\n${RED}❌ adb or fastboot not found${RESET}"
  echo -e "${YELLOW}Install with:${RESET} pkg install android-tools"
  exit 1
fi

echo -e "\n${GREEN}✔ Dependencies OK${RESET}"
sleep 1

# ===== ADB =====
echo
echo -e "${CYAN}📱 Connect your phone with USB DEBUGGING enabled${RESET}"
read -p "Press ENTER to continue..."

adb start-server >/dev/null 2>&1 & spinner
sleep 1

echo
echo -e "${BLUE}Connected devices:${RESET}"
adb devices
echo

read -p "Did your device appear? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
  echo -e "${RED}❌ No device detected.${RESET}"
  exit 1
fi

# ===== REBOOT TO BOOTLOADER =====
echo
echo -e "${YELLOW}➜ Rebooting to BOOTLOADER...${RESET}"
adb reboot bootloader & spinner

echo
echo -e "${CYAN}⏳ Waiting for FASTBOOT mode...${RESET}"
while ! fastboot devices | grep -q fastboot; do
  sleep 1
done

echo -e "${GREEN}✔ FASTBOOT detected${RESET}"
sleep 1

# ===== GET UNLOCK DATA =====
echo
echo -e "${CYAN}➜ Retrieving bootloader code...${RESET}"
RAW_CODE=$(fastboot oem get_unlock_data 2>/dev/null | \
grep -i "Unlock" | sed 's/(bootloader)//g' | tr -d ' \r\n')

echo
echo -e "${WHITE}════════════════════════════════════════════${RESET}"
echo -e "${GREEN}BOOTLOADER CODE (COPY WITHOUT SPACES):${RESET}"
echo -e "${YELLOW}$RAW_CODE${RESET}"
echo -e "${WHITE}════════════════════════════════════════════${RESET}"

echo
echo -e "${CYAN}⚠️  INSTRUCTIONS:${RESET}"
echo -e "${WHITE}1.${RESET} Copy the code above"
echo -e "${WHITE}2.${RESET} Remove ALL spaces"
echo -e "${WHITE}3.${RESET} Paste it on the Motorola website"
echo -e "${WHITE}4.${RESET} Request the Unlock Key"
echo

read -p "Paste the UNLOCK KEY received by email: " UNLOCK_KEY

if [[ -z "$UNLOCK_KEY" ]]; then
  echo -e "${RED}❌ Unlock Key is empty.${RESET}"
  exit 1
fi

# ===== UNLOCK =====
echo
echo -e "${YELLOW}➜ Unlocking bootloader...${RESET}"
fastboot oem unlock "$UNLOCK_KEY" & spinner
sleep 2

# ===== FINISH =====
echo
echo -e "${GREEN}════════════════════════════════════════════${RESET}"
echo -e "${GREEN}✔ Thank you for trusting us!${RESET}"
echo -e "${CYAN}👉 You can now ROOT your device after setup! :)${RESET}"
echo -e "${GREEN}════════════════════════════════════════════${RESET}"

sleep 4
exit
