
mknod /dev/video0 c 81 0
chown root:video /dev/video0 && \
chmod 660 /dev/video0

if [ $? -ne 0 ]; then
    echo "creating /dev/video failed -> did you modprobe 'modprobe v4l2loopback' on host? or does /dev/video0 exist on host?"
    exit 1
fi

echo "woooot display $DISPLAY"
ffmpeg -f x11grab -s 640x480 -i $DISPLAY -vf format=pix_fmts=yuv420p -f v4l2 /dev/video0 &


export QTWEBENGINE_DISABLE_SANDBOX=1
/usr/local/android-sdk/tools/emulator @Pixel -gpu off -camera-back webcam0

sleep 10 && adb shell pm list packages | grep whatsapp &> /dev/null
if [ $? == 0 ]; then
    echo 'WhatsApp already installed'
else
    echo 'Installing WhatsApp'
    adb install /app/whatsapp.apk
fi

sleep 5 && adb shell monkey -p com.whatsapp 1 

exit 0
