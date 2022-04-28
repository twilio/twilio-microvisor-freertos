cmake_minimum_required(VERSION 3.12)

set(CMAKE_TOOLCHAIN_FILE "${CMAKE_SOURCE_DIR}/toolchain.cmake")

find_program(OPENSSL "openssl")

set(DEBUG_AUTH_PUBKEY "" CACHE STRING "Debug authentication key")

project(gpio_toggle_demo.elf C ASM)

include_directories(include
                    ${twilio-microvisor-hal-stm32u5_INCLUDE_DIRS})

set(INCLUDED_HAL_FILES
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_cortex.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dma.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_dma_ex.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_exti.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_flash.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_flash_ex.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_gpio.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_gtzc.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_i2c.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_i2c_ex.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_icache.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_pwr.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_pwr_ex.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_rcc.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_rcc_ex.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_tim.c
  Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_tim_ex.c
  Drivers/CMSIS/Device/ST/STM32U5xx/Source/Templates/system_stm32u5xx_ns.c
  Drivers/CMSIS/Device/ST/STM32U5xx/Source/Templates/gcc/startup_stm32u585xx.s
)
set(CONFIG_DIRECTORY
  "${CMAKE_SOURCE_DIR}/Config"
)
add_subdirectory(twilio-microvisor-hal-stm32u5)

add_library(ST_Code STATIC
  ST_Code/Core/Src/syscalls.c ST_Code/Core/Src/sysmem.c
  ST_Code/Core/Src/stm32u5xx_hal_msp.c
  ST_Code/CMSIS_RTOS_V2/cmsis_os2.c
)

target_include_directories(ST_Code PUBLIC
  ST_Code/CMSIS_RTOS_V2
  ST_Code/Core/Inc
)

target_link_libraries(ST_Code LINK_PUBLIC twilio-microvisor-hal-stm32u5 FreeRTOS)

add_library(FreeRTOS STATIC
  FreeRTOS-Kernel/croutine.c
  FreeRTOS-Kernel/event_groups.c
  FreeRTOS-Kernel/list.c
  FreeRTOS-Kernel/queue.c
  FreeRTOS-Kernel/stream_buffer.c
  FreeRTOS-Kernel/tasks.c
  FreeRTOS-Kernel/timers.c
  FreeRTOS-Kernel/portable/GCC/ARM_CM33_NTZ/non_secure/port.c
  FreeRTOS-Kernel/portable/GCC/ARM_CM33_NTZ/non_secure/portasm.c
  FreeRTOS-Kernel/portable/MemMang/heap_4.c
)

target_include_directories(FreeRTOS PUBLIC
  Config/
  FreeRTOS-Kernel/include
  FreeRTOS-Kernel/portable/GCC/ARM_CM33_NTZ/non_secure
)

add_subdirectory(Demo)

unset(CONFIG_DIRECTORY)
