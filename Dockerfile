FROM dorowu/ubuntu-desktop-lxde-vnc:xenial

RUN mkdir /app
WORKDIR /app

# Install tools and JDK
RUN apt-get update \
	&& apt-get install -y \
	libgl1-mesa-dev \
	wget \
	unzip \
	openjdk-8-jdk \
	ffmpeg
#	v4l2loopback

# Install and enable KVM
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	kvm qemu-kvm libvirt-bin bridge-utils libguestfs-tools

RUN adduser `id -un` kvm \
	&& newgrp kvm

# Download Android SDK
RUN wget -qO- http://dl.google.com/android/android-sdk_r23-linux.tgz | \
	tar xvz -C /usr/local/ \
	&& mv /usr/local/android-sdk-linux /usr/local/android-sdk \
	&& chown -R root:root /usr/local/android-sdk/

# Add android tools and platform tools to PATH
ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/tools/bin
ENV PATH $PATH:$ANDROID_HOME/platform-tools

# Download Android SDK tools
# TODO: can this process be simplified?
RUN rm -rf ${ANDROID_HOME}/tools
RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -P /app \
	&& yes 'A' | unzip /app/sdk-tools-linux-4333796.zip -d ${ANDROID_HOME} \
	&& yes | ${ANDROID_HOME}/tools/bin/sdkmanager \
	"build-tools;28.0.2" "sources;android-26" "platform-tools" "platforms;android-26" "system-images;android-26;google_apis;x86"

COPY supervisord.conf /etc/supervisor/conf.d
COPY whatsapp.apk /app
COPY start-avd.sh /app
COPY start-avd-with-cam.sh /app
COPY avd.desktop /app

RUN chmod +x /app/start-avd.sh
RUN chmod +x /app/start-avd-with-cam.sh
RUN chmod +x /app/avd.desktop

# Create directory to save AVD snapshots
RUN mkdir -p /app/snapshots

RUN mkdir -p /root/.config/autostart
RUN cp /app/avd.desktop /root/.config/autostart
RUN mkdir -p /root/Desktop
RUN cp /app/avd.desktop /root/Desktop
RUN echo '@sh /app/start-avd.sh' >> /etc/xdg/lxsession/LXDE/autostart

ADD entrypoint.sh /app
RUN chmod +x /app/entrypoint.sh
CMD /app/entrypoint.sh

#-camera-back webcam1 -no-boot-anim -no-snapshot-load
#RUN adb install /app/whatsapp.apk

#RUN modprobe v4l2loopback
