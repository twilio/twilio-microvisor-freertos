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

Two bundles will be generated for submission to Twilio:
 - `build/Demo/gpio_toggle_demo.debug.bundle` with remote debugging support
 - `build/Demo/gpio_toggle_demo.nodebug.bundle` with remote debugging turned off

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

Two bundles will be generated for submission to Twilio:
 - `build/Demo/gpio_toggle_demo.debug.bundle` with remote debugging support
 - `build/Demo/gpio_toggle_demo.nodebug.bundle` with remote debugging turned off

## Support/Feedback

Please contact [Twilio Support](https://support.twilio.com/).

## Copyright

The sample code is © 2021, Twilio, Inc.

FreeRTOS is © 2021, Amazon Web Services, Inc
