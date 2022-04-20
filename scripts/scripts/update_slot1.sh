OS=$(uname)
PWD=$(pwd)
FIRMWARE=$PWD/build.firmware-slot1/Debug/firmware-slot1.bin
FIRMWARE_SIZE_DEC=$(wc -c $FIRMWARE | awk '{print $1}')
FIRMWARE_SIZE_HEX=$(printf '%08x' $FIRMWARE_SIZE_DEC)
SHA=$(shasum $FIRMWARE | cut -d " " -f1)

if [ "$OS" = "Linux" ]; then
DEVICE=$(ls /dev/ttyACM*)
fi

if [ "$OS" = "Darwin" ]; then
DEVICE=$(ls /dev/tty.usbmodem*)
fi

UPLOAD="\$UPLOAD,START,$FIRMWARE_SIZE_HEX,$SHA\n"
REBOOT="\$REBOOT\n"
echo -e $UPLOAD
#echo $FIRMWARE_SIZE_DEC
#echo $FIRMWARE_SIZE_HEX
echo -e $DEVICE

if [ "$OS" = "Linux" ]; then
echo -e $UPLOAD > $DEVICE && sx --xmodem --16-bit-crc -vvvvv --binary $FIRMWARE > $DEVICE  < $DEVICE
fi

if [ "$OS" = "Darwin" ]; then
echo -e $UPLOAD > $DEVICE && lsz --xmodem --16-bit-crc -vvvvv --binary $FIRMWARE > $DEVICE  < $DEVICE
fi

#sleep 1
#echo -e $REBOOT > $DEVICE
