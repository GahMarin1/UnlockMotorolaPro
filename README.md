# UnlockMotorolaPro
Automatic USB bootloader unlocker via Termux

Welcome!  
I created this script after seeing many people fail to unlock the bootloader using Bugjaeger.  
So I thought: why not create my own tool to automate this process?

This program was made specifically to unlock Motorola bootloaders via Termux.

Important note:  
If you do not receive the Unlock Key from Motorola, this is **not** an issue with the tool.  
It means your device is not eligible for official bootloader unlocking.

BEFORE YOU BEGIN, KNOW ONE THING
⚠️THIS WILL WIPE THE FUCK OUT OF YOUR DATA
If you don't know how to do this, you risk hard bricking your phone.
search tutorials, or read the motorola official page to get what im saying

[Motorola Page (LOGIN TO GET KEY)](https://en-us.support.motorola.com/app/standalone/bootloader/unlock-your-device-a)

---

## How to download

```bash
pkg update && pkg upgrade

pkg install git android-tools -y
git clone https://github.com/GahMarin1/UnlockMotorolaPro.git
cd UnlockMotorolaPro
cd motorola-unlocker
```
select what version you want

1. English
```bash
chmod +x unlock-moto-en.sh
./unlock-moto-en.sh
```

2. Portuguese
```bash
chmod +x unlocker-v2-br.sh
./unlocker-v2-br.sh
```

hope you can do it!

