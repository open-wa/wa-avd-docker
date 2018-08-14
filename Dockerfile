#FROM ubuntu:xenial
FROM dorowu/ubuntu-desktop-lxde-vnc:xenial

RUN mkdir /app
WORKDIR /app

COPY whatsapp.apk /app

#ENV HTTP_PASSWORD=$SELENIUM_VNC_PASSWORD
#ARG ANDROID_AVD_HOME=/app/avd
#ENV ANDROID_AVD_HOME=${ANDROID_AVD_HOME}
#ARG ANDROID_SDK_ROOT=${ANDROID_HOME}
#ENV ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT}

RUN apt-get update \
	&& apt-get install -y \
	libgl1-mesa-dev \
	wget \
	unzip \
	openjdk-8-jdk
#	v4l2loopback

#RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections \
#	&& echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

#RUN add-apt-repository ppa:webupd8team/java \
#	&& apt-get update \
#    && apt-get -y install oracle-java8-installer oracle-java8-set-default \
#    && rm -rf /var/lib/apt/lists/*

RUN wget -qO- http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz | \
	tar xvz -C /usr/local/ \
	&& mv /usr/local/android-sdk-linux /usr/local/android-sdk \
	&& chown -R root:root /usr/local/android-sdk/

# Add android tools and platform tools to PATH
ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools

# Export JAVA_HOME variable
#ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -P /app \
	&& yes 'A' | unzip /app/sdk-tools-linux-4333796.zip -d ${ANDROID_HOME} \
	&& yes | ${ANDROID_HOME}/tools/bin/sdkmanager \
	"build-tools;28.0.2" "sources;android-26" "platform-tools" "platforms;android-26" "system-images;android-26;google_apis;x86_64"

#ADD post-build.sh .
#RUN chmod +x ./post-build.sh
#CMD ./post-build.sh

#RUN tar -xvf android-sdk_r24.4.1-linux.tgz --directory /app
#RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
#RUN unzip -d /app


#COPY sdk-tools-linux-4333796.zip .
#RUN rm -rf ${ANDROID_HOME}/tools/.
#RUN if ! [ -d "${ANDROID_HOME}/tools" ]; then \
#	wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
#	&& unzip sdk-tools-linux-4333796.zip -d ${ANDROID_HOME}; fi

#RUN ${ANDROID_HOME}/tools/android list sdk
#RUN ${ANDROID_HOME}/tools/android update sdk -y --no-ui -t 2
#RUN ${ANDROID_HOME}/tools/bin/sdkmanager --list

#RUN echo no | ${ANDROID_HOME}/tools/bin/avdmanager create avd -n Pixel -k "system-images;android-26;google_apis;x86_64" \
	#-p ${ANDROID_AVD_HOME} -c 2000M

#RUN ${ANDROID_HOME}/tools/emulator @Pixel 
#-camera-back webcam1 -no-boot-anim -no-snapshot-load
#RUN adb install /app/whatsapp.apk

#RUN modprobe v4l2loopback
