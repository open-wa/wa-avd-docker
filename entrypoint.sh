#!/bin/bash
set -e

# Create the kvm node (required --privileged)
if [ ! -e /dev/kvm ]; then
    mknod /dev/kvm c 10 $(grep '\<kvm\>' /proc/misc | cut -f 1 -d' ')
fi

# Create Pixel AVD, if it doesn't already exist
${ANDROID_HOME}/tools/bin/avdmanager list avd | grep 'Pixel' &> /dev/null
if ! [ $? == 0 ]; then
    echo "Creating Pixel AVD..."
    ${ANDROID_HOME}/tools/bin/avdmanager create avd -n Pixel -k "system-images;android-26;google_apis;x86" -c 2000M | echo no \
    && echo 'hw.keyboard=yes' >> /root/.android/avd/Pixel.avd/config.ini # enable hardware keyboard input
else
    echo "Pixel AVD already exists"
fi

# Start Android emulator and install WhatsApp
# See https://github.com/fcwu/docker-ubuntu-vnc-desktop/blob/master/image/etc/supervisor/conf.d/supervisord.conf
export ANDROID_AVD_HOME=/root/.android/avd ANDROID_SDK_HOME=/root/.android HOME=/root DISPLAY=:1.0 \
    && xhost +local:docker \
    && xhost +local:root \
    && rm $ANDROID_AVD_HOME/Pixel.avd/hardware-qemu.ini.lock
    && ${ANDROID_HOME}/tools/emulator @Pixel -gpu off -no-boot-anim -snapstorage /app/snapshots \
    && adb install /app/whatsapp.apk
