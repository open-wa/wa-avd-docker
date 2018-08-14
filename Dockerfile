#FROM ubuntu:xenial
FROM dorowu/ubuntu-desktop-lxde-vnc:xenial

RUN mkdir /app
RUN mkdir /app/avd
RUN mkdir /app/android-sdk-linux
WORKDIR /app

COPY whatsapp.apk /app

ENV HTTP_PASSWORD=$SELENIUM_VNC_PASSWORD
ARG ANDROID_AVD_HOME=/app/avd
ENV ANDROID_AVD_HOME=${ANDROID_AVD_HOME}
ARG ANDROID_HOME=/app/android-sdk-linux
ENV ANDROID_HOME=${ANDROID_HOME}

RUN apt-get update \
	&& apt-get install -y \
	libgl1-mesa-dev \
	wget \
	openjdk-8-jdk \
	unzip
#	v4l2loopback
# android-sdk

#RUN wget http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
#RUN tar -xvf android-sdk_r24.4.1-linux.tgz --directory /app
#RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
#RUN unzip -d /app

RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools-linux-4333796.zip -d ${ANDROID_HOME}
#COPY sdk-tools-linux-4333796.zip .
#RUN rm -rf ${ANDROID_HOME}/tools/.
#RUN if ! [ -d "${ANDROID_HOME}/tools" ]; then \
#	wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
#	&& unzip sdk-tools-linux-4333796.zip -d ${ANDROID_HOME}; fi

#RUN ${ANDROID_HOME}/tools/android list sdk
#RUN ${ANDROID_HOME}/tools/android update sdk -y --no-ui -t 2
#RUN ${ANDROID_HOME}/tools/bin/sdkmanager --list
RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager \
	"build-tools;28.0.2" "sources;android-26" "platform-tools" "platforms;android-26" "system-images;android-26;google_apis;x86_64"

#RUN ${ANDROID_HOME}/tools/bin/avdmanager create avd -n Pixel -k "system-images;android-26;google_apis;x86_64" \
#	-p ${ANDROID_AVD_HOME} -c 2000M

RUN ${ANDROID_HOME}/tools/emulator @Pixel -camera-back webcam1 -no-boot-anim -no-snapshot-load
#RUN adb install /app/whatsapp.apk

#RUN modprobe v4l2loopback
