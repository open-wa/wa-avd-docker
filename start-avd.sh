/usr/local/android-sdk/tools/emulator @Pixel -gpu off

sleep 10 && adb shell pm list packages | grep whatsapp &> /dev/null
if [ $? == 0 ]; then
    echo 'WhatsApp already installed'
else
    echo 'Installing WhatsApp'
    adb install /app/whatsapp.apk
fi

sleep 5 && adb shell monkey -p com.whatsapp 1 

exit 0