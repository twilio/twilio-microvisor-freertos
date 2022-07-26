# FreeRTOS Microvisor Sample Project

This repo provides a basic demonstration of user application firmware based on the [FreeRTOS](https://freertos.org/) real-time operating system and which will run on the “non-secure” side of Microvisor.

Most of the project files can be found in the [Demo/](Demo/) directory. The [ST_Code/](ST_Code/) directory contains required components that are not part of Twilio Microvisor STM32U5 HAL, which this sample accesses as a submodule. FreeRTOS is also incorporated as a submodule.

The `FreeRTOSConfig.h` and `stm32u5xx_hal_conf.h` configuration files are located in the [Config/](Config/) directory.

The sample code toggles GPIO A5, which is the user LED on the Microvisor Nucleo Development Board. It also emits a “ping” to the Microvisor logger once a second.

## Build with Docker

Build the image:

```shell
docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t microvisor-gpio-sample-image .
```

Run the build:

```shell
docker run -it --rm -v $(pwd)/:/home/ --name microvisor-gpio-sample microvisor-gpio-sample-image
```

The bundle for submission to Twilio for deployment will be `build/Demo/gpio_toggle_demo.zip`.

## Build in Ubuntu

The sample code has the following dependencies:

- `cmake`
- `gcc-arm-none-eabi` — tested with version 9-2019-q4

Prepare to build:

- Ensure all submodules are initialized:

    ```shell
    git submodule update --init --recursive
    ```
- Generate the Makefiles and project:

    ```shell
    cmake -S . -B build/
    ```
- Build the executable:

    ```shell
    cmake --build build --clean-first
    ```

The deliverable you can provision onto the Microvisor Nucleo Development Board will be built to `build/Demo/gpio_toggle_demo.elf`.

To deploy the build, create a Microvisor application bundle using the [Bundler tool](https://github.com/twilio/twilio-microvisor-tools/). The Bundler repo is included as a submodule of this project.

## Updates

Update the repo’s submodules to their remotes’ latest commits with:

```shell
cd /path/to/twilio-microvisor-freertos
git submodule update --init --remote --recursive
```

## Support/Feedback

Please contact [Twilio Support](https://support.twilio.com/).

## Copyright

The sample code is © 2022, Twilio, Inc.

FreeRTOS is © 2021, Amazon Web Services, Inc
