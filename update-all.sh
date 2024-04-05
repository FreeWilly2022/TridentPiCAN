: '
  this is a script to update all the mcus with the latest Klipper
 
  From this website
  https://docs.vorondesign.com/community/howto/drachenkatze/automating_klipper_mcu_updates.html

  this is the official klipper document
  https://www.klipper3d.org/SDCard_Updates.html

  this video explains the set up for the Octopus board
  https://www.youtube.com/watch?v=n7zc5u3nbi4

  to run type-   bash update-all.sh

  NOTES --- I had to manually stop klipper and run the script to actually flash the mcu (no changes needed in the menuconfig), and shutdown and
  restart the printer to get it to update after running this script to make the new firmware:

  sudo service klipper stop
  cd ~/klipper
  ./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1.1

  The CAN bus directions are here:
  https://github.com/EricZimmerman/VoronTools/blob/main/EBB_CAN.md

  Specific instructions for updating are here:

https://github.com/EricZimmerman/VoronTools/blob/main/FlashKlipper.md#update-klipper-firmware-via-katapult-formerly-canboot-an-ebb36-12-in-this-example

'
sudo service klipper stop
cd ~/klipper
git pull

make clean KCONFIG_CONFIG=config.btt-octopus-f446-v1.1
make menuconfig KCONFIG_CONFIG=config.btt-octopus-f446-v1.1
make KCONFIG_CONFIG=config.btt-octopus-f446-v1.1
read -p "BTT-Octopus firmware built, please check above for any errors. Press [Enter] to continue flashing, or [Ctrl+C] to abort"

./scripts/flash-sdcard.sh /dev/ttyACM0 btt-octopus-f446-v1.1
read -p "BTT-Octopus firmware flashed, please check above for any errors. Press [Enter] to continue, or [Ctrl+C] to abort"

make clean KCONFIG_CONFIG=config.EBB36
make menuconfig KCONFIG_CONFIG=config.EBB36
make KCONFIG_CONFIG=config.EBB36
read -p "BTT-EBB36 firmware built, please check above for any errors. Press [Enter] to continue flashing, or [Ctrl+C] to abort"

cd ~/katapult/scripts
python3 flashtool.py -i can0 -f ~/klipper/out/klipper.bin -u d062c0f701a1
read -p "BTT-EBB36 firmware flashed, please check above for any errors. Press [Enter] to continue, or [Ctrl+C] to abort"


: '  since the rpi is not configured currently as an mcu, the following is not needed
make clean KCONFIG_CONFIG=config.rpi
make menuconfig KCONFIG_CONFIG=config.rpi

make KCONFIG_CONFIG=config.rpi
read -p "RPi firmware built, please check above for any errors. Press [Enter] to continue flashing, or [Ctrl+C] to abort"
make flash KCONFIG_CONFIG=config.rpi
'

sudo service klipper start
