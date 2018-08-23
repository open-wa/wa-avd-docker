# docker-android-avd
A Docker image based on Ubuntu Desktop with VNC and noVNC access, that runs a lightweight Android Virtual Device.

The Dockerfile uses the following image as a base: [dorowu/ubuntu-desktop-lxde-vnc:xenial](https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/)

## Deployment

`docker-compose up --build`

## Access noVNC

Visit `localhost:6080`

## Start Android AVD

Run the following command

`${ANDROID_HOME}/tools/emulator @Pixel -gpu off`

Using `emulator` throws an error described somewhere on SO... can't recall where, anyway the fix is to call from directory directly.

## Further Development

I'm in the process of starting the Android emulator using xdg autostart so that the emulator is open/visible on graphical startup. Feel free to contribute!
