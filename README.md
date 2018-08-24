# Docker Android AVD with WhatsApp pre-installed
A Docker image based on Ubuntu Desktop with VNC and noVNC access, that runs a lightweight Android Virtual Device.

The Dockerfile uses the following image as a base: [dorowu/ubuntu-desktop-lxde-vnc:xenial](https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/)

## Deployment

`docker-compose up --build`

## Access noVNC

Visit `localhost:6080`

## Start Android AVD

Using Supervisord to manage the services, the Android AVD should start up automatically with WhatsApp pre-installed. If it doesn't then...:

Run the following command

`${ANDROID_HOME}/tools/emulator @Pixel -gpu off`

Using `emulator` throws an error described somewhere on SO... can't recall where, anyway the fix is to call from directory directly.

## Further Development

I'd like to stream a VNC feed via the `v4l2loopback` kernel module into the Android AVD... WIP. This would allow one to scan WhatsApp web barcodes remotely.

## Acknowledgements

* [tracer0tong/android-emulator](https://github.com/tracer0tong/android-emulator)
* [fcwu/docker-ubuntu-vnc-desktop](https://github.com/fcwu/docker-ubuntu-vnc-desktop)
* [butomo1989/docker-android](https://github.com/butomo1989/docker-android)
