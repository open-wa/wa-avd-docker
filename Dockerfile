#FROM ubuntu:xenial
FROM dorowu/ubuntu-desktop-lxde-vnc:xenial

RUN mkdir /app
WORKDIR /app

COPY whatsapp.apk /app

RUN apt-get update \
	&& apt-get install -y \
	libgl1-mesa-dev \
	wget \
	unzip \
	openjdk-8-jdk
#	v4l2loopback

#RUN apt-get install -y \
#	qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	kvm qemu-kvm libvirt-bin bridge-utils libguestfs-tools

RUN adduser `id -un` kvm \
	&& newgrp kvm

#RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections \
#	&& echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

#RUN add-apt-repository ppa:webupd8team/java \
#	&& apt-get update \
#    && apt-get -y install oracle-java8-installer oracle-java8-set-default \
#    && rm -rf /var/lib/apt/lists/*

RUN wget -qO- http://dl.google.com/android/android-sdk_r23-linux.tgz | \
	tar xvz -C /usr/local/ \
	&& mv /usr/local/android-sdk-linux /usr/local/android-sdk \
	&& chown -R root:root /usr/local/android-sdk/

# Add android tools and platform tools to PATH
ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/tools/bin
ENV PATH $PATH:$ANDROID_HOME/platform-tools

# Export JAVA_HOME variable
#ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN rm -rf ${ANDROID_HOME}/tools
RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -P /app \
	&& yes 'A' | unzip /app/sdk-tools-linux-4333796.zip -d ${ANDROID_HOME} \
	&& yes | ${ANDROID_HOME}/tools/bin/sdkmanager \
	"build-tools;28.0.2" "sources;android-26" "platform-tools" "platforms;android-26" "system-images;android-26;google_apis;x86"

ADD entrypoint.sh /app
RUN chmod +x /app/entrypoint.sh
CMD /app/entrypoint.sh

#RUN ${ANDROID_HOME}/tools/emulator @Pixel -gpu off
# -no-accel
# -qemu -m 1024 -enable-kvm
#-camera-back webcam1 -no-boot-anim -no-snapshot-load
#RUN adb install /app/whatsapp.apk

#RUN modprobe v4l2loopback
