# UnlockMotorolaPro
Automatic USB bootloader unlocker via Termux

Welcome!  
I created this script after seeing many people fail to unlock the bootloader using Bugjaeger.  
So I thought: why not create my own tool to automate this process?

This program was made specifically to unlock Motorola bootloaders via Termux.

Important note:  
If you do not receive the Unlock Key from Motorola, this is **not** an issue with the tool.  
It means your device is not eligible for official bootloader unlocking.

---

## How to download

```bash
pkg update && pkg upgrade
pkg install git -y
git clone https://github.com/GahMarin1/UnlockMotorolaPro.git
